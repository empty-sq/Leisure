//
//  RadioPlayCell.h
//  Leisure
//
//  Created by 沈强 on 16/4/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailListModel.h"

@interface RadioPlayCell : UITableViewCell

/** 作者名字 */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) RadioDetailListModel *model;

@end
