//
//  RadioDetailListModel.m
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioDetailListModel.h"

@implementation RadioDetailListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"coverimg"]) {
        self.icon = value;
    }
}

- (NSString *)description
{
    // 包含对象类型名称，以及对象的指针地址
    return [NSString stringWithFormat:@"<%@: %p> {icon: %@, title: %@, musicVisit: %ld, tingid: %@}", [self class], self, self.icon, self.title, (long)self.musicVisit, self.tingid];
}

@end
