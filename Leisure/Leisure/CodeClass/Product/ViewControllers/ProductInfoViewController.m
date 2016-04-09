//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductCommentlistModel.h"
#import "CommentViewController.h"
#import "LoginRegisterViewController.h"

@interface ProductInfoViewController ()

/** 用户评论数据源 */
@property (nonatomic, strong) NSMutableArray *commentListArray;
@property (nonatomic, strong) NSMutableArray *userInfoArray;

@end

@implementation ProductInfoViewController

#pragma mark -懒加载
- (NSMutableArray *)commentListArray {
    if (!_commentListArray) {
        self.commentListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _commentListArray;
}

- (NSMutableArray *)userInfoArray {
    if (!_userInfoArray) {
        self.userInfoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _userInfoArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadData {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contentid"] = self.contentid;
    [NetWorkRequestManager requestWithType:POST urlString:SHOPINFO_URL parDic:params finish:^(NSData *data) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
//        SQLog(@"%@", dataDict);
        
        // 获取评论列表数据
//        NSArray *commentListArr = dataDict[@"data"][@"commentlist"];
//        
//        for (NSDictionary *dict in commentListArr) {
//            // 创建model
//            ProductCommentlistModel *model = [[ProductCommentlistModel alloc] init];
//            [model setValuesForKeysWithDictionary:dict];
//            
//            // 创建用户对象
//            ProductUserInfoModel *userModel = [[ProductUserInfoModel alloc] init];
//            [userModel setValuesForKeysWithDictionary:dict[@"userinfo"]];
//            
//            model.userInfo = userModel;
//            
//            [self.commentListArray addObject:userModel];
//        }
        
        // 获取详情信息，用webView进行展示
        NSString *htmlContent = dataDict[@"data"][@"postsinfo"][@"html"];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
            //修改后的效果
            //把原来的html通过importStyleWithHtmlString进行替换，修改html的布局
            NSString *newString = [NSString importStyleWithHtmlString:htmlContent];
            //baseURL可以让界面加载的时候按照本地样式去加载
            NSURL *baseURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
            
            [webView loadHTMLString:newString baseURL:baseURL];
            [self.view addSubview:webView];
        });
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark 添加导航栏并实现点击方法
/**
 *  添加自定义导航栏
 */
- (void)addNavigationBar {
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [navBar.menuButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    navBar.titleLabel.text = _titleName;
    [self.view addSubview:navBar];
    
    UIButton *msgBtn = [UIButton buttonWithFrame:(CGRectMake(kScreenWidth - 60, 12, 20, 20)) image:@"cpinglun"];
    [msgBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:msgBtn];
    
    UIButton *likeButton = [UIButton buttonWithFrame:CGRectMake(msgBtn.right + 10, msgBtn.top, msgBtn.width, msgBtn.height) image:@"shoucang"];
    [navBar addSubview:likeButton];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentClick {
//    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
//        CommentViewController *commentVC = [[CommentViewController alloc] init];
//        commentVC.contentid = _contentid;
//        [self.navigationController pushViewController:commentVC animated:YES];
//    } else {
//        LoginRegisterViewController *loginVC = [[LoginRegisterViewController alloc] init];
//        [self presentViewController:loginVC animated:YES completion:nil];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加自定义导航栏
    [self addNavigationBar];
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end