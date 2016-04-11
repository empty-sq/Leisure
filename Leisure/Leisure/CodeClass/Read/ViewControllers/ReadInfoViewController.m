//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "ReadInfoModel.h"
#import "CommentViewController.h"
#import "LoginRegisterViewController.h"
#import "ReadDetailDB.h"
#import "DrawerViewController.h"

@interface ReadInfoViewController ()

@property (nonatomic, strong) ReadInfoModel *readInfo;
//@property (no)

@end

@implementation ReadInfoViewController

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadData {
    NSMutableDictionary *parDict = [NSMutableDictionary dictionary];
    parDict[@"auth"] = @"";
    parDict[@"client"] = @"1";
    parDict[@"contentid"] = _ID;
    [NetWorkRequestManager requestWithType:POST urlString:READCONTENT_URL parDic:parDict finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.readInfo = [[ReadInfoModel alloc] init];
        [self.readInfo setValuesForKeysWithDictionary:dict[@"data"]];
        
        ReadInfoCounterModel *counter = [[ReadInfoCounterModel alloc] init];
        [counter setValuesForKeysWithDictionary:dict[@"data"][@"counterList"]];
        
        ReadShareinfoModel *shareInfo = [[ReadShareinfoModel alloc] init];
        [shareInfo setValuesForKeysWithDictionary:dict[@"data"][@"shareinfo"]];
        
        self.readInfo.counter = counter;
        self.readInfo.shareInfo = shareInfo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
            //修改后的效果
            //把原来的html通过importStyleWithHtmlString进行替换，修改html的布局
            NSString *newString = [NSString importStyleWithHtmlString:self.readInfo.html];
            //baseURL可以让界面加载的时候按照本地样式去加载
            NSURL *baseURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
            
            [webView loadHTMLString:newString baseURL:baseURL];
            [self.view addSubview:webView];
        });
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -自定义导航栏
/**
 *  添加自定义导航栏
 */
- (void)addNavigationBar {
    // 添加自定义导航栏;
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [navBar.menuButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *shareBtn = [UIButton buttonWithFrame:CGRectMake(kScreenWidth - 90, 12, 20, 20) image:@"fenxiang"];
    [navBar addSubview:shareBtn];
    
    UIButton *msgBtn = [UIButton buttonWithFrame:CGRectMake(shareBtn.right + 10, shareBtn.top, shareBtn.width, shareBtn.height) image:@"cpinglun"];
    [msgBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:msgBtn];
    
    UIButton *likeButton = [UIButton buttonWithFrame:CGRectMake(shareBtn.right + 40, shareBtn.top, shareBtn.width, shareBtn.height) image:@"cshoucang"];
    [likeButton addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:likeButton];
    
    [self.view addSubview:navBar];
    
    // 查询本条信息是否已经存储，如果已经存储，按钮显示已经收藏状态
    ReadDetailDB *db = [[ReadDetailDB alloc] init];
    NSArray *array = [db findWithUserID:[UserInfoManager getUserID]];
    for (ReadDetailListModel *model in array) {
        if ([model.title isEqualToString:self.model.title]) {
            [likeButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
            break;
        }
    }
}

/**
 *  收藏按钮点击事件
 */
- (void)collectClick:(UIButton *)button {
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) { // 如果用户已经登录，直接收藏
        // 创建数据表
        ReadDetailDB *db = [[ReadDetailDB alloc] init];
        [db createDataTable];
        // 查询数据是否存储，如果存储就取消存储
        NSArray *array = [db findWithUserID:[UserInfoManager getUserID]];
        for (ReadDetailListModel *model in array) {
            if ([model.title isEqualToString:_model.title]) {
                [db deleteDetailWithTitle:self.model.title];
                [button setBackgroundImage:[UIImage imageNamed:@"cshoucang"] forState:UIControlStateNormal];
                return;
            }
        }
        // 否则，调用保存方法进行存储
        [db saveDetailModel:self.model];
        [button setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    } else {
        LoginRegisterViewController *loginVC = [[LoginRegisterViewController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        DrawerViewController *vc = (DrawerViewController *)window.rootViewController;
        [vc presentViewController:loginVC animated:YES completion:nil];
    }
}

/**
 *  评论按钮点击事件
 */
- (void)commentClick {
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.contentid = _ID;
        [self.navigationController pushViewController:commentVC animated:YES];
    } else {
        LoginRegisterViewController *loginVC = [[LoginRegisterViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 添加自定义NavigationBar
    [self addNavigationBar];
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
