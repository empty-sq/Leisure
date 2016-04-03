//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailListModel.h"
#import "CustomNavigationBar.h"
#import "ReadTableViewCell.h"
#import "ReadInfoViewController.h"

@interface ReadDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
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

/** navigationBar的item */
@property (nonatomic, strong) UIButton *leftButton;
/** navigationBar的item */
@property (nonatomic, strong) UIButton *rightButton;
/** 加载最新数据起始位置 */
@property (nonatomic, assign) NSInteger startAddtime;
/** 加载人们数据起始位置 */
@property (nonatomic, assign) NSInteger startHot;
/** 判断是否已经加载过最新数据 */
@property (nonatomic, assign) BOOL isAddtime;
/** 判断是否已经加载过热门数据 */
@property (nonatomic, assign) BOOL isHot;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

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
}

- (void)loadDataWithSort:(NSString *)sort {
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"typeid"] = _listModel.type;
    if ([sort isEqualToString:@"addtime"]) {
        parDic[@"start"] = @(_startAddtime);
    } else {
        parDic[@"start"] = @(_startHot);
    }
    parDic[@"limit"] = @"10";
    parDic[@"sort"] = sort;
    self.params = parDic;
    [NetWorkRequestManager requestWithType:POST urlString:READDETAILLIST_URL parDic:parDic finish:^(NSData *data) {
        if (self.params != parDic) return ;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        if (0 ==_startHot) [self.hotDetailListArray removeAllObjects];
        if (0 == _startAddtime) [self.addtimeDetailListArray removeAllObjects];
        
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

/**
 *  注册tableViewCell，加载刷新
 */
- (void)registTableViewCell {
    [self.addtimeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReadDetailCellID];
    [self.hotTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReadDetailCellID];
    
    self.addtimeTableView.rowHeight = 160;
    self.hotTableView.rowHeight = self.addtimeTableView.rowHeight;
    
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
    // automaticallyAdjustsScrollViewInsets会根据NavigationBar、tabBar、status bar自动调整scrollview的inset，设置NO为手动修改
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册TableViewCell
    [self registTableViewCell];
    
    // 默认是最新列表
    sortType = 0;
    
    // 创建scrollView
    [self setupScrollView];
    
    // 添加自定义导航栏
    [self addCustomNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -自定义导航栏，点击方法
/**
 *  添加自定义导航栏
 */
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    bar.titleLabel.text = _listModel.name;
    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 14, 15, 30)];
    _leftButton.selected = YES;
    [_leftButton setImage:[UIImage imageNamed:@"NEW1"] forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [bar addSubview:_leftButton];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(_leftButton.right + 30, _leftButton.top, _leftButton.width, _leftButton.height)];
    [_rightButton setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [bar addSubview:_rightButton];
    
    [self.view addSubview:bar];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClick {
    if (_leftButton.selected) return;
    if (!_isAddtime) {
        // 进入刷新状态
        [self.addtimeTableView.mj_header beginRefreshing];
        [self loadAddtimeData];
    }
    sortType = 0;
    _leftButton.selected = YES;
    _rightButton.selected = NO;
    [_leftButton setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量
    [_rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightButtonClick {
    if (_rightButton.selected) return ;
    if (!_isHot) {
        // 进入刷新状态
        [self.hotTableView.mj_header beginRefreshing];
        [self loadHotData];
    }
    sortType = 1;
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    [_leftButton setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量;
    [_rootScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}


#pragma mark -<UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortType == 0 ? self.addtimeDetailListArray.count : self.hotDetailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReadDetailCellID];
    ReadDetailListModel *model = nil;
    if (sortType == 0) {
        model = self.addtimeDetailListArray[indexPath.row];
    } else {
        model = self.hotDetailListArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReadDetailListModel *model = nil;
    if (tableView == self.addtimeTableView) {
        model = self.addtimeDetailListArray[indexPath.row];
    } else {
        model = self.hotDetailListArray[indexPath.row];
    }
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
    infoVC.ID = model.contentid;
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end