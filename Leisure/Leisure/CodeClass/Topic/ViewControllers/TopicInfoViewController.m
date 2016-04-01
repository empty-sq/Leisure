//
//  TopicInfoViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "TopicInfoViewController.h"

@interface TopicInfoViewController ()

@end

@implementation TopicInfoViewController

#pragma mark 添加导航栏并实现点击方法
/**
 *  添加自定义导航栏
 */
- (void)addNavigationBar {
    CustomNavigationBar *navBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [navBar.menuButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:navBar];
    
    UIButton *commentButton = [UIButton buttonWithFrame:CGRectMake(kScreenWidth - 135, 14, 20, 15) image:@"评论2" target:self action:@selector(comment)];
    [navBar addSubview:commentButton];
    
    UIButton *likeButton = [UIButton buttonWithFrame:CGRectMake(commentButton.right + 30, commentButton.top, commentButton.width, commentButton.height) image:@"喜欢2"];
    [navBar addSubview:likeButton];
    
    UIButton *otherButton = [UIButton buttonWithFrame:CGRectMake(commentButton.right + 75, commentButton.top, 30, commentButton.height) image:@"其他"];
    [navBar addSubview:otherButton];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)comment {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加自定义导航栏
    [self addNavigationBar];
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
