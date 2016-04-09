//
//  CommentCell.h
//  Leisure
//
//  Created by 沈强 on 16/4/8.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentModel *model;
+ (CGFloat)cellHeightForModel:(CommentModel *)model;

@end
