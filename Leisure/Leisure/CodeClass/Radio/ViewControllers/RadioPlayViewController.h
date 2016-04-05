//
//  RadioPlayViewController.h
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseViewController.h"
#import "RadioDetailListModel.h"

@interface RadioPlayViewController : BaseViewController

@property (nonatomic, strong) RadioDetailListModel *model;
/** 音乐播放列表 */
@property (nonatomic, strong) NSArray *listDataArray;
/** 音乐的下标 */
@property (nonatomic, assign) NSInteger index;

@end
