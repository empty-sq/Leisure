//
//  CommentViewController.m
//  Leisure
//
//  Created by 沈强 on 16/4/8.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "KeyBoardView.h"
#import <MJRefresh.h>

@interface CommentViewController ()<UITableViewDataSource, UITableViewDelegate, KeyBoardViewDelegate>

/** 评论的列表 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 保存请求到的评论参数 */
@property (nonatomic, strong) NSMutableArray *commentArray;
/** 记录请求数据的索引 */
@property (nonatomic, assign) NSInteger start;
/** 记录最后一次请求参数 */
@property (nonatomic, strong) NSDictionary *params;
/** 评论的view */
@property (nonatomic, strong) KeyBoardView *keyView;
/** 键盘的高度 */
@property (nonatomic,assign) CGFloat keyBoardHeight;

@end

static NSString * const CommentCellID = @"cell";

@implementation CommentViewController

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建通知
    [self setupNotification];
    
    // 添加自定义导航栏
    [self addNavigationBar];
    
    // 注册tableView
    [self registerTableView];
    
    // 加载数据
    [self loadNewData];
}

/**
 *  创建通知
 */
- (void)setupNotification {
    //  键盘将要显示的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //  将要隐藏的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerTableView {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentCell class]) bundle:nil] forCellReuseIdentifier:CommentCellID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 上拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 下拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark -自定义导航栏
/**
 *  添加自定义导航栏
 */
- (void)addNavigationBar {
    // 添加自定义导航栏;
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [navBar.menuButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    navBar.titleLabel.text = @"评论";
    
    //  发表评论按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(kScreenWidth - 30, 11, 20, 20);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendpinglun"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:sendButton];
    
    [self.view addSubview:navBar];
}

- (void)addBtn {
    if(self.keyView==nil){
        self.keyView=[[KeyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    }
    //  设置键盘输入框
    self.keyView.delegate = self;
    [self.keyView.textView becomeFirstResponder];
    self.keyView.textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.keyView];
}

/**
 *  显示的方法
 */
-(void)keyboardShow:(NSNotification *)note {
    //  获取键盘的大小
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

/**
 *  隐藏的方法
 */
-(void)keyboardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.keyView.textView.text = @"";
        [self.keyView removeFromSuperview];
    }];
}

/**
 *  输入框的代理方法
 */
-(void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView {
    [contentView resignFirstResponder];
    //发送评论的接口请求
    [self requestSendComment:contentView.text];
}

/**
 *  发表评论
 */
- (void)requestSendComment:(NSString *)comment {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"auth"] = [UserInfoManager getUserAuth];
    parDic[@"contentid"] = _contentid;
    parDic[@"content"] = comment;
    self.params = parDic;
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/comment/add" parDic:parDic finish:^(NSData *data) {
        if (self.params != parDic) return;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSNumber *result = [dataDic objectForKey:@"result"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            // 发送成功
            if ([result intValue] == 1) {
                [self loadNewData];
            }
        });
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.keyView.textView resignFirstResponder];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -加载数据
/**
 *  加载最新数据
 */
- (void)loadNewData {
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"auth"] = [UserInfoManager getUserAuth];
    parDic[@"contentid"] = _contentid;
    parDic[@"start"] = @"0";
    parDic[@"limit"] = @"10";
    self.params = parDic;
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/comment/get" parDic:parDic finish:^(NSData *data) {
        if (self.params != parDic) return;
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.commentArray removeAllObjects];
        
        for (NSDictionary *dic in dataDic[@"data"][@"list"]) {
            // 创建model对象
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.total = 10;
            
            CommentUserModel *userInfo = [[CommentUserModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
            
            model.userInfo = userInfo;
            
            [self.commentArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CommentModel *model = self.commentArray[0];
            if (model.total > self.commentArray.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [SVProgressHUD dismiss];
            _start = 0;
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
        });
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData {
    NSInteger start = _start + 10;
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"auth"] = [UserInfoManager getUserAuth];
    parDic[@"contentid"] = _contentid;
    parDic[@"start"] = @(start);
    parDic[@"limit"] = @"10";
    self.params = parDic;
    [NetWorkRequestManager requestWithType:POST urlString:@"http://api2.pianke.me/comment/get" parDic:parDic finish:^(NSData *data) {
        if (self.params != parDic) return;
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in dataDic[@"data"][@"list"]) {
            // 创建model对象
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.total = 10 + start;
            
            CommentUserModel *userInfo = [[CommentUserModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
            
            model.userInfo = userInfo;
            
            [self.commentArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CommentModel *model = self.commentArray[self.commentArray.count - 1];
            if (model.total > self.commentArray.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [SVProgressHUD dismiss];
            [_tableView.mj_footer endRefreshing];
            _start = start;
            [_tableView reloadData];
        });
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableView的代理方法-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CommentCell cellHeightForModel:self.commentArray[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.commentArray.count == 0);
    return self.commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = self.commentArray[indexPath.row];
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.keyView.textView resignFirstResponder];
}

@end
