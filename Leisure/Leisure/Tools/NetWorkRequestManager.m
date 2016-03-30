//
//  NetWorkRequestManager.m
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequsetError)error {
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:type urlString:urlString parDic:parDic finish:finish error:error];
}

- (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequsetError)requsetError {
    // 拿到参数之后进行请求
    NSURL *URL = [NSURL URLWithString:urlString];
    // 创建可变的URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // 如果请求方式是POST需要设置参数和请求方式
    if (type == POST) {
        // 设置请求方式
        [request setHTTPMethod:@"POST"];
        if (parDic.count > 0) {
            NSData *data = [self parDicToDataWithDic:parDic];
            // 设置请求参数的Body体
            [request setHTTPBody:data];
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            finish(data);
        } else {
            requsetError(error);
        }
    }];
    [task resume];
}

/** 把参数字典转为POST请求所需要的参数体 */
- (NSData *)parDicToDataWithDic:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray array];
    // 遍历字典得到每一个键，得到所有的 Key=Value 类型的字符串
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, dic[key]];
        [array addObject:str];
    }
    // 数组里所有Key=Value的字符串通过&符号连接
    NSString *parString = [array componentsJoinedByString:@"&"];
    return [parString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
