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
#import "RadioHeaderView.h"
#import "RadioTableViewCell.h"
#import <UIButton+WebCache.h>
#import <SDCycleScrollView.h>

@interface RadioViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

/** 滚动视图列表数据源 */
@property (nonatomic, strong) NSMutableArray *carouselArray;
/** 电台主题列表数据源 */
@property (nonatomic, strong) NSMutableArray *alllistArray;
/** 热门列表数据 */
@property (nonatomic, strong) NSMutableArray *hotArray;
/** 轮播图图片 */
@property (nonatomic, strong) NSMutableArray *imgArray;
/** 电台列表 */
@property (nonatomic, strong) UITableView *tableView;
/** tableView的头部 */
@property (nonatomic, strong) RadioHeaderView *headView;

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

- (NSMutableArray *)imgArray {
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imgArray;
}

- (NSMutableArray *)hotArray {
    if (_hotArray == nil) {
        _hotArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotArray;
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
    [NetWorkRequestManager requestWithType:POST urlString:RADIOLIST_URL parDic:parDic finish:^(NSData *data) {
        if (data == nil) return ;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            // 获取滚动列表数据
            NSArray *carouselArr = dataDict[@"data"][@"carousel"];
            for (NSDictionary *dic in carouselArr) {
                RadioCarouselModel *model = [[RadioCarouselModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.imgArray addObject:model.img];
                [self.carouselArray addObject:model];
            }
            
            // 获取电台主题列表数据
            NSArray *alllistArr = dataDict[@"data"][@"alllist"];
            for (NSDictionary *dic in alllistArr) {
                RadioAlllistModel *model = [[RadioAlllistModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.alllistArray addObject:model];
            }
            
            // 获取电台热门列表数据
            NSArray *hotArr = dataDict[@"data"][@"hotlist"];
            for (NSDictionary *dic in hotArr) {
                RadioAlllistModel *model = [[RadioAlllistModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.hotArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 创建滚动视图
                [self createCycleScrollView];
                
                // 创建headview上面的按钮背景
                [self setupHeadViewBtnByBackGroundImage];
                
                // 刷新主题列表
                [self.tableView reloadData];
            });
        });
    } error:^(NSError *error) {
        SQLog(@"电台界面加载失败");
    }];
}

#pragma mark -tableView的headview中的按钮实现
/**
 *  给表头按钮添加背景图片
*/
- (void)setupHeadViewBtnByBackGroundImage {
    [self setupBtn:_headView.leftBtn tag:101 index:0];
    [self setupBtn:_headView.midBtn tag:102 index:1];
    [self setupBtn:_headView.rightBtn tag:103 index:2];
}

- (void)setupBtn:(UIButton *)button tag:(int)tag index:(int)index {
    RadioAlllistModel *model = self.hotArray[index];
    button.tag = tag;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.coverimg] forState:UIControlStateNormal placeholderImage:kImage];
}

/**
 *  表头按钮的点击方法
 */
- (void)btnClick:(UIButton *)button {
    
}

#pragma mark 创建tableView和第三方轮播图
/**
 *  通过第三方框架SDCycleScrollView实现自动轮播图
 */
- (void)createCycleScrollView {
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:_headView.scrollView.frame imageURLStringsGroup:_imgArray];
    // 分页控件的位置
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    // 翻页样式
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    // 自动翻滚时间
    scrollView.autoScrollTimeInterval = 5;
    scrollView.delegate = self;
    [_headView.scrollView addSubview:scrollView];
}

/**
 *  第三方自动轮播图代理方法，点击选中事件
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/**
 *  创建tableView
 */
- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    
    // 初始化headView
    _headView = [[RadioHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    // 设置tableView的headview
    _tableView.tableHeaderView = _headView;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioTableViewCell class]) bundle:nil] forCellReuseIdentifier:RadioCellID];
    
    // 添加tableView
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建tableView
    [self setupTableView];
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -<UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alllistArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RadioCellID forIndexPath:indexPath];
    RadioAlllistModel *model = self.alllistArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RadioAlllistModel *model = self.alllistArray[indexPath.row];
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    radioDetailVC.model = model;
    [self.navigationController pushViewController:radioDetailVC animated:YES];
}

@end
