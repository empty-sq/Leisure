//
//  ProductViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"
#import "ProductTableViewCell.h"
#import "ProductInfoViewController.h"

@interface ProductViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 请求开始位置 */
@property (nonatomic, assign) NSInteger start;
/** 请求的个数 */
@property (nonatomic, assign) NSInteger limit;
/** 良品列表数据 */
@property (nonatomic, strong) NSMutableArray *listArray;
/** 良品列表 */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProductViewController

static NSString * const ProductCellID = @"ProductCell";

#pragma mark -懒加载
- (NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"start"] = @(_start);
    params[@"limit"] = @(_limit);
    [NetWorkRequestManager requestWithType:POST urlString:SHOPLIST_URL parDic:params finish:^(NSData *data) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves error:nil];
        NSArray *array = dataDict[@"data"][@"list"];
        
        // 解析数据
        for (NSDictionary *dict in array) {
            ProductListModel *model = [[ProductListModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.listArray addObject:model];
        }
        
        // 返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新数据
            [_tableView reloadData];
        });
        
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

/**
 *  创建tableView
 */
- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = (kScreenWidth - 20) * 300 / 608 + 50;
    
    // 注册自定义单元格
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductTableViewCell class]) bundle:nil] forCellReuseIdentifier:ProductCellID];
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建tableView
    [self setupTableView];
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellID];
    ProductListModel *model = _listArray[indexPath.row];
    [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyBtn.tag = indexPath.row + 1000;
    cell.model = model;
    return cell;
}

/**
 *  点击购买触发的事件
 */
- (void)buyClick:(UIButton *)button {
    ProductListModel *model = _listArray[button.tag - 1000];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.buyurl]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] init];
    ProductListModel *model = _listArray[indexPath.row];
    infoVC.contentid = model.contentid;
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
