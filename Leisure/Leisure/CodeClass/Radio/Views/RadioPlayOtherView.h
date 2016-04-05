//
//  RadioPlayOtherView.h
//  Leisure
//
//  Created by 沈强 on 16/4/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseView.h"
#import "RadioPlayOtherModel.h"

@interface RadioPlayOtherView : BaseView

/** 头像 */
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UIButton *iconButton;
/** 作者 */
@property (nonatomic, strong) UIButton *unameBtn;
@property (nonatomic, strong) UIButton *unameButton;
/** 电台 */
@property (nonatomic, strong) UILabel *radioLabel;
/** 查看全部电台 */
@property (nonatomic, strong) UIButton *allRadioBtn;

/** 设置其他作品界面内容 */
- (void)setPlayOtherViewWithModel:(RadioPlayOtherModel *)model imageArray:(NSMutableArray *)array;

@end
