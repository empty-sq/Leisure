//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "PlayerManager.h"
#import "RadioPlayMainView.h"
#import "RadioPlayCell.h"
#import "RadioPlayOtherModel.h"
#import "RadioPlayOtherView.h"

@interface RadioPlayViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 音乐轮播 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 页码 */
@property (nonatomic, strong) UIPageControl *pageControl;
/** 音乐列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 音乐播放器管理者 */
@property (nonatomic, strong) PlayerManager *manager;
/** 播放信息界面 */
@property (nonatomic, strong) RadioPlayMainView *playMainView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton *playBtn;
/** 判断是否喜欢 */
@property (nonatomic, assign) BOOL isLike;
/** 单曲列表随机播放 */
@property (nonatomic, assign) int count;
/** 自定义Bar */
@property (nonatomic, strong) CustomNavigationBar *bar;
/** 显示网页信息 */
@property (nonatomic, strong) UIWebView *webView;
/** 作者详情类 */
@property (nonatomic, strong) RadioPlayOtherModel *playModel;
/** 音乐其他页面 */
@property (nonatomic, strong) RadioPlayOtherView *playOtherView;

@end

@implementation RadioPlayViewController

static NSString * const RadioPlayCellID = @"RadioPlayCell";

#pragma mark -懒加载
/**
 *  初始化音乐播放器管理者
 */
- (PlayerManager *)manager {
    if (!_manager) {
        _manager = [PlayerManager defaultManager];
    }
    return _manager;
}

#pragma mark -毛玻璃效果
/**
 *  添加毛玻璃
 */
- (void)addBlur {
    // 添加背景
    UIImageView *bkgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    bkgImageView.image = [UIImage imageNamed:@"yejing"];
    [self.view addSubview:bkgImageView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:blurView];
}

#pragma mark -加载数据
- (void)loadData {
    // 添加音乐播放器自动播放音乐
    NSMutableArray *musicArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (RadioDetailListModel *model in _listDataArray) {
        [musicArray addObject:model.musicUrl];
    }
    self.manager.musicArray = [musicArray mutableCopy];
    self.manager.playIndex = _index;
    [self.manager play];
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"client"] = @"1";
    parDic[@"tingid"] = _model.tingid;
    [NetWorkRequestManager requestWithType:POST urlString:RADIOPLAYERINFO_URL parDic:parDic finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        _playModel = [[RadioPlayOtherModel alloc] init];
        [_playModel setValuesForKeysWithDictionary:dict[@"data"]];
        
        NSMutableArray *moreArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *array = dict[@"data"][@"moreting"];
        for (NSDictionary *dic in array) {
            RadioDetailListModel *model = [[RadioDetailListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [moreArray addObject:model.coverimg];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_playOtherView setPlayOtherViewWithModel:_playModel imageArray:moreArray];
        });
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

#pragma mak -添加轮播，完成布局，并实现方法
- (void)setupScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 101)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight - 64 - 101);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
    [self.view addSubview:_scrollView];
    
    // 设置音乐播放列表界面
    [self setupMusicTableView];
    
    // 设置音乐播放信息界面
    [self setupMusicPlay];
    
    // 添加网页界面
    [self setupMusicWebView];
    
    // 添加其他界面
    [self setupMusicOtherView];
    
    // 添加页码
    [self setupPageControl];
    
    // 添加播放下一首下一首按钮
    UIButton *lastButton = [UIButton buttonWithFrame:CGRectMake(50, kScreenHeight - 60, 30, 30) image:@"上一首" target:self action:@selector(lastBtnClick)];
    lastButton.layer.cornerRadius = 15;
    lastButton.layer.masksToBounds = YES;
    [self.view addSubview:lastButton];
    _playBtn = [UIButton buttonWithFrame:CGRectMake(kScreenWidth / 2 - 25, kScreenHeight - 70, 50, 50) image:@"暂停" target:self action:@selector(playBtnClick)];
    [self.view addSubview:_playBtn];
    _playBtn.layer.cornerRadius = 25;
    _playBtn.layer.masksToBounds = YES;
    UIButton *nextButton = [UIButton buttonWithFrame:CGRectMake(kScreenWidth - 80, kScreenHeight - 60, 30, 30) image:@"下一首" target:self action:@selector(nextBtnClick)];
    nextButton.layer.cornerRadius = 15;
    nextButton.layer.masksToBounds = YES;
    [self.view addSubview:nextButton];
}

/**
 *  上一首
 */
- (void)lastBtnClick {
    [self.manager lastMusic];
    [self setAllViewWithIndex:self.manager.playIndex];
}

/**
 *  播放暂停
 */
- (void)playBtnClick {
    if (self.manager.playerState == PlayerStatePlay) {
        [self.manager pause];
        [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    } else {
        [self.manager play];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
}

/**
 *  下一首
 */
- (void)nextBtnClick {
    [self.manager nextMusic];
    [self setAllViewWithIndex:self.manager.playIndex];
}

/**
 *  重置所有的界面
 */
- (void)setAllViewWithIndex:(NSInteger)index {
    RadioDetailListModel *model = _listDataArray[self.manager.playIndex];
    _playMainView.model = model;
    _bar.titleLabel.text = model.title;
    [_bar.titleLabel sizeToFit];
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.manager.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.webview_url]]];
}

