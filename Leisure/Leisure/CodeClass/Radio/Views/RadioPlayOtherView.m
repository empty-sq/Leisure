//
//  RadioPlayOtherView.m
//  Leisure
//
//  Created by 沈强 on 16/4/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioPlayOtherView.h"

#define kMargin 20

@implementation RadioPlayOtherView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *anchorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, 55, 20)];
        anchorLabel.font = [UIFont systemFontOfSize:18.0];
        anchorLabel.text = @"主播：";
        [self addSubview:anchorLabel];
        
        CGFloat iconX = CGRectGetMaxX(anchorLabel.frame) + 5;
        CGFloat iconY = kMargin - 5;
        _iconBtn = [UIButton buttonWithFrame:CGRectMake(iconX, iconY, 30, 30)];
        _iconBtn.imageView.layer.cornerRadius = 15;
        [self addSubview:_iconBtn];
        
        CGFloat unameX = CGRectGetMaxX(_iconBtn.frame) + 5;
        _unameBtn = [UIButton buttonWithFrame:CGRectMake(unameX, kMargin, kScreenWidth - unameX, 20)];
        _unameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_unameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_unameBtn];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 3 * kMargin, 55, 20)];
        textLabel.font = [UIFont systemFontOfSize:18.0];
        textLabel.text = @"原文：";
        [self addSubview:textLabel];
        
        CGFloat iconBtnY = CGRectGetMaxY(_iconBtn.frame) + 10;
        _iconButton = [UIButton buttonWithFrame:CGRectMake(iconX, iconBtnY, 30, 30)];
        _iconButton.imageView.layer.cornerRadius = 15;
        [self addSubview:_iconButton];
        
        _unameButton = [UIButton buttonWithFrame:CGRectMake(unameX, 3 * kMargin, kScreenWidth - unameX, 20)];
        _unameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_unameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_unameButton];
        
        CGFloat radioY = CGRectGetMaxY(_iconButton.frame) + 20;
        _radioLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, radioY, kScreenWidth - kMargin, 20)];
        [self addSubview:_radioLabel];
        
        CGFloat labelY = CGRectGetMaxY(_radioLabel.frame) + 20;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, labelY, 120, 20)];
        label.text = @"主播其他作品";
        label.font = [UIFont systemFontOfSize:18];
        [self addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.right, label.top + 10, kScreenWidth - label.right, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        CGFloat margin = (kScreenWidth - 350) / 2;
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 3; j++) {
                UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = CGRectMake(label.left + 20 + (margin + 90) * j, label.bottom + 20 + (margin + 90) * i, 90, 90);
                button.tag = i * 3 + j + 10;
                [self addSubview:button];
            }
        }
        
        _allRadioBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _allRadioBtn.frame = CGRectMake(kScreenWidth - 170, kScreenHeight - 230, 150, 20);
        _allRadioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _allRadioBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_allRadioBtn setTitle:@"查看全部电台" forState:(UIControlStateNormal)];
        [_allRadioBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _allRadioBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0);
        [_allRadioBtn setImage:[UIImage imageNamed:@"youjiantou"] forState:(UIControlStateNormal)];
        [self addSubview:_allRadioBtn];
    }
    return self;
}

- (void)setPlayOtherViewWithModel:(RadioPlayOtherModel *)model imageArray:(NSMutableArray *)array {
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:model.authorIcon] forState:UIControlStateNormal placeholderImage:kImage];
    
    [_unameBtn setTitle:model.authorUname forState:UIControlStateNormal];
    
    [_iconButton sd_setImageWithURL:[NSURL URLWithString:model.userIcon] forState:UIControlStateNormal placeholderImage:kImage];
    
    [_unameButton setTitle:model.username forState:UIControlStateNormal];
    
    _radioLabel.text = [NSString stringWithFormat:@"来自电台：%@", model.radioname];
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [self viewWithTag:i + 10];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i]] forState:UIControlStateNormal placeholderImage:kImage];
    }
}

@end
