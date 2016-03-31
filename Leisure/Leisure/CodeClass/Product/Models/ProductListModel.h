//
//  ProductListModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface ProductListModel : BaseModel

/** 购买地址 */
@property (nonatomic, copy) NSString *buyurl;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 图片地址 */
@property (nonatomic, copy) NSString *coverimg;
/** 商品id */
@property (nonatomic, copy) NSString *contentid;

@end
