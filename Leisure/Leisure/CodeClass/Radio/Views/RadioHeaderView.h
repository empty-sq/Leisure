//
//  RadioView.h
//  Leisure
//
//  Created by 沈强 on 16/4/1.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseView.h"
#import "RadioCarouselModel.h"
#import "RadioAlllistModel.h"

@interface RadioHeaderView : BaseView

/** 轮播图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 左按钮 */
@property (nonatomic, strong) UIButton *leftBtn;
/** 中间按钮 */
@property (nonatomic, strong) UIButton *midBtn;
/** 右按钮 */
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) RadioAlllistModel *allModel;
@property (nonatomic, strong) RadioCarouselModel *carouseModel;

@end
