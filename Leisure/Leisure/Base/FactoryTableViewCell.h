//
//  FactoryTableViewCell.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"

@interface FactoryTableViewCell : NSObject

+ (BaseTableViewCell *)createTableViewCellWithModel:(BaseModel *)model;

+ (BaseTableViewCell *)createTableViewCellWithModel:(BaseModel *)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
