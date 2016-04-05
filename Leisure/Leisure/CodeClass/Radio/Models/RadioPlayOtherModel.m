//
//  RadioPlayOtherModel.m
//  Leisure
//
//  Created by 沈强 on 16/4/3.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioPlayOtherModel.h"

@implementation RadioPlayOtherModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"authorinfo"]) {
        _authorIcon = value[@"icon"];
        _authorUname = value[@"uname"];
    }
    if ([key isEqualToString:@"userinfo"]) {
        _userIcon = value[@"icon"];
        _username = value[@"uname"];
    }
}

@end
