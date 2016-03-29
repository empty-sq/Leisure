//
//  RadioViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioDetailViewController.h"
#import "RadioCarouselModel.h"
#import "RadioAlllistModel.h"

@interface RadioViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 滚动视图列表数据源 */
@property (nonatomic, strong) NSMutableArray *carouselArray;
/** 电台主题列表数据源 */
@property (nonatomic, strong) NSMutableArray *alllistArray;

/** 电台主题列表 */
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/** 滚动列表根视图 */
@property (nonatomic, strong) UIView *headView; 

@end

@implementation RadioViewController

static NSString * const RadioCellID = @"radioCell";

#pragma mark -懒加载，创建数据源容器-

- (NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}

- (NSMutableArray *)alllistArray {
    if (!_alllistArray) {
        self.alllistArray = [NSMutableArray array];
    }
    return _alllistArray;
}

#pragma mark -数据请求-

/**
 *  加载数据
 */
- (void)loadData {
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"client"] = @"1";
    parDic[@"deviceid"] = @"63A94D37-33F9-40FF-9EBB-481182338873";
    parDic[@"auth"] = @"";
    parDic[@"version"] = @"3.0.2";
    [NetWorkRequestManager requestWithType:POST urlString:RADIOLIST_URL parDic:parDic finish:^(NSData *data) {
        if (data == nil) return ;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            // 获取滚动列表数据
            NSArray *carouselArr = dataDict[@"data"][@"carousel"];
            for (NSDictionary *dic in carouselArr) {
                RadioCarouselModel *model = [[RadioCarouselModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.carouselArray addObject:model];
            }
            
            // 获取电台主题列表数据
            NSArray *alllistArr = dataDict[@"data"][@"alllist"];
            for (NSDictionary *dic in alllistArr) {
                RadioAlllistModel *model = [[RadioAlllistModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.alllistArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 创建滚动视图
                [self createCycleScrollView];
                // 刷新主题列表
                [self.mainTableView reloadData];
            });
        });
    } error:^(NSError *error) {
        
    }];
}

/**
 *  创建tableView
 */
- (void)setupTableView {
    // 注册cell
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RadioCellID];
    
    // 设置tableView的headView
    CGFloat width = self.view.width;
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 230)];
    self.headView.backgroundColor = [UIColor purpleColor];
    self.mainTableView.tableHeaderView = self.headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"电台";
    
    // 创建tableView
    [self setupTableView];
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  创建滚动视图
 */
- (void)createCycleScrollView {
//    SQLog(@"%s", __func__);
}

#pragma mark -<UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alllistArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RadioCellID forIndexPath:indexPath];
    RadioAlllistModel *model = self.alllistArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RadioAlllistModel *model = self.alllistArray[indexPath.row];
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    radioDetailVC.model = model;
    [self.navigationController pushViewController:radioDetailVC animated:YES];
}

@end
