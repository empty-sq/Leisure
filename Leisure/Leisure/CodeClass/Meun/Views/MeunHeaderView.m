//
//  MeunHeaderView.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "MeunHeaderView.h"
#import "MeunHeaderView.h"

#define kMargin 10

@implementation MeunHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(83, 83, 83);
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(kMargin, kMargin, 50, 50);
        _iconButton.imageView.layer.cornerRadius = 25;
        [_iconButton setImage:kImage forState:UIControlStateNormal];
        [self addSubview:_iconButton];
        
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(_iconButton.right + kMargin, _iconButton.top + 10, self.width - _loginButton.x, 30)];
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        
        CGFloat margin = (kWidth - kMargin * 4 - 80) / 3;
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kMargin * 2 + (margin + 20) * i, _iconButton.bottom + kMargin * 2, 20, 20);
            button.backgroundColor = [UIColor redColor];
            button.tag = i + 10;
            [self addSubview:button];
        }
        _downloadButton = (UIButton *)[self viewWithTag:10];
        [_downloadButton setImage:[UIImage imageNamed:@"主下载"] forState:(UIControlStateNormal)];
        _favoButton = (UIButton *)[self viewWithTag:11];
        [_favoButton setImage:[UIImage imageNamed:@"主喜欢"] forState:(UIControlStateNormal)];
        _chatButton = (UIButton *)[self viewWithTag:12];
        [_chatButton setImage:[UIImage imageNamed:@"主评论"] forState:(UIControlStateNormal)];
        _writeButton = (UIButton *)[self viewWithTag:13];
        [_writeButton setImage:[UIImage imageNamed:@"写字"] forState:(UIControlStateNormal)];
        
        _searchBar = [[MenuSearchBar alloc] initWithFrame:CGRectMake(_downloadButton.left, _downloadButton.bottom + kMargin * 2, kWidth - kMargin * 4, 30)];
//                [self addSubview:_searchBar];
    }
    return self;
}

@end
