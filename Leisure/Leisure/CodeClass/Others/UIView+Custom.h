//
//  UIView+Custom.h
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Custom)

/** x轴 */
@property (nonatomic, assign) CGFloat x;
/** y轴 */
@property (nonatomic, assign) CGFloat y;
/** 宽度 */
@property (nonatomic, assign) CGFloat width;
/** 高度 */
@property (nonatomic, assign) CGFloat height;
/** 左边界 */
@property (nonatomic, assign) CGFloat left;
/** 右边界 */
@property (nonatomic, assign) CGFloat right;
/** 上边界 */
@property (nonatomic, assign) CGFloat top;
/** 下边界 */
@property (nonatomic, assign) CGFloat bottom;
/** 尺寸 */
@property (nonatomic, assign) CGSize size;

@end
