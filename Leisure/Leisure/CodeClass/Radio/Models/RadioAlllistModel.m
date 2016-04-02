//
//  RadioAlllistModel.m
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioAlllistModel.h"

@implementation RadioAlllistModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"userinfo"]) {
        self.uname = value[@"uname"];
        self.icon = value[@"icon"];
    } 
}

@end
