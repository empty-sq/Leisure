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
    
    // 添加tableView
    [self setupTableView];
}

#pragma mark -添加tableView、实现点击事件
/**
 *  添加tableView
 */
- (void)setupTableView {
    // 添加表头
    _headView = [[MeunHeaderView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth * 2 / 3, 160)];
    [_headView.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
 *  登录按钮
 */
- (void)loginButtonClick {
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
