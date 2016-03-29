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
    } 
}

 /**
 *  重写描述方法
 */
- (NSString *)description {
    // 包含对象类型名称，以及对象的指针地址
    return [NSString stringWithFormat:@"<%@: %p> {count: %@, coverimg: %@, title: %@, desc: %@, uname: %@, radioid: %@}", [self class], self, self.count, self.coverimg, self.title, self.desc, self.uname, self.radioid];
}

@end
