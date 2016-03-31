//
//  BaseNavigationController.m
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()



@end

@implementation BaseNavigationController

- (void)initNavigationBar {
    // 隐藏自带的NavigationBar
    [self setNavigationBarHidden:YES];
    // 设置view的大小
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 64)];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    // 创建自定义NavigationBar
    _bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
//    _bar.titleLabel.text = @"测试";
    [navView addSubview:_bar];
}

- (void)viewDidLoad {
//    [super viewDidLoad];
    
    // 添加自定义NavigationBar
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
