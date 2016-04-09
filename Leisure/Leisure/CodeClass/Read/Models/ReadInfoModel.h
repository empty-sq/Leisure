//
//  ReadInfoModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"
#import "ReadInfoCounterModel.h"
#import "ReadShareinfoModel.h"

@interface ReadInfoModel : BaseModel

@property (nonatomic, assign) BOOL isfav;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, copy) NSString *html;

@property (nonatomic, strong) ReadInfoCounterModel *counter;
@property (nonatomic, strong) ReadShareinfoModel *shareInfo;

@end