/**
 *  根据滑动视图偏移量获取对应页码
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 页面滚动一半频宽才改变页码;
    _pageControl.currentPage = (int)(scrollView.contentOffset.x / kScreenWidth + 0.5);
}

#pragma mark -设置音乐播放列表界面
/**
 *  设置音乐播放列表界面
 */
- (void)setupMusicTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, _scrollView.height - 70) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 注册tableViewCell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioPlayCell class]) bundle:nil] forCellReuseIdentifier:RadioPlayCellID];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    _tableView.rowHeight = 58;
    [self.scrollView addSubview:_tableView];
}

#pragma mark -设置音乐播放界面
/**
 *  设置音乐播放界面，实现方法
 */
- (void)setupMusicPlay {
    _playMainView = [[RadioPlayMainView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.height)];
    _playMainView.model = _model;
    [_playMainView.likeBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [_playMainView.playBtn addTarget:self action:@selector(playChange) forControlEvents:UIControlEventTouchUpInside];
    [_playMainView.timeSlider addTarget:self action:@selector(changePlayProgress:) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(playerPlay) userInfo:nil repeats:YES];
    [self.scrollView addSubview:_playMainView];
}

/**
 *  改变图片
 */
- (void)change {
    if (_isLike) {
        [_playMainView.likeBtn setImage:[UIImage imageNamed:@"aixin"] forState:UIControlStateNormal];
        _isLike = NO;
    } else {
    [_playMainView.likeBtn setImage:[UIImage imageNamed:@"hongxi"] forState:UIControlStateNormal];
        _isLike = YES;
    }
}

/**
 *  改变播放状态
 */
- (void)playChange {
    if (self.manager.playType == PlayTypeList) {
        [_playMainView.playBtn setImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateNormal];
        self.manager.playType = PlayTypeRandom;
    } else if (self.manager.playType == PlayTypeRandom) {
        [_playMainView.playBtn setImage:[UIImage imageNamed:@"danqu"] forState:UIControlStateNormal];
        self.manager.playType = PlayTypeSingle;
    } else {
        [_playMainView.playBtn setImage:[UIImage imageNamed:@"liebiao"] forState:UIControlStateNormal];
        self.manager.playType = PlayTypeList;
    }
}

/**
 *  通过定时器来控制播放进度条
 */
- (void)playerPlay {
    // 获取当前时间
    NSInteger currentTime = self.manager.currentTime;
    // 获取总时间
    NSInteger totalTime = self.manager.totalTime;
    // 计算剩余时间
    NSInteger surplusTime = totalTime - currentTime;
    // 设置空间属性
    _playMainView.timeSlider.value = currentTime;
    _playMainView.timeSlider.maximumValue = totalTime;
    _playMainView.endTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",surplusTime / 60, surplusTime % 60];
    
    if (totalTime && !surplusTime) { // 判断播放器是否播放结束，播放结束调用方法
        [self.manager playerDidFinish];
    }
}

/**
 *  拉动进度条改变播放的进度
 */
- (void)changePlayProgress:(UISlider *)slider {
    [self.manager seekToNewTime:slider.value];
}

#pragma mark -设置网页信息
/**
 *  设置网页信息
 */
- (void)setupMusicWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 30, kScreenWidth, _scrollView.height - 70)];
    RadioDetailListModel *model = _listDataArray[_index];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.webview_url]]];
    [_scrollView addSubview:_webView];
}

#pragma mark -设置其他界面
- (void)setupMusicOtherView {
    _playOtherView = [[RadioPlayOtherView alloc] initWithFrame:CGRectMake(kScreenWidth * 3, 30, kScreenWidth, _scrollView.height - 70)];
    [_scrollView addSubview:_playOtherView];
}

#pragma mark -设置页码
/**
 *  设置页码
 */
- (void)setupPageControl {
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, 74, 100, 20)];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 1;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [self.view addSubview:_pageControl];
}

#pragma mark -自定义导航栏，点击方法
/**
 *  添加自定义导航栏
 */
- (void)addCustomNavigationBar {
    _bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    [_bar.menuButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _bar.titleLabel.text = self.model.title;
    [self.view addSubview:_bar];
    
//    UIButton *shareBtn = [UIButton buttonWithFrame:CGRectMake(kScreenWidth - 100, 8, 28, 28) image:@"fenxiang" target:self action:@selector(shareClick)];
//    [_bar addSubview:shareBtn];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  分享
 */
//- (void)shareClick {
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"568a3499e0f55a3a3f000047" shareText:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social" shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline, UMShareToTencent, nil] delegate:nil];
//}

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 关闭控制器自动布局scrollView功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加毛玻璃
    [self addBlur];
    
    // 添加轮播
    [self setupScrollView];
    
    // 添加自定义导航栏
    [self addCustomNavigationBar];
    
    // 加载数据
    [self loadData];
}

#pragma mark -<UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:RadioPlayCellID forIndexPath:indexPath];
    cell.model = self.listDataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.manager changeMusicWithIndex:indexPath.row];
    [self setAllViewWithIndex:indexPath.row];
    [self.manager play];
    [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
