//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioPlayViewController.h"

@interface RadioPlayViewController ()

/** 音乐轮播 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 页码 */
@property (nonatomic, strong) UIPageControl *pageControl;


@end

@implementation RadioPlayViewController

/**
 *  添加毛玻璃
 */
- (void)addBlur {
    // 添加背景
    UIImageView *bkgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    bkgImageView.image = [UIImage imageNamed:@"yejing"];
    [self.view addSubview:bkgImageView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:blurView];
}


#pragma mark -自定义导航栏，点击方法
/**
 *  添加自定义导航栏
 */
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    bar.titleLabel.text = @"";
    
    [self.view addSubview:bar];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 关闭控制器自动布局scrollView功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加毛玻璃
    [self addBlur];
    
    // 添加自定义导航栏
    [self addCustomNavigationBar];
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
