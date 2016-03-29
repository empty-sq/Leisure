//
//  NetWorkRequestManager.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 定义枚举，用来表示请求的类型 */
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};

/** 网络请求完成的block */
typedef void (^RequestFinish)(NSData *data);
/** 网络请求失败的block */
typedef void (^RequsetError)(NSError *error);

@interface NetWorkRequestManager : NSObject

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequsetError)error;

@end
