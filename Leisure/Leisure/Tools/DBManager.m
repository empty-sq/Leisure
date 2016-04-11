//
//  DBManager.m
//  Leisure
//
//  Created by 沈强 on 16/4/11.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "DBManager.h"

static DBManager *_manager = nil;

@implementation DBManager

+ (DBManager *)defaultDBManager:(NSString *)dbName {
    // 互斥锁
    @synchronized (self) {
        if (!_manager) {
            _manager = [[DBManager alloc] initWithDBName:dbName];
        }
    }
    return _manager;
}

- (instancetype)initWithDBName:(NSString *)dbName {
    if (self = [super init]) {
        if (!dbName) { // 如果数据库不存在
            SQLog(@"创建数据库失败");
        } else {
            // 获取沙盒路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // 创建数据库路径
            NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@", dbName]];
            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            if (!exist) { // exist == 0 创建路径成功
                SQLog(@"数据库路径: %@", dbPath);
            } else {
                SQLog(@"数据库路径: %@", dbPath);
            }
            [self openDB:dbPath];
        }
    }
    return self;
}

/**
 *  打开数据库
 */
- (void)openDB:(NSString *)dbPath {
    if (!_dataBase) {
        self.dataBase = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_dataBase open]) {
        SQLog(@"不能打开数据库");
    }
}

/**
 *  关闭数据库
 */
- (void)closeDB {
    [_dataBase close];
    _manager = nil;
}

- (void)dealloc {
    [self closeDB];
}

@end
