//
//  ReadCarouselModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface ReadCarouselModel : BaseModel

/**  图片地址 */
@property (nonatomic, copy) NSString *img;
/** 内容链接地址 */
@property (nonatomic, copy) NSString *url;

@end
