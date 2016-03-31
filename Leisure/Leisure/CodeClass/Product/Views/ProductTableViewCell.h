//
//  ProductTableViewCell.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListModel.h"

@interface ProductTableViewCell : UITableViewCell

@property (nonatomic, strong) ProductListModel *model;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end
