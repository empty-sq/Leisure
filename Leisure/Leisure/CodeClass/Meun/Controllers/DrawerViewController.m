//
//  DrawerViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()

{
    /** 判断左菜单是否能够显示 */
    BOOL canShowLeft;
    /** 判断左菜单正在显示 */
    BOOL showingLeftView;
}

@end

@implementation DrawerViewController

@synthesize leftViewController = _left;
@synthesize rootViewController = _root;

/** 实现初始化方法 */
- (instancetype)initWithRootViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _root = viewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRootViewController:_root];
    
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:_tap];
        [_tap setEnabled:NO];
    }
}

- (void)setNavigationButtons {
    // 如果根视图控制器为空 直接跳出
    if (!_root) {
        return ;
    }
    
    // 设置根视图根视图控制器
    UIViewController *topController = nil;
    if ([_root isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)_root;
        if ([[navigationController viewControllers] count] > 0) {
            topController = [[navigationController viewControllers] objectAtIndex:0];
        }
    } else {
        topController = _root;
    }
    
    // 在根视图导航栏上添加左按钮
    if (canShowLeft) {
        [topController.navigationController setNavigationBarHidden:YES];
        CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
        [topController.view addSubview:bar];
        [bar.menuButton setBackgroundImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
        [bar.menuButton addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
        if ([@"ReadViewController" isEqualToString:NSStringFromClass([topController class])]) {
            bar.titleLabel.text = @"阅读";
        } else if ([@"RadioViewController" isEqualToString:NSStringFromClass([topController class])]) {
            bar.titleLabel.text = @"电台";
        } else if ([@"ProductViewController" isEqualToString:NSStringFromClass([topController class])]) {
            bar.titleLabel.text = @"良品";
        } else if ([@"TopicViewController" isEqualToString:NSStringFromClass([topController class])]) {
            bar.titleLabel.text = @"话题";
        }
    } else {
        topController.navigationItem.leftBarButtonItem = nil;
    }
}

/** 显示左菜单栏 */
- (void)showLeft:(id)sender {
    [self showLeftController:YES];
}

#pragma mark -单击手势
- (void)tap:(UITapGestureRecognizer *)gesture {
    [gesture setEnabled:NO];
    [self showRootController:YES];
}

/** 手势的代理方法 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _tap) {
        if (_root && showingLeftView) {
            // 设置单击手势能够响应的范围
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return  NO;
    }
    return YES;
}

#pragma  mark -显示视图-
- (void)showRootController:(BOOL)animated {
    // 让单击手势不能相应
    [_tap setEnabled:NO];
    // 设置根视图能够响应
    _root.view.userInteractionEnabled = YES;
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    [UIView animateWithDuration:.3 animations:^{
        _root.view.x = 0.0f;
    } completion:^(BOOL finished) {
        if (_left && _left.view.superview) {
            [_left.view removeFromSuperview];
        }
        showingLeftView = NO;
    }];
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
}

- (void)showLeftController:(BOOL)animated {
    // 如果菜单不能显示，直接跳出
    if (!canShowLeft) {
        return;
    }
    
    // 设置菜单正在显示的标记为yes
    showingLeftView = YES;
    
    UIView *view = self.leftViewController.view;
    CGRect frame = self.view.bounds;
    frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    [self.leftViewController viewWillAppear:animated];
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    } completion:^(BOOL finished) {
        // 激活单击手势
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
}

#pragma mark -设置根视图控制器对象和做菜单视图控制器对象
- (void)setLeftViewController:(UIViewController *)leftViewController {
    _left = leftViewController;
    canShowLeft = (_left != nil);
    [self setNavigationButtons];
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    UIViewController *tempRoot = _root;
    _root = rootViewController;
    if (_root) {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
    } else {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
    }
    [self setNavigationButtons];
}

- (void)setRootController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController) {
        [self setRootViewController:viewController];
        return;
    }
    
    if (showingLeftView) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        __block DrawerViewController *selfRef = self;
        __block UIViewController *rootRef = _root;
        
        CGFloat width = rootRef.view.width / 3 * 2;
        
        [UIView animateWithDuration:.3 animations:^{
            rootRef.view.x = width;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        [selfRef setRootViewController:viewController];
        _root.view.x = width;
        [selfRef showRootController:animated];
    } else {
        [self setRootViewController:viewController];
        [self showRootController:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

























