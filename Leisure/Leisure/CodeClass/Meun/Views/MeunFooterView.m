//
//  MeunFooterView.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "MeunFooterView.h"

@implementation MeunFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(31, 31, 31);
        
        _musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kHeight - 50, 40, 40)];
        _musicImageView.image = [UIImage imageNamed:@"圆盘"];
        [self addSubview:_musicImageView];
        
        _musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _musicButton.frame = CGRectMake(kWidth - 50, _musicButton.top, 40, 40);
        [_musicButton setImage:[UIImage imageNamed:@"主播放"] forState:UIControlStateNormal];
        [self addSubview:_musicButton];
    }
    return self;
}

@end
