//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailListModel.h"

@interface ReadDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    /** 标记请求类型 0 addtime 最新 1 hot 热门 */
    NSInteger sortType;
}

/** 列表的根视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
/** 最新列表视图 */
@property (weak, nonatomic) IBOutlet UITableView *addtimeTableView;
/** 热门列表视图 */
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;

/** 最新列表数据源 */
@property (nonatomic, strong) NSMutableArray *addtimeDetailListArray;
/** 热门数据源 */
@property (nonatomic, strong) NSMutableArray *hotDetailListArray;

@end

@implementation ReadDetailViewController

static NSString * const ReadDetailCellID = @"ReadDetailListCell";

#pragma mark -懒加载
- (NSMutableArray *)addtimeDetailListArray {
    if (!_addtimeDetailListArray) {
        self.addtimeDetailListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _addtimeDetailListArray;
}

- (NSMutableArray *)hotDetailListArray {
    if (!_hotDetailListArray) {
        self.hotDetailListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotDetailListArray;
}

/**
 *  创建scrollView
 */
- (void)setupScrollView {
    _rootScrollView.delegate = self;
    _rootScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight);
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    
    [_addtimeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReadDetailCellID];
    [_hotTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReadDetailCellID];
}

- (void)loadDataWithSort:(NSString *)sort {
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"typeid"] = _typeID;
    parDic[@"start"] = @"0";
    parDic[@"sort"] = sort;
    [NetWorkRequestManager requestWithType:POST urlString:READDETAILLIST_URL parDic:parDic finish:^(NSData *data) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        // 获取数据列表
        NSArray *listArray = dataDict[@"data"][@"list"];
        for (NSDictionary *dict in listArray) {
            ReadDetailListModel *model = [[ReadDetailListModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.contentid = dict[@"id"];
            if (0 == sortType) {
                [self.addtimeDetailListArray addObject:model];
            } else {
                [self.hotDetailListArray addObject:model];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新数据
            if (0 == sortType) {
                [self.addtimeTableView reloadData];
            } else {
                [self.hotTableView reloadData];
            }
        });
        
    } error:^(NSError *error) {
        SQLog(@"error : %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // automaticallyAdjustsScrollViewInsets会根据NavigationBar、tabBar、status bar自动调整scrollview的inset，设置NO为手动修改
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 默认是最新列表
    sortType = 0;
    
    // 创建scrollView
    [self setupScrollView];
    
    // 请求数据 默认第一次请求 addtime
    [self loadDataWithSort:@"addtime"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)changeDetail:(UISegmentedControl *)sender {
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGPoint point = CGPointMake(sender.selectedSegmentIndex * ScreenWidth, 0);
    [_rootScrollView setContentOffset:point animated:YES];
    
    if (0 == sender.selectedSegmentIndex) {
        sortType = 0;
        if (self.addtimeDetailListArray.count != 0) return ;
        [self loadDataWithSort:@"addtime"];
    } else {
        sortType = 1;
        if (self.hotDetailListArray.count != 0) return ;
        [self loadDataWithSort:@"hot"];
    }
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {
        int num = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
        if (0 == num) {
            sortType = 0;
            if (self.addtimeDetailListArray.count != 0) return ;
            [self loadDataWithSort:@"addtime"];
        } else {
            sortType = 1;
            if (self.hotDetailListArray.count != 0) return ;
            [self loadDataWithSort:@"hot"];
        }
    }
}

#pragma mark -<UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortType == 0 ? self.addtimeDetailListArray.count : self.hotDetailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReadDetailCellID forIndexPath:indexPath];
    ReadDetailListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeDetailListArray[indexPath.row];
    } else {
        model = self.hotDetailListArray[indexPath.row];
    }
    cell.textLabel.text = model.title;
    return cell;
}

@end








































