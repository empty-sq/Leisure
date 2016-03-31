//
//  FactoryTableViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell

+ (BaseTableViewCell *)createTableViewCellWithModel:(BaseModel *)model {
    // 1、将model类名转成字符串
    NSString *name = NSStringFromClass([model class]);
    // 2、获取要创建的cell的类名
    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell", name]);
    // 3、创建cell对象
    BaseTableViewCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    return cell;
}

+ (BaseTableViewCell *)createTableViewCellWithModel:(BaseModel *)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *name = NSStringFromClass([model class]);
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
    return cell;
}

@end
