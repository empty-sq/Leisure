//
//  RadioView.m
//  Leisure
//
//  Created by 沈强 on 16/4/1.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioHeaderView.h"

#define kMargin 8

@implementation RadioHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        [self addSubview:_scrollView];
    
        // 初始化3个按钮
        CGFloat buttonX = 5;
        CGFloat buttonY = CGRectGetMaxY(_scrollView.frame) + 5;
        CGFloat buttonW = (kScreenWidth - kMargin * 2 - 10) / 3;
        _leftBtn = [UIButton buttonWithFrame:CGRectMake(5, buttonY, buttonW, buttonW)];
        [self addSubview:_leftBtn];
        
        buttonX += buttonW + kMargin;
        _midBtn = [UIButton buttonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonW)];
        [self addSubview:_midBtn];
        
        buttonX += buttonW + kMargin;
        _rightBtn = [UIButton buttonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonW)];
        [self addSubview:_rightBtn];
        
        // 全部电台的label
        CGFloat labelY = CGRectGetMaxY(_leftBtn.frame) + 5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, labelY, 120, 20)];
        label.text = @"全部电台·All stations";
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        
        // 分割线
        CGFloat viewY = CGRectGetMaxY(label.frame) - 10;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(122, viewY, ScreenWidth - 124, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    return self;
}

@end
