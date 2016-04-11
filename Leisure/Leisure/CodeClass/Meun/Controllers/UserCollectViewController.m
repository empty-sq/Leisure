//
//  UserCollectViewController.m
//  Leisure
//
//  Created by 沈强 on 16/4/11.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "UserCollectViewController.h"
#import "UserInfoManager.h"
#import "ReadDetailViewController.h"
#import "ReadInfoViewController.h"
#import "ReadTableViewCell.h"
#import "ReadDetailDB.h"

@interface UserCollectViewController ()

/** 收藏列表 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 收藏数据 */
@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString * const UserCellID = @"cell";

@implementation UserCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加自定义导航栏
    [self addCustomNavigationBar];
    
    // 注册tableView
    [self setupTableView];
    
    // 查询数据
    [self findDB];
}

/**
 *  查询数据
 */
- (void)findDB {
    ReadDetailDB *db = [[ReadDetailDB alloc] init];
    self.dataArray = [db findWithUserID:[UserInfoManager getUserID]];
    [self.tableView reloadData];
}

/**
 *  注册tableView
 */
- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadTableViewCell class]) bundle:nil] forCellReuseIdentifier:UserCellID];
}

#pragma mark -自定义导航栏，点击方法
/**
 *  添加自定义导航栏
 */
- (void)addCustomNavigationBar {
    self.navigationController.navigationBar.hidden = YES;
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    bar.titleLabel.text = @"收藏";
    
    [self.view addSubview:bar];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self findDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -<UITableViewDelegate, UITableViewDataSource>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadDetailListModel *model = self.dataArray[indexPath.row];
    ReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadDetailListModel *model = self.dataArray[indexPath.row];
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
    infoVC.ID = model.contentid;
    infoVC.model = model;
    [self.navigationController pushViewController:infoVC animated:NO];
}

@end
