//
//  TopicTableViewCell.h
//  Leisure
//
//  Created by 沈强 on 16/4/1.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"

@interface TopicTableViewCell : UITableViewCell

@property (nonatomic, strong) TopicListModel *model;

+ (CGFloat)cellHeightForModel:(TopicListModel *)model;

@end
