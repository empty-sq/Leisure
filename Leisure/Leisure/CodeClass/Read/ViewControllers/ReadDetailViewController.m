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

/**
 *  注册tableViewCell
 */
- (void)registTableViewCell {
    [self.addtimeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReadDetailCellID];
    [self.hotTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReadDetailCellID];
    
    self.addtimeTableView.rowHeight = 160;
    self.hotTableView.rowHeight = 160;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // automaticallyAdjustsScrollViewInsets会根据NavigationBar、tabBar、status bar自动调整scrollview的inset，设置NO为手动修改
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册TableViewCell
    [self registTableViewCell];
    
    // 隐藏导航栏自带NavigationBar
    self.navigationController.navigationBarHidden = YES;
    
    // 默认是最新列表
    sortType = 0;
    
    // 创建scrollView
    [self setupScrollView];
    
    // 添加自定义导航栏
    [self addCustomNavigationBar];
    
    // 请求数据 默认第一次请求 addtime
    [self loadDataWithSort:@"addtime"];
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
    if (self.addtimeDetailListArray.count == 0) {
        [self loadDataWithSort:@"addtime"];
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
    if (self.hotDetailListArray.count == 0) {
        [self loadDataWithSort:@"hot"];
    }
    sortType = 1;
    _leftButton.selected = NO;
    _rightButton.selected = YES;
    [_leftButton setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
    // 改变ScrollView偏移量;
    [_rootScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 判断ScrollView偏移量调整右上按钮状态;
    if (scrollView.contentOffset.x < kScreenWidth / 2) {
        _leftButton.selected = YES;
        _rightButton.selected = NO;
        [_leftButton setImage:[UIImage imageNamed:@"NEW1"] forState:(UIControlStateNormal)];
        [_rightButton setImage:[UIImage imageNamed:@"HOT2"] forState:(UIControlStateNormal)];
    }
    if (scrollView.contentOffset.x > kScreenWidth / 2) {
        _leftButton.selected = NO;
        _rightButton.selected = YES;
        [_leftButton setImage:[UIImage imageNamed:@"NEW2"] forState:(UIControlStateNormal)];
        [_rightButton setImage:[UIImage imageNamed:@"HOT1"] forState:(UIControlStateNormal)];
    }
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








































