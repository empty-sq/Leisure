//
//  TopicViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"

@interface TopicViewController ()

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation TopicViewController

#pragma mark -懒加载
- (NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadDataWithSort:(NSString *)sort {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sort"] = sort;
    params[@"start"] = @(_start);
    params[@"limit"] = @(_limit);
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:params finish:^(NSData *data) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        // 获取列表数据
        NSArray *listArr = dataDict[@"data"][@"list"];
        for (NSDictionary *dict in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfoModel = [[TopicUserInfoModel alloc] init];
            TopicCounterListModel *counterListModel = [[TopicCounterListModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:dict];
            [counterListModel setValuesForKeysWithDictionary:dict[@"counterList"]];
            [userInfoModel setValuesForKeysWithDictionary:dict[@"userinfo"]];
            
            listModel.userInfo = userInfoModel;
            listModel.counter = counterListModel;
            
            [self.listArray addObject:listModel];
        }
        
        SQLog(@"%@", self.listArray);
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"话题";
    
    // 加载热门数据
    [self loadDataWithSort:@"hot"];
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
