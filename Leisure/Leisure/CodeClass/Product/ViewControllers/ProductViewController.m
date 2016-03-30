//
//  ProductViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"
#import "ProductInfoViewController.h"

@interface ProductViewController ()

/** 请求开始位置 */
@property (nonatomic, assign) NSInteger start;
/** 请求的个数 */
@property (nonatomic, assign) NSInteger limit;
/** 良品列表数据 */
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ProductViewController

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
            ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] init];
            ProductListModel *model = self.listArray[0];
            infoVC.contentid = model.contentid;
            [self.navigationController pushViewController:infoVC animated:YES];
        });
        
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    self.navigationItem.title = @"良品";
    
    // 加载数据
    [self loadData];
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
