//
//  RadioPlayOtherModel.h
//  Leisure
//
//  Created by 沈强 on 16/4/3.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface RadioPlayOtherModel : BaseModel

@property (nonatomic, assign) BOOL isfav;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, strong) NSNumber *comment;
@property (nonatomic, strong) NSNumber *like;
@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, copy) NSString *radioid;
@property (nonatomic, copy) NSString *radioname;
@property (nonatomic, copy) NSString *ting_contentid;
@property (nonatomic, copy) NSString *tingid;

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uname;

@end
