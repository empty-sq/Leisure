//
//  RadioPlayMainView.m
//  Leisure
//
//  Created by 沈强 on 16/4/4.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioPlayMainView.h"

#define kMargin kScreenWidth / 7.0

@implementation RadioPlayMainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, 5 * kMargin, 5 * kMargin)];
        [self addSubview:_coverImageView];
        
        CGFloat titleY = CGRectGetMaxY(_coverImageView.frame) + 30;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleY, kScreenWidth, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:20.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        CGFloat silderY = CGRectGetMaxY(_titleLabel.frame) + 20;
        _timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(kMargin, silderY, 5 * kMargin, 30)];
        [self addSubview:_timeSlider];
        
        CGFloat endTimeX = CGRectGetMaxX(_timeSlider.frame) + 5;
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(endTimeX, silderY, 30, 30)];
        _endTimeLabel.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:_endTimeLabel];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 90, kScreenWidth, 40)];
        footerView.backgroundColor = [UIColor blackColor];
        footerView.alpha = 0.1;
        [self addSubview:footerView];
        
        CGFloat btnW = kScreenWidth / 4;
        CGFloat btnX = (btnW - 30) / 2;
        CGFloat btnY = self.height - 85;
        _playBtn = [UIButton buttonWithFrame:CGRectMake(btnX, btnY, 30, 30) image:@"liebiao"];
        [self addSubview:_playBtn];
        
        _likeBtn = [UIButton buttonWithFrame:CGRectMake(btnW + btnX, btnY, 30, 30) image:@"aixin"];
        [self addSubview:_likeBtn];
        
        _downloadBtn = [UIButton buttonWithFrame:CGRectMake(btnW * 2 + btnX, btnY, 30, 30) image:@"xiazai"];
        [self addSubview:_downloadBtn];
        
        _commentBtn = [UIButton buttonWithFrame:CGRectMake(btnW * 3 + btnX, btnY, 30, 30) image:@"xiaoxi"];
        [self addSubview:_commentBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    CGFloat labelX = (kScreenWidth - _titleLabel.width) / 2;
    _titleLabel.frame = CGRectMake(labelX, _titleLabel.y, _titleLabel.width, _titleLabel.height);
}

- (void)setModel:(RadioDetailListModel *)model {
    _model = model;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:kImage];
    _titleLabel.text = model.imgTitle;
}

@end
