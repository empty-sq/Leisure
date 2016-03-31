//
//  CustomNavigationBar.m
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(0, 0, kHeight, kHeight);
        [_menuButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [self addSubview:_menuButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_menuButton.right + 5, 13, 100, kHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel sizeToFit];
}

@end
