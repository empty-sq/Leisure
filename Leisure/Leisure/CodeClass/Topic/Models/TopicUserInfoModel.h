//
//  TopicUserInfoModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface TopicUserInfoModel : BaseModel

/** 头像 */
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uname;

@end
