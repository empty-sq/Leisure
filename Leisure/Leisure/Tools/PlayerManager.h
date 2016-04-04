//
//  PlayerManager.h
//  Leisure
//
//  Created by 沈强 on 16/4/3.
//  Copyright © 2016年 SQ. All rights reserved.
//
// 给这个类一个放有音乐网址的数组，这个类就可以播放数组里的音乐，当我们想跳转下一首，上一首音乐的时候，这个类会给我们提供一个方法直接调用

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, PlayType) {
    /** 单曲播放 */
    PlayTypeSingle,
    /** 随机播放 */
    PlayTypeRandom,
    /** 顺序播放 */
    PlayTypeList  
};

typedef NS_ENUM(NSInteger, PlayerState) {
    /** 播放 */
    PlayerStatePlay,
    /** 暂停 */
    PlayerStatePause 
};

@interface PlayerManager : NSObject

/** 播放模式 */
@property (nonatomic, assign) PlayType playType;
/** 播放状态 */
@property (nonatomic, assign, readonly) PlayerState playerState;
/** 接受和管理播放器的播放资源 */
@property (nonatomic, strong) NSMutableArray *musicArray;
/** 播放的索引 */
@property (nonatomic, assign) NSUInteger playIndex;
/** 当前时间 */
@property (nonatomic, assign, readonly) float currentTime;
/** 总时间 */
@property (nonatomic, assign, readonly) float totalTime;

/** 初始化播放 */
+ (instancetype)defaultManager;

/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 停止 */
- (void)stop;

/** 跳转播放进度 */
- (void)seekToNewTime:(float)time;

/** 上一首 */
- (void)lastMusic;

/** 下一首 */
- (void)nextMusic;

/** 根据索引播放指定音频 */
- (void)changeMusicWithIndex:(NSInteger)index;

/** 播放结束 */
- (void)playerDidFinish;

@end
