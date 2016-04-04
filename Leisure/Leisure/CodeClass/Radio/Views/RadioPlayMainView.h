//
//  RadioPlayMainView.h
//  Leisure
//
//  Created by 沈强 on 16/4/4.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseView.h"
#import "RadioDetailListModel.h"

@interface RadioPlayMainView : BaseView

/** 播放界面图片 */
@property (nonatomic, strong) UIImageView *coverImageView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 控制播放按钮 */
@property (nonatomic, strong) UIButton *playBtn;
/** 喜爱按钮 */
@property (nonatomic, strong) UIButton *likeBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commentBtn;
/** 下载按钮 */
@property (nonatomic, strong) UIButton *downloadBtn;
/** 进度条 */
@property (nonatomic, strong) UISlider *timeSlider;
/** 剩余时间 */
@property (nonatomic, strong) UILabel *endTimeLabel;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) RadioDetailListModel *model;

@end
