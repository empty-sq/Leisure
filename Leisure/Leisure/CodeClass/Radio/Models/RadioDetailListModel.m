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
    if ([key isEqualToString:@"playInfo"]) {
        _imgUrl = value[@"imgUrl"];
        _imgTitle = value[@"title"];
    }
    if ([key isEqualToString:@"userInfo"]) {
        _uname = value[@"uname"];
    }
}

@end
