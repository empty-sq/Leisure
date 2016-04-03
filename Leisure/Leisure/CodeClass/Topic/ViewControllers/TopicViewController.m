//
//  TopicViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"
#import "topicTableViewCell.h"
#import "DrawerViewController.h"
#import "TopicInfoViewController.h"

@interface TopicViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    /** 标记请求类型 0 addtime 最新 1 hot 热门 */
    NSInteger sortType;
}

/** 加载最新数据起始位置 */
@property (nonatomic, assign) NSInteger startAddtime;
/** 加载人们数据起始位置 */
@property (nonatomic, assign) NSInteger startHot;
/** 加载数据条数 */
@property (nonatomic, assign) NSInteger limit;

/** navigationBar的item */
@property (nonatomic, strong) UIButton *leftBtn;
/** navigationBar的item */
@property (nonatomic, strong) UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic, strong) CustomNavigationBar *bar;

/** 最新列表数据源 */
@property (nonatomic, strong) NSMutableArray *addtimeListArray;
/** 热门数据源 */
@property (nonatomic, strong) NSMutableArray *hotListArray;
/** 最新数据列表 */
@property (weak, nonatomic) IBOutlet UITableView *addtimeTableView;
/** 热门数据列表 */
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 判断是否已经加载过最新数据 */
@property (nonatomic, assign) BOOL isAddtime;
/** 判断是否已经加载过热门数据 */
@property (nonatomic, assign) BOOL isHot;

@end

@implementation TopicViewController

static NSString * const TopicCellID = @"topicCell";

#pragma mark -懒加载
- (NSMutableArray *)addtimeListArray {
    if (_addtimeListArray == nil) {
        _addtimeListArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addtimeListArray;
}

- (NSMutableArray *)hotListArray {
    if (_hotListArray == nil) {
        _hotListArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotListArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadDataWithSort:(NSString *)sort {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sort"] = sort;
    params[@"client"] = @"1";
    if ([sort isEqualToString:@"addtime"]) {
        params[@"start"] = @(_startAddtime);
    } else {
        params[@"start"] = @(_startHot);
    }
    params[@"limit"] = @(_limit);
    self.params = params;
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:params finish:^(NSData *data) {
        if (self.params != params) return ;
        
        if (0 ==_startHot) [self.hotListArray removeAllObjects];
        if (0 == _startAddtime) [self.addtimeListArray removeAllObjects];
        
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
            
            if (0 == sortType) {
                [self.addtimeListArray addObject:listModel];
            } else {
                [self.hotListArray addObject:listModel];
            }
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 == sortType) {
                _isAddtime = 1;
                // 显示footer
                self.addtimeTableView.mj_footer.hidden = NO;
                // 结束刷新
                [self.addtimeTableView.mj_header endRefreshing];
                [self.addtimeTableView.mj_footer endRefreshing];
                [self.addtimeTableView reloadData];
            } else {
                _isHot = 1;
                // 显示footer
                self.hotTableView.mj_footer.hidden = NO;
                // 结束刷新
                [self.hotTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
                [self.hotTableView reloadData];
            }
        });
    } error:^(NSError *error) {
       SQLog(@"error : %@", error);
    }];
}

- (void)setupNavigationBar {
    _bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 14, 15, 30)];
    _leftBtn.selected = YES;
    [_leftBtn setImage:[UIImage imageNamed:@"NEW1"] forState:(UIControlStateNormal)];
    [_leftBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_bar addSubview:_leftBtn];
    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftBtn.right + 30, _leftBtn.top, _leftBtn.width, _leftBtn.height)];
    [_rightBtn setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_bar addSubview:_rightBtn];
    
    [self.view addSubview:_bar];
}

- (void)leftButtonClick {
    if (_leftBtn.selected) return;
    if (!_isAddtime) {
        // 进入刷新状态
        [self.addtimeTableView.mj_header beginRefreshing];
        [self loadAddtimeData];
    }
    sortType = 0;
    _leftBtn.selected = YES;
    _rightBtn.selected = NO;
    [_leftBtn setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量
    [_rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightButtonClick {
    if (_rightBtn.selected) return ;
    if (!_isHot) {
        // 进入刷新状态
        [self.hotTableView.mj_header beginRefreshing];
        [self loadHotData];
    }
    sortType = 1;
    _leftBtn.selected = NO;
    _rightBtn.selected = YES;
    [_leftBtn setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量;
    [_rootScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
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
}


#pragma mark -刷新控件、注册tableView
/**
 *  注册tableView并添加刷新控件
 */
- (void)setupTableViewAndRefresh {
    // 注册tableView
    [self.addtimeTableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:TopicCellID];
    [self.hotTableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:TopicCellID];
    
    // 请求条数
    _limit = 10;
    
    // 上拉刷新
    self.addtimeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAddtimeData)];
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHotData)];
    
    // 下拉刷新
    self.addtimeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAddtimeData)];
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
    
    self.addtimeTableView.mj_footer.hidden = YES;
    
    // 进入刷新状态
    [self.addtimeTableView.mj_header beginRefreshing];
    [self loadAddtimeData];
}

/**
 *  加载最新数据
 */
- (void)loadAddtimeData {
    // 隐藏下拉刷新
    self.addtimeTableView.mj_footer.hidden = YES;
    _startAddtime = 0;
    // 请求最新数据
    [self loadDataWithSort:@"addtime"];
}

/**
 *  加载更多最新数据
 */
- (void)loadMoreAddtimeData {
    _startAddtime += 10;
    [self loadDataWithSort:@"addtime"];
}

/**
 *  加载热门数据
 */
- (void)loadHotData {
    // 隐藏下拉刷新
    self.hotTableView.mj_footer.hidden = YES;
    _startHot = 0;
    // 请求热门数据
    [self loadDataWithSort:@"hot"];
}

/**
 *  加载更多热门数据
 */
- (void)loadMoreHotData {
    _startHot += 10;
    [self loadDataWithSort:@"hot"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册tableView并添加刷新控件
    [self setupTableViewAndRefresh];
    
    // 创建scrollView
    [self setupScrollView];
    
    // 默认是最新列表
    sortType = 0;
    
    // 添加自定义导航栏
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortType == 0 ? self.addtimeListArray.count : self.hotListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicCellID forIndexPath:indexPath];
    TopicListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeListArray[indexPath.row];
    } else {
        model = self.hotListArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeListArray[indexPath.row];
    } else {
        model = self.hotListArray[indexPath.row];
    }
    return [TopicTableViewCell cellHeightForModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TopicInfoViewController *infoVC = [[TopicInfoViewController alloc] init];
    TopicListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeListArray[indexPath.row];
    } else {
        model = self.hotListArray[indexPath.row];
    }
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
