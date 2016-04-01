//
//  TopicViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"
#import "topicTableViewCell.h"
#import "DrawerViewController.h"

@interface TopicViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    /** 标记请求类型 0 addtime 最新 1 hot 热门 */
    NSInteger sortType;
}

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

/** navigationBar的item */
@property (nonatomic, strong) UIButton *leftBtn;
/** navigationBar的item */
@property (nonatomic, strong) UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

/** 最新列表数据源 */
@property (nonatomic, strong) NSMutableArray *addtimeListArray;
/** 热门数据源 */
@property (nonatomic, strong) NSMutableArray *hotListArray;
/** 最新数据列表 */
@property (weak, nonatomic) IBOutlet UITableView *addtimeTableView;
/** 热门数据列表 */
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;

@end

@implementation TopicViewController

static NSString * const TopicCellID = @"topicCell";

#pragma mark -懒加载
- (NSMutableArray *)addtimeListArray {
    if (_addtimeListArray == nil) {
        _addtimeListArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addtimeListArray;
}

- (NSMutableArray *)hotListArray {
    if (_hotListArray == nil) {
        _hotListArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotListArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadDataWithSort:(NSString *)sort {
    _start = 0;
    _limit = 10;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sort"] = sort;
    params[@"client"] = @"1";
    params[@"start"] = @(_start);
    params[@"limit"] = @(_limit);
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:params finish:^(NSData *data) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        // 获取列表数据
        NSArray *listArr = dataDict[@"data"][@"list"];
        for (NSDictionary *dict in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfoModel = [[TopicUserInfoModel alloc] init];
            TopicCounterListModel *counterListModel = [[TopicCounterListModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:dict];
            [counterListModel setValuesForKeysWithDictionary:dict[@"counterList"]];
            [userInfoModel setValuesForKeysWithDictionary:dict[@"userinfo"]];
            
            listModel.userInfo = userInfoModel;
            listModel.counter = counterListModel;
            
            if (0 == sortType) {
                [self.addtimeListArray addObject:listModel];
            } else {
                [self.hotListArray addObject:listModel];
            }
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 == sortType) {
                [self.addtimeTableView reloadData];
            } else {
               [self.hotTableView reloadData];
            }
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)setupNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 14, 15, 30)];
    _leftBtn.selected = YES;
    [_leftBtn setImage:[UIImage imageNamed:@"NEW1"] forState:(UIControlStateNormal)];
    [_leftBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [bar addSubview:_leftBtn];
    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftBtn.right + 30, _leftBtn.top, _leftBtn.width, _leftBtn.height)];
    [_rightBtn setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [bar addSubview:_rightBtn];
    
    [self.view addSubview:bar];
}

- (void)leftButtonClick {
    if (_leftBtn.selected) return;
    if (self.addtimeListArray.count == 0) {
        [self loadDataWithSort:@"addtime"];
    }
    sortType = 0;
    _leftBtn.selected = YES;
    _rightBtn.selected = NO;
    [_leftBtn setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量
    [_rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightButtonClick {
    if (_rightBtn.selected) return ;
    if (self.hotListArray.count == 0) {
        [self loadDataWithSort:@"hot"];
    }
    sortType = 1;
    _leftBtn.selected = NO;
    _rightBtn.selected = YES;
    [_leftBtn setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量;
    [_rootScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

/**
 *  创建scrollView
 */
- (void)setupScrollView {
    _rootScrollView.delegate = self;
    _rootScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight);
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 注册tableView
    [self.addtimeTableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:TopicCellID];
    [self.hotTableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:TopicCellID];
    
    // 创建scrollView
    [self setupScrollView];
    
    // 默认是最新列表
    sortType = 0;
    
    // 添加自定义导航栏
    [self setupNavigationBar];
    
    // 加载最新数据
    [self loadDataWithSort:@"addtime"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 判断ScrollView偏移量调整右上按钮状态;
//    if (scrollView.contentOffset.x < kScreenWidth / 2) {
//        _leftBtn.selected = YES;
//        _rightBtn.selected = NO;
//        [_leftBtn setImage:[UIImage imageNamed:@"NEW1"] forState:(UIControlStateNormal)];
//        [_rightBtn setImage:[UIImage imageNamed:@"HOT2"] forState:(UIControlStateNormal)];
//    }
//    if (scrollView.contentOffset.x > kScreenWidth / 2) {
//        _leftBtn.selected = NO;
//        _rightBtn.selected = YES;
//        [_leftBtn setImage:[UIImage imageNamed:@"NEW2"] forState:(UIControlStateNormal)];
//        [_rightBtn setImage:[UIImage imageNamed:@"HOT1"] forState:(UIControlStateNormal)];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortType == 0 ? self.addtimeListArray.count : self.hotListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellID forIndexPath:indexPath];
    TopicListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeListArray[indexPath.row];
    } else {
        model = self.hotListArray[indexPath.row];
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeListArray[indexPath.row];
    } else {
        model = self.hotListArray[indexPath.row];
    }
    return [TopicTableViewCell cellHeightForModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

@end
