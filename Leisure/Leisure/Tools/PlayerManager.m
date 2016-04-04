//
//  PlayerManager.m
//  Leisure
//
//  Created by 沈强 on 16/4/3.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "PlayerManager.h"

@interface PlayerManager ()

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation PlayerManager

/**
 *  将manager对象保存在静态区，静态区对象只有当程序结束时才会释放，这样我们创建的manager对象就不会被释放
 */
+ (instancetype)defaultManager {
    static PlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PlayerManager alloc] init];
    });
    return manager;
}

/**
 *  重写init方法，在方法中默认播放模式是顺序播放，因为现在还没有播放资源，所以播放状态默认是暂停状态
 */
- (instancetype)init {
    if (self = [super init]) {
        _playType = PlayTypeList;
        _playerState = PlayerStatePause;
        _playIndex = 0;
    }
    return self;
}

/**
 *  重写musicArray的set方法
 */
- (void)setMusicArray:(NSMutableArray *)musicArray {
    // 将播放列表清空
    [_musicArray removeAllObjects];
    
    // 重新赋值
    _musicArray = [musicArray mutableCopy];
    
    // 根据列表中的播放位置取出播放资源，创建播放单元
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:musicArray[_playIndex]]];
    
    if (!_player) { // 判断播放器是否存在，如果不存在就创建
        _player = [[AVPlayer alloc] init];
    }
    
    // 如果存在直接切换播放器资源
    [_player replaceCurrentItemWithPlayerItem:item];
}

/**
 *  播放
 */
- (void)play {
    [_player play];
    _playerState = PlayerStatePlay;
}

/**
 *  暂停
 */
- (void)pause {
    [_player pause];
    _playerState = PlayerStatePause;
}

/**
 *  停止
 */
- (void)stop {
    [self seekToNewTime:0];
    [self pause];
}

/**
 *  上一首
 */
- (void)lastMusic {
    if (_playType == PlayTypeRandom) { // 判断是否是随机播放，如果是，播放位置就随机产生
        _playIndex = arc4random() % _musicArray.count;
    } else { // 根据数组的位置进行自减1操作
        if (_playIndex == 0) {
            _playIndex = _musicArray.count - 1;
        } else {
            _playIndex--;
        }
    }
    // 调用方法进行切换播放
    [self changeMusicWithIndex:_playIndex];
}

/**
 *  下一首
 */
- (void)nextMusic {
    if (_playType == PlayTypeRandom) { // 判断是否是随机播放，如果是，播放位置就随机产生
        _playIndex = arc4random() % _musicArray.count;
    } else { // 根据数组的位置进行自减1操作
        if (_playIndex == _musicArray.count - 1) {
            _playIndex = 0;
        } else {
            _playIndex++;
        }
    }
    // 调用方法进行切换播放
    [self changeMusicWithIndex:_playIndex];
}

/**
 *  跳转到播放进度
 */
- (void)seekToNewTime:(float)time {
    // 获取player的currentTime属性
    CMTime newTime = _player.currentTime;
    // 根据指定时间创建一个新的时间
    newTime.value = newTime.timescale * time;
    // 让播放器从新的时间开始播放
    [_player seekToTime:newTime];
}

/**
 *  返回当前时间
 */
- (float)currentTime {
    // 如果每秒的帧数为0，表示当前没有播放，所以返回0秒
    if (0 == _player.currentItem.timebase) {
        return 0;
    }
    // 计算当前播放的秒数并返回
    return _player.currentTime.value / _player.currentTime.timescale;
}

/**
 *  返回总时长
 */
- (float)totalTime {
    // 如果每秒的帧数为0，表示当前没有播放，所以返回0秒
    CMTime time = _player.currentItem.duration;
    if (0 == time.timescale) {
        return 0;
    }
    // 计算当前播放的秒数并返回
    return time.value / time.timescale;
}

/**
 *  根据索引播放指定音频
 */
- (void)changeMusicWithIndex:(NSInteger)index {
    _playIndex = index;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_musicArray[index]]];
    [_player replaceCurrentItemWithPlayerItem:item];
    [self play];
}

/**
 *  播放结束
 */
- (void)playerDidFinish {
    if (_playType == PlayTypeSingle) { // 如果是单曲播放，就停止播放
        [self stop];
    } else { // 否则下一首
        [self nextMusic];
    }
}

@end
