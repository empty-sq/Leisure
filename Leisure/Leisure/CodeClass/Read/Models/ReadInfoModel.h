//
//  ReadInfoModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface ReadInfoModel : BaseModel

@property (nonatomic, assign) BOOL isfav;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, strong) NSNumber *typeID;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *contentid;
@property (nonatomic, strong) NSString *html;

@end
