//
//  ReadListModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface ReadListModel : BaseModel

/**  图像 */
@property (nonatomic, copy) NSString *coverimg;
/** 副名称 */
@property (nonatomic, copy) NSString *enname;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 主题 */
@property (nonatomic, copy) NSString *type; 

@end
