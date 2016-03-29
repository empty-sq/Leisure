//
//  RadioDetailInfoModel.m
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioDetailInfoModel.h"

@implementation RadioDetailInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"userinfo"]) {
        self.uname = value[@"uname"];
    } 
}

- (NSString *)description
{
    // 包含对象类型名称，以及对象的指针地址
    return [NSString stringWithFormat:@"<%@: %p> {coverimg: %@, title: %@, desc: %@, uname: %@, musicvisitnum: %@}", [self class], self, self.coverimg, self.title, self.desc, self.uname, self.musicvisitnum];
}

@end
