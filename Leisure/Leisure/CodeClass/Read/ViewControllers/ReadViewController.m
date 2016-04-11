//
//  ReadViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadDetailViewController.h"
#import "ReadCarouselModel.h"
#import "ReadListModel.h"
#import "ReadFooterView.h"
#import "ReadCollectionViewCell.h"
#import "ReadHeaderView.h"
#import "ReadInfoViewController.h"
#import <SDCycleScrollView.h>

@interface ReadViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, SDCycleScrollViewDelegate>

/** 阅读主题列表 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 阅读头部的轮播图 */
@property (nonatomic, strong) UICollectionReusableView *headerView;
/** 轮播图图片 */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** 阅读主题数据源 */
@property (nonatomic, strong) NSMutableArray *listArray;
/** 滚动列表数据源 */
@property (nonatomic, strong) NSMutableArray *carouselArray;

@end

@implementation ReadViewController

static NSString * const ReadCellID = @"ReadCollectionViewCell";
static NSString * const ReadHeaderViewID = @"ReadHeaderView";
static NSString * const ReadFooterViewID = @"ReadFooterView";

#pragma mark -懒加载
- (NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}

- (NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _carouselArray;
}

- (NSMutableArray *)imageUrlArray {
    if (_imageUrlArray == nil) {
        _imageUrlArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imageUrlArray;
}

#pragma mark -加载数据
/**
 *  加载数据
 */
- (void)loadData {
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"client"] = @"1";
    [NetWorkRequestManager requestWithType:POST urlString:READLIST_URL parDic:parDic finish:^(NSData *data) {
        // 解析数据
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        // 获取阅读首页的轮播图的数据源
        NSArray *carouselArray = dataDict[@"data"][@"carousel"];
        for (NSDictionary *dict in carouselArray) {
            // 封装阅读滚动视图模型对象
            ReadCarouselModel *model = [[ReadCarouselModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.carouselArray addObject:model];
            [self.imageUrlArray addObject:model.img];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 添加自动轮播图
            [self addCarouselView];
        });
        
        // 获取列表数据源
        NSArray *listArray = dataDict[@"data"][@"list"];
        for (NSDictionary *dict in listArray) {
            ReadListModel *model = [[ReadListModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.listArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            // 刷新数据
            [_collectionView reloadData];
        });
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加轮播图
    [self createListView];
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -创建视图
/**
 *  创建阅读首页下面的主题列表视图，用的是一个UICollectionView
 */
- (void)createListView {
    // 创建flowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置行之间的最小间隔
    layout.minimumLineSpacing = 5;
    // 设置列之间的最小间隔
    layout.minimumInteritemSpacing = 5;
    // 设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    // 设置item (cell)的大小
    CGFloat layoutH = (kScreenWidth - 30) / 3;
    CGFloat layoutW = layoutH;
    layout.itemSize = CGSizeMake(layoutW, layoutH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(0, 150);
    layout.footerReferenceSize = CGSizeMake(0, layoutH);
    
    // 创建collectionView对象，设置代理，设置数据源
    CGFloat collectionViewH = ScreenHeight - 44;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, collectionViewH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    // 注册单元 表头 表尾;
    [_collectionView registerClass:[ReadCollectionViewCell class] forCellWithReuseIdentifier:ReadCellID];
    [_collectionView registerClass:[ReadHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReadHeaderViewID];
    [_collectionView registerClass:[ReadFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReadFooterViewID];
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReadCellID forIndexPath:indexPath];
    cell.model = _listArray[indexPath.row];
    return cell;
}

/**
 *  选中单元格的方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReadDetailViewController *readDetailVC = [[ReadDetailViewController alloc] init];
    readDetailVC.listModel = _listArray[indexPath.item];
    [self.navigationController pushViewController:readDetailVC animated:YES];
}

/**
 *  设置表头，表尾
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReadHeaderViewID forIndexPath:indexPath];
        // 添加自动轮播图
        [self addCarouselView];
        return _headerView;
    } else {
        ReadFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReadFooterViewID forIndexPath:indexPath];
        return footerView;
    }
}

/**
 *  通过第三方框架SDCycleScrollView实现自动轮播图
 */
- (void)addCarouselView {
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) imageNamesGroup:_imageUrlArray];
    // 设置分页控件位置
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    // pageControl样式
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    // 设置滚动间隔
    scrollView.autoScrollTimeInterval = 5;
    scrollView.delegate = self;
    [_headerView addSubview:scrollView];
}

/**
 *  点击图片回调
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ReadCarouselModel *model = self.carouselArray[index];
    // 获取详情内容ID，跳转到详情界面
    NSArray *array = [model.url componentsSeparatedByString:@"/"];
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
    infoVC.ID = [array lastObject];
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
