//
//  MeunViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "MeunViewController.h"
#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "ReadViewController.h"
#import "RadioViewController.h"
#import "TopicViewController.h"
#import "ProductViewController.h"
#import "MeunHeaderView.h"
#import "MeunFooterView.h"
#import "LoginRegisterViewController.h"
#import "UserInfoManager.h"
#import "UserCollectViewController.h"
#import "UserDownloadRadioViewController.h"

@interface MeunViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 菜单列表数据 */
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) UITableView *tableView;
/** 头部View */
@property (nonatomic, strong) MeunHeaderView *headView;
/** 尾部View */
@property (nonatomic, strong) MeunFooterView *footerView;

@end

@implementation MeunViewController

static NSString * const MeunCellID = @"TableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnAction:) name:@"username" object:nil];
    
    // 添加tableView
    [self setupTableView];
}

/**
 *  传值
 */
- (void)returnAction:(NSNotification *)name {
    [_headView.loginButton setTitle:name.userInfo[@"username"] forState:UIControlStateNormal];
}

#pragma mark -添加tableView、实现点击事件
/**
 *  添加tableView
 */
- (void)setupTableView {
    // 添加表头
    _headView = [[MeunHeaderView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth * 2 / 3, 160)];
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        [_headView.loginButton setTitle:[UserInfoManager getUserName] forState:UIControlStateNormal];
    }
    [_headView.downloadButton addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView.favoButton addTarget:self action:@selector(favoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headView];
    
    /** 添加列表数据 */
    _list = @[@"阅读", @"电台", @"话题", @"良品"];
     
    // 创建显示模块标题的列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth * 2 / 3, kScreenHeight - 240 + 60) style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(40, 40, 40);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    
    // 注册单元格
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MeunCellID];
    [self.view addSubview:_tableView];
    
    // 添加表尾
    _footerView = [[MeunFooterView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth * 2 / 3, 60)];
    [self.view addSubview:_footerView];
}

/**
 *  下载列表
 */
- (void)downloadClick {
    UserDownloadRadioViewController *download = [[UserDownloadRadioViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:download];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  收藏按钮
 */
- (void)favoBtnClick {
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        UserCollectViewController *userVC = [[UserCollectViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userVC];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        LoginRegisterViewController *loginVC = [[LoginRegisterViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

/**
 *  登录按钮
 */
- (void)loginButtonClick {
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登出" message:@"你确定要退出登录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [UserInfoManager cancelUserAuth];
            [UserInfoManager cancelUserID];
            [_headView.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_headView.loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        LoginRegisterViewController *loginVC = [[LoginRegisterViewController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        DrawerViewController *vc = (DrawerViewController *)window.rootViewController;
        [vc presentViewController:loginVC animated:YES completion:nil];
    }
    
}

#pragma mark -<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeunCellID];
    cell.textLabel.text = _list[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/** 选中Cell响应事件 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 获取抽屉对象
    DrawerViewController *menuController = (DrawerViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerViewController;
    
    if (indexPath.row == 0) { // 设置阅读为抽屉的根视图
        [self setRootViewController:[[ReadViewController alloc] init] menuController:menuController];
    } else if (indexPath.row == 1) { // 设置电台为抽屉的根视图
        [self setRootViewController:[[RadioViewController alloc] init] menuController:menuController];
    } else if (indexPath.row == 2) { // 设置话题为抽屉的根视图
        [self setRootViewController:[[TopicViewController alloc] init] menuController:menuController];
    } else if (indexPath.row == 3) { // 设置良品为抽屉的根视图
        [self setRootViewController:[[ProductViewController alloc] init] menuController:menuController];
    }
}

- (void)setRootViewController:(BaseViewController *)viewController menuController:(DrawerViewController *)menuController {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    // 点击选中单元格时，先删除原来视图，再添加新视图
    [navigationController.view removeFromSuperview];
    // 隐藏系统自带的导航栏
    navigationController.navigationBarHidden = YES;
    [menuController setRootController:navigationController animated:YES];
    NSString *name = [UserInfoManager getUserName];
    [_headView.loginButton setTitle:name forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
