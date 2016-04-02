//
//  RadioInfoHeaderView.m
//  Leisure
//
//  Created by 沈强 on 16/4/2.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioDetailHeaderView.h"

@interface RadioDetailHeaderView ()

/** 头部图片 */
@property (nonatomic, strong) UIImageView *headImageView;
/** 作者头像 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 作者 */
@property (nonatomic, strong) UILabel *usernameLabel;
/** 播放次数 */
@property (nonatomic, strong) UILabel *countLabel;
/** 描述 */
@property (nonatomic, strong) UILabel *introudeLabel;

@end

@implementation RadioDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化头部图片
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        [self addSubview:_headImageView];
        
        // 初始化作者头像
        CGFloat iconY = CGRectGetMaxY(_headImageView.frame) + 20;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, iconY, 30, 30)];
        [self addSubview:_iconImageView];
        
        // 初始化作者的名字
        CGFloat userX = CGRectGetMaxX(_iconImageView.frame) + 5;
        CGFloat userY = CGRectGetMinY(_iconImageView.frame) + 10;
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userX, userY, 100, 10)];
        _usernameLabel.font = [UIFont systemFontOfSize:10.0];
        _usernameLabel.textColor = [UIColor blueColor];
        [self addSubview:_usernameLabel];
        
        // 初始化播放图片
        UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80, userY, 10, 10)];
        playImageView.image = [UIImage imageNamed:@"播放量"];
        [self addSubview:playImageView];
        
        // 初始化播放量
        CGFloat countX = CGRectGetMaxX(playImageView.frame) + 5;
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(countX, userY, 60, 10)];
        _countLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_countLabel];
        
        // 初始化描述
        CGFloat introudeY = CGRectGetMaxY(_iconImageView.frame) + 20;
        _introudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, introudeY, kScreenWidth - 20, 12)];
        _introudeLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_introudeLabel];
    }
    return self;
}

- (void)setModel:(RadioDetailInfoModel *)model {
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:kImage];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kImage];
    _usernameLabel.text = model.uname;
    _introudeLabel.text = model.desc;
    _countLabel.text = [NSString stringWithFormat:@"%@", model.musicvisitnum];
}

@end
