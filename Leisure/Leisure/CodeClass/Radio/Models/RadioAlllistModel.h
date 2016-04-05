//
//  RadioAlllistModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface RadioAlllistModel : BaseModel

@property (nonatomic, assign) BOOL isnew;
@property (nonatomic, copy) NSNumber *count;
/** 电台图片 */
@property (nonatomic, copy) NSString *coverimg;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 描述 */
@property (nonatomic, copy) NSString *desc;
/** 作者 */
@property (nonatomic, copy) NSString *uname;
/**  作者头像 */
@property (nonatomic, copy) NSString *icon;
/** 电台id */
@property (nonatomic, copy) NSString *radioid;
/** 总电台数 */
@property (nonatomic, assign) NSInteger total;

@end
