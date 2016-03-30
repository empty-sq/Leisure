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

@interface ReadViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 阅读主题列表 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 阅读主题数据源 */
@property (nonatomic, strong) NSMutableArray *listArray;
/** 滚动列表数据源 */
@property (nonatomic, strong) NSMutableArray *carouselArray;

@end

@implementation ReadViewController

static NSString * const ReadCellID = @"CollectionViewCell";

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
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 创建滚动列表视图
            [self createCycleScrollView];
            
            // 创建主题列表视图
            [self createListView];
        });
        
        // 获取列表数据源
        NSArray *listArray = dataDict[@"data"][@"list"];
        for (NSDictionary *dict in listArray) {
            ReadListModel *model = [[ReadListModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.listArray addObject:model];
        }
        
        // 刷新数据
        [_collectionView reloadData];
        
        
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"阅读";
    
    // 加载数据
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -创建视图
/**
 *  创建轮播图
 */
- (void)createCycleScrollView {
    SQLog(@"轮播图");
}

/**
 *  创建阅读首页下面的主题列表视图，用的是一个UICollectionView
 */
- (void)createListView {
    // 创建flowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置行之间的最小间隔
    layout.minimumLineSpacing = 2;
    // 设置列之间的最小间隔
    layout.minimumInteritemSpacing = 2;
    // 设置item (cell)的大小
    CGFloat layoutH = self.view.width / 3;
    CGFloat layoutW = layoutH - 10;
    layout.itemSize = CGSizeMake(layoutW, layoutH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 创建collectionView对象，设置代理，设置数据源
    CGFloat collectionViewW = self.view.width;
    CGFloat collectionViewH = self.view.height - 164;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 164, collectionViewW, collectionViewH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ReadCellID];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReadCellID forIndexPath:indexPath];
    ReadListModel *model = _listArray[indexPath.item];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:cell.bounds];
    nameLabel.text = model.name;
    [cell addSubview:nameLabel];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ReadDetailViewController *readDetailVC = [[ReadDetailViewController alloc] init];
    ReadListModel *model = _listArray[indexPath.item];
    readDetailVC.typeID = model.type;
    [self.navigationController pushViewController:readDetailVC animated:YES];
}

@end
