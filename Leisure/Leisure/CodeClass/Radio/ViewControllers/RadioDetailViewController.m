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
/** 播放列表 */
@property (nonatomic, strong) NSMutableArray *playListArray;
/** tableView的headView */
@property (nonatomic, strong) RadioDetailHeaderView *headView;

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

/**
 *  请求数据
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
            
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *dic in listArray) {
                RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                [self.detailListArray addObject:listModel];
                // 播放列表数据源
                [self.playListArray addObject:dic[@"musicUrl"]];
            }
            
            NSDictionary *headDict = dict[@"data"][@"radioInfo"];
            RadioDetailInfoModel *model =[[RadioDetailInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:headDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _headView.model = model;
                
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
    RadioDetailListModel *model = self.detailListArray[indexPath.row];
    RadioPlayViewController *playVC = [[RadioPlayViewController alloc] init];
    playVC.model = model;
    playVC.listDataArray = self.detailListArray;
    [self.navigationController pushViewController:playVC animated:YES];
}

@end
