//
//  UIButton+Custom.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(NSString *)image;

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(NSString *)image target:(id)target action:(SEL)aciton;

+ (UIButton *)buttonWithFrame:(CGRect)frame;

@end
