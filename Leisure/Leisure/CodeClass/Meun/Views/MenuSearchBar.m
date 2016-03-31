//
//  MenuSearchBar.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "MenuSearchBar.h"

@implementation MenuSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.font = [UIFont systemFontOfSize:15.0];
        // 背景颜色
        self.backgroundColor = [UIColor whiteColor];
        // 左边放大镜图标
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_background"]];
        self.leftView.frame = CGRectMake(0, 0, 30, self.height);
        self.leftViewMode = UITextFieldViewModeAlways;
        // 右边清楚按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        // 键盘右下角按钮
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

/**
 *  重置文本框文字输入区域尺寸
 */
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(self.leftView.width, 0, kWidth - self.leftView.width, kHeight);
}

@end
