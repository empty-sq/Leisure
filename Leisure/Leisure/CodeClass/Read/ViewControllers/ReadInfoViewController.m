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

@interface ReadInfoViewController ()

@property (nonatomic, strong) ReadInfoModel *readInfo;

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
    
    UIButton *likeButton = [UIButton buttonWithFrame:CGRectMake(shareBtn.right + 40, shareBtn.top, shareBtn.width, shareBtn.height) image:@"shoucang"];
    [navBar addSubview:likeButton];
    
    [self.view addSubview:navBar];
}

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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
