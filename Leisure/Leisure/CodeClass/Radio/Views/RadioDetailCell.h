//
//  RadioDetailCell.h
//  Leisure
//
//  Created by 沈强 on 16/4/3.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailListModel.h"

@interface RadioDetailCell : UITableViewCell

/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) RadioDetailListModel *model;

@end
