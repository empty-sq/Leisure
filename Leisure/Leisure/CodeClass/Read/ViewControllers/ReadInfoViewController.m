//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadInfoViewController.h"

@interface ReadInfoViewController ()

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
        NSDictionary *dataDict = dict[@"data"];
        SQLog(@"%@", dataDict);
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
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
    
    UIButton *setButton = [UIButton buttonWithFrame:CGRectMake(kScreenWidth - 180, 12, 15, 15) image:@"字体"];
    [navBar addSubview:setButton];
    
    UIButton *commentButton = [UIButton buttonWithFrame:CGRectMake(setButton.right + 30, setButton.top, setButton.width, setButton.height) image:@"评论2"];
    [navBar addSubview:commentButton];
    
    UIButton *likeButton = [UIButton buttonWithFrame:CGRectMake(setButton.right + 75, setButton.top, setButton.width, setButton.height) image:@"喜欢2"];
    [navBar addSubview:likeButton];
    
    UIButton *otherButton = [UIButton buttonWithFrame:CGRectMake(setButton.right + 120, setButton.top, 30, setButton.height) image:@"其他"];
    [navBar addSubview:otherButton];
    
    [self.view addSubview:navBar];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
