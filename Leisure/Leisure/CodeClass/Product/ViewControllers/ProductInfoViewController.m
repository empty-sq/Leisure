//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductCommentlistModel.h"

@interface ProductInfoViewController ()

/** 用户评论数据源 */
@property (nonatomic, strong) NSMutableArray *commentListArray;
@property (nonatomic, strong) NSMutableArray *userInfoArray;

@end

@implementation ProductInfoViewController

#pragma mark -懒加载
- (NSMutableArray *)commentListArray {
    if (!_commentListArray) {
        self.commentListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _commentListArray;
}

- (NSMutableArray *)userInfoArray {
    if (!_userInfoArray) {
        self.userInfoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _userInfoArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contentid"] = self.contentid;
    [NetWorkRequestManager requestWithType:POST urlString:SHOPINFO_URL parDic:params finish:^(NSData *data) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        // 获取评论列表数据
        NSArray *commentListArr = dataDict[@"data"][@"commentlist"];
        
        for (NSDictionary *dict in commentListArr) {
            // 创建model
            ProductCommentlistModel *model = [[ProductCommentlistModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            // 创建用户对象
            ProductUserInfoModel *userModel = [[ProductUserInfoModel alloc] init];
            [userModel setValuesForKeysWithDictionary:dict[@"userinfo"]];
            
            model.userInfo = userModel;
            
            [self.commentListArray addObject:userModel];
        }
        
        // 获取详情信息，用webView进行展示
        NSString *htmlContent = dataDict[@"data"][@"html"];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } error:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
