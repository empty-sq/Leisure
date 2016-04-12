//
//  DownloadManager.h
//  Leisure
//
//  Created by 沈强 on 16/4/12.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Download.h"

@interface DownloadManager : NSObject

/**
 *  单例方法
 */
+ (instancetype)defaultManager;

/**
 *  添加下载对象的方法
 */
- (Download *)addDownloadWithUrl:(NSString *)url;

/**
 *  移除完成的下载对象
 */
- (void)removeDownloadWithUrl:(NSString *)url;

/**
 *  获取所有的下载对象
 */
- (NSArray *)findAllDownload;

@end
