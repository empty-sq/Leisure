//
//  DownloadManager.m
//  Leisure
//
//  Created by 沈强 on 16/4/12.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager ()

/** 用来保存下载对象 */
@property (nonatomic, strong) NSMutableDictionary *downloadDic;

@end

@implementation DownloadManager

- (NSMutableDictionary *)downloadDic {
    if (!_downloadDic) {
        _downloadDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _downloadDic;
}

+ (instancetype)defaultManager {
    static DownloadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc] init];
    });
    return manager;
}

- (Download *)addDownloadWithUrl:(NSString *)url {
    // 根据地址查找字典中的下载对象，如果不存在要创建新的
    Download *download = self.downloadDic[url];
    if (!download) {
        download = [[Download alloc] initWithUrl:url];
        [self.downloadDic setObject:download forKey:url];
    }
    return download;
}

- (void)removeDownloadWithUrl:(NSString *)url {
    [self.downloadDic removeObjectForKey:url];
}

- (NSArray *)findAllDownload {
    NSMutableArray *arr = [NSMutableArray array];
    // 遍历字典中所有的下载对象，放到数组中
    for (NSString *url in self.downloadDic) {
        NSLog(@"%@", url);
        [arr addObject:self.downloadDic[url]];
    }
    return arr;
}

@end
