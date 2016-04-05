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
    NSMutableArray *musicArray = [NSMutableArray array];
    for (RadioDetailListModel *model in _listDataArray) {
        [musicArray addObject:model.musicUrl];
    }
    self.manager.musicArray = musicArray;
    [self.manager play];
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"client"] = @"1";
    parDic[@"tingid"] = _model.tingid;
    [NetWorkRequestManager requestWithType:POST urlString:RADIOPLAYERINFO_URL parDic:parDic finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
    } error:^(NSError *error) {
        SQLog(@"error is %@", error);
    }];
}

#pragma mak -添加轮播图
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.height - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 注册tableViewCell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioPlayCell class]) bundle:nil] forCellReuseIdentifier:RadioPlayCellID];
    _tableView.rowHeight = 58;
    [self.scrollView addSubview:_tableView];
    
    // 设置音乐播放信息界面
    _playMainView = [[RadioPlayMainView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.height)];
    _playMainView.model = _model;
    [_playMainView.likeBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [_playMainView.playBtn addTarget:self action:@selector(playChange) forControlEvents:UIControlEventTouchUpInside];
    [_playMainView.timeSlider addTarget:self action:@selector(changePlayProgress:) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(playerPlay) userInfo:nil repeats:YES];
    [self.scrollView addSubview:_playMainView];
    
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
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
