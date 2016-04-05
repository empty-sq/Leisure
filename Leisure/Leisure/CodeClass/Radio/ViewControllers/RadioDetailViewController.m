//
//  RadioDetailViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioAlllistModel.h"
#import "RadioDetailInfoModel.h"
#import "RadioDetailListModel.h"
#import "RadioDetailCell.h"
#import "RadioDetailHeaderView.h"
#import "RadioPlayViewController.h"

@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 电台列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 电台主题详情列表 */
@property (nonatomic, strong) NSMutableArray *detailListArray;
/** 全部数据 */
@property (nonatomic, strong) NSMutableArray *allArray;
/** 全部音乐 */
@property (nonatomic, strong) NSMutableArray *allPlayArray;
/** 播放列表 */
@property (nonatomic, strong) NSMutableArray *playListArray;
/** tableView的headView */
@property (nonatomic, strong) RadioDetailHeaderView *headView;
/** 从第几条开始请求数据 */
@property (nonatomic, assign) NSInteger start;
/** 加载全部数据下标 */
@property (nonatomic, assign) NSInteger allStart;

@end

@implementation RadioDetailViewController

static NSString * const DetailCellID = @"detailTableViewCell";

#pragma mark -懒加载
- (NSMutableArray *)detailListArray {
    if (!_detailListArray) {
        self.detailListArray = [NSMutableArray array];
    }
    return _detailListArray;
}

- (NSMutableArray *)playListArray {
    if (!_playListArray) {
        self.playListArray = [NSMutableArray array];
    }
    return _playListArray;
}

- (NSMutableArray *)allArray {
    if (!_allArray) {
        self.allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableArray *)allPlayArray {
    if (!_allPlayArray) {
        self.allPlayArray = [NSMutableArray array];
    }
    return _allPlayArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadData {
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"radioid"] = _radioid;
    parDic[@"auth"] = @"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P";
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:parDic finish:^(NSData *data) {
        if (data == nil) return ;
        // 创建线程，异步处理数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            // 下拉刷新，清空数组
            [self.detailListArray removeAllObjects];
            [self.playListArray removeAllObjects];
            [self.allArray removeAllObjects];
            [self.allPlayArray removeAllObjects];
            
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *dic in listArray) {
                RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                listModel.uname = self.uname;
                [self.detailListArray addObject:listModel];
                [self.allArray addObject:listModel];
                // 播放列表数据源
                [self.playListArray addObject:dic[@"musicUrl"]];
                [self.allPlayArray addObject:dic[@"musicUrl"]];
            }
            
            NSDictionary *headDict = dict[@"data"][@"radioInfo"];
            RadioDetailInfoModel *model =[[RadioDetailInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:headDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 给NavigationItem一个标题
                _headView.model = model;
                
                // 结束刷新
                [self.tableView.mj_header endRefreshing];
                
                // 添加自定义导航栏
                [self addCustomNavigationBar];
            });
            
            // 请求后数据后，返回主线程刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    } error:^(NSError *error) {
        SQLog(@"error : %@", error);
    }];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData {
    _start += 10;
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"auth"] = @"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo";
    parDic[@"client"] = @"1";
    parDic[@"deviceid"] = @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31";
    parDic[@"limit"] = @"10";
    parDic[@"radioid"] = _radioid;
    parDic[@"start"] = @(_start);
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILMORE_URL parDic:parDic finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"data"][@"list"];
        for (NSDictionary *dic in array) {
            RadioDetailListModel *model = [[RadioDetailListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.uname = self.uname;
            // 获取总用有几条数据
            model.total = [dict[@"data"][@"total"] integerValue];
            [self.detailListArray addObject:model];
            // 播放列表数据源
            [self.playListArray addObject:dic[@"musicUrl"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RadioDetailListModel *model = self.detailListArray[self.detailListArray.count - 1];
            if (model.total == self.detailListArray.count) { // 如果已经获取到全部数据，上拉刷新变成提示没有更多信息
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else { // 否则结束刷新
                // 结束刷新
                [self.tableView.mj_footer endRefreshing];
            }
            
            // 刷新数据
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

/**
 *  加载全部数据
 */
- (void)loadAllData {
    _allStart += 10;
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"auth"] = @"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo";
    parDic[@"client"] = @"1";
    parDic[@"deviceid"] = @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31";
    parDic[@"limit"] = @"10";
    parDic[@"radioid"] = _radioid;
    parDic[@"start"] = @(_allStart);
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILMORE_URL parDic:parDic finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"data"][@"list"];
        for (NSDictionary *dic in array) {
            RadioDetailListModel *model = [[RadioDetailListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.uname = self.uname;
            // 获取总用有几条数据
            model.total = [dict[@"data"][@"total"] integerValue];
            [self.allArray addObject:model];
            // 播放列表数据源
            [self.allPlayArray addObject:dic[@"musicUrl"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RadioDetailListModel *model = self.allArray[self.allArray.count - 1];
            if (model.total == self.detailListArray.count) {
                // 刷新数据
                [self.tableView reloadData];
            }
            else { // 否则继续加载数据
                [self loadAllData];
            }
        });
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

#pragma mark -自定义导航栏，点击方法
/**
 *  添加自定义导航栏
 */
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    bar.titleLabel.text = _headView.model.title;
    
    [self.view addSubview:bar];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -初始化tableView
/**
 *  初始化tableView
 */
- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
    
    // 初始化tableView的headview
    _headView = [[RadioDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    _tableView.tableHeaderView = _headView;
    
    // 添加上拉、下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioDetailCell class]) bundle:nil] forCellReuseIdentifier:DetailCellID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 关闭自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化tableView
    [self setupTableView];
    
    // 加载数据
    [self loadData];
    
    // 加载全部数据
    [self loadAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellID forIndexPath:indexPath];
    RadioDetailListModel *model = self.detailListArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  点击cell执行的方法
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.detailListArray = self.allArray;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    RadioDetailListModel *model = self.detailListArray[indexPath.row];
    RadioPlayViewController *playVC = [[RadioPlayViewController alloc] init];
    playVC.model = model;
    playVC.listDataArray = self.allArray;
    playVC.index = indexPath.row;
    [self.navigationController pushViewController:playVC animated:YES];
}

@end
