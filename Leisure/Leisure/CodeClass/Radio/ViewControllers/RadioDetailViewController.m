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

@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 电台列表 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 电台主题详情列表 */
@property (nonatomic, strong) NSMutableArray *detailListArray;
/** 播放列表 */
@property (nonatomic, strong) NSMutableArray *playListArray;

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
    parDic[@"radioid"] = self.model.radioid;
    parDic[@"auth"] = @"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P";
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:parDic finish:^(NSData *data) {
        if (data == nil) return ;
        // 创建线程，异步处理数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            NSDictionary *headDict = dict[@"data"][@"radioInfo"];
            RadioDetailInfoModel *model =[[RadioDetailInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:headDict];
            
            NSArray *listArray = dict[@"data"][@"list"];
            for (NSDictionary *dic in listArray) {
                RadioDetailInfoModel *listModel = [[RadioDetailInfoModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                [self.detailListArray addObject:listModel];
                // 播放列表数据源
                [self.playListArray addObject:dic[@"musicUrl"]];
            }
            
            // 请求后数据后，返回主线程刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    } error:^(NSError *error) {
        SQLog(@"error : %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册Cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DetailCellID];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellID forIndexPath:indexPath];
    RadioDetailListModel *model = self.detailListArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

/**
 *  点击cell执行的方法
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RadioDetailListModel *model = self.detailListArray[indexPath.row];
    SQLog(@"model = %@", model);
}

@end
