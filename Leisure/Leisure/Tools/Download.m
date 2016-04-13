//
//  Download.m
//  Leisure
//
//  Created by 沈强 on 16/4/12.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "Download.h"

@interface Download ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** 保存断点数据 */
@property (nonatomic, strong) NSData *resumeData;
/** 用来保存下载地址 */
@property (nonatomic, copy) NSString *url;

@end

@implementation Download

- (instancetype)initWithUrl:(NSString *)urlPath {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.url = urlPath;
        //        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlPath]];
    }
    return self;
}

/**
 *  开始下载
 */
- (void)start {
    // 断点
    if (!self.downloadTask) {
        // 从文件中读取断点数据
        self.resumeData = [NSData dataWithContentsOfFile:[self creatFilePath]];
        if (!self.resumeData) {
            self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.url]];
        } else {
            self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
        }
    }
    [self.downloadTask resume];
}

/**
 *  暂停下载
 */
- (void)pause {
    // 暂停，不能调用cancel，cancel是取消任务
    //    [self.downloadTask suspend];
    
    // 断点下载
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        // 获取新的断点数据
        self.resumeData = resumeData;
        // 将task置空，因为再次开始时需要用新的断电数据来创建task
        self.downloadTask = nil;
        
        // 将data保存到本地，防止用户退出应用内存数据被回收
        [self.resumeData writeToFile:[self creatFilePath] atomically:YES];
    }];
}

/**
 *  创建下载文件的路径，第一个作用用来曹村断点数据(下载中使用)，第二作用用来保存最后下载完成的文件(下载完成后，会将保存的断点数据进行覆盖)
 */
- (NSString *)creatFilePath {
    // 获取caches文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 创建一个视频文件夹
    NSString *videoPath = [caches stringByAppendingPathComponent:@"videos"];
    NSFileManager *manage = [NSFileManager defaultManager];
    if (![manage fileExistsAtPath:videoPath]) {
        [manage createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 创建视频文件路径
    //    NSString *file = [videoPath stringByAppendingPathComponent:_downloadTask.response.suggestedFilename];
    
    // 在创建task时，因为task还为空，找不到创建的文件夹
    NSArray *arr = [self.url componentsSeparatedByString:@"/"];
    NSString *file = [videoPath stringByAppendingPathComponent:[arr lastObject]];
    return file;
}

/**
 *  当下载完成时被调用，将缓存数据保存到caches文件夹
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    // 创建视频文件路径
    NSString *file = [self creatFilePath];
    // 先把缓存数据清空掉
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    // 将数据移到文件路径下
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:file error:nil];
    NSLog(@"file = %@", file);
    
    // 下载完成后通过block将文件的网络路径和本地路径传出
    self.downloadFinish(self.url, file);
}

/**
 *  下载中被调用
 *
 *  @param bytesWritten              本次写入的字节数
 *  @param totalBytesWritten         总共写入的字节数
 *  @param totalBytesExpectedToWrite 下载的文件的字节数
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 获取下载进度
    float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    // 将进度值传出
    self.downloading(progress);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

/**
 *  请求完成时调用
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    
}

@end
