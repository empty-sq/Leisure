//
//  UIButton+Custom.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(NSString *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(NSString *)image target:(id)target action:(SEL)aciton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:target action:aciton forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
