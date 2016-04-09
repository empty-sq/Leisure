//
//  ProductInfoViewController.h
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductInfoViewController : BaseViewController

/** 商品id */
@property (nonatomic, copy) NSString *contentid;
/** 标题 */
@property (nonatomic, copy) NSString *titleName;

@end
