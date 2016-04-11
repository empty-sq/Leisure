//
//  ReadDetailDB.m
//  Leisure
//
//  Created by 沈强 on 16/4/11.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadDetailDB.h"

@implementation ReadDetailDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager defaultDBManager:SQLITENAME].dataBase;
    }
    return self;
}

/** 查询数据表 */
- (void)createDataTable {
    // 查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'", READDETAILTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        SQLog(@"数据表已经存在");
    } else {
        // 创建新的数据表
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userID text, title text, contentID text, content text, name text, coverimg text)", READDETAILTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            SQLog(@"数据表创建成功");
        } else {
            SQLog(@"数据表创建失败");
        }
    }
}

/**
 *  插入一条数据
 */
- (void)saveDetailModel:(ReadDetailListModel *)model {
    // 创建插入语句
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@ (userID,title,contentid,content, name, coverimg) values (?,?,?,?,?,?)", READDETAILTABLE];
    // 创建插入内容
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:0];
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        [arguments addObject:[UserInfoManager getUserID]];
    }
    if (model.title) {
        [arguments addObject:model.title];
    }
    if (model.contentid) {
        [arguments addObject:model.contentid];
    }
    if (model.content) {
        [arguments addObject:model.content];
    }
    if (model.name) {
        [arguments addObject:model.name];
    }
    if (model.coverimg) {
        [arguments addObject:model.coverimg];
    }
    SQLog(@"%@",query);
    SQLog(@"收藏一条数据");
    // 执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

/**
 *  删除一条数据
 */
- (void) deleteDetailWithTitle:(NSString *)detailTitle {
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE title = '%@'", READDETAILTABLE, detailTitle];
    SQLog(@"删除成功");
    [_dataBase executeUpdate:query];
}

/**
 *  查询所有数据
 */
- (NSArray *)findWithUserID:(NSString *)userID {
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userID = '%@'", READDETAILTABLE, userID];
    FMResultSet * rs = [_dataBase executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next]) {
        ReadDetailListModel * detailModel = [[ReadDetailListModel alloc] init];
        detailModel.title = [rs stringForColumn:@"title"];
        detailModel.contentid = [rs stringForColumn:@"contentid"];
        detailModel.content = [rs stringForColumn:@"content"];
        detailModel.name = [rs stringForColumn:@"name"];
        detailModel.coverimg = [rs stringForColumn:@"coverimg"];
        [array addObject:detailModel];
    }
    [rs close];
    return array;
}

@end
