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
    _bar.titleLabel.text = @"阅读";
    [navView addSubview:_bar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加自定义NavigationBar
    [self initNavigationBar];
}

/**
 *  可以在这个方法中芥蓝所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果push进来的不是第一个控制器
    if (self.childViewControllers.count > 0) {
        [_bar.menuButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _bar.titleLabel.text = @"";
    }
    
    // 这句super的push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
