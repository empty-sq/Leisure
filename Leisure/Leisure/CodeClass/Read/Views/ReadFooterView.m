//
//  ReadFooterView.m
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadFooterView.h"

@implementation ReadFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = CGRectMake(5, 0, kWidth - 10, kHeight);
        [_imageButton setImage:[UIImage imageNamed:@"写作"] forState:UIControlStateNormal];
        [self addSubview:_imageButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageButton.left, kHeight - 20, 50, 30)];
        [self addSubview:_nameLabel];
        
        _ennameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right, kHeight - 15, 50, 10)];
        [self addSubview:_ennameLabel];
    }
    return self;
}

@end
