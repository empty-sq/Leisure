//
//  RadioDetailListDB.m
//  Leisure
//
//  Created by 沈强 on 16/4/13.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioDetailListDB.h"

@implementation RadioDetailListDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager defaultDBManager:SQLITENAME].dataBase;
    }
    return self;
}

/** 查询数据表 */
- (void)createDataTable {
    // 查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'", RADIOETATLTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        SQLog(@"数据表已经存在");
    } else {
        // 创建新的数据表
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (radioID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, coverimg text, isnew integer, musicUrl text, title text, musicVisit text, savePath text)", RADIOETATLTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (res) {
            SQLog(@"数据表创建成功");
        } else {
            SQLog(@"数据表创建失败");
        }
    }
}

- (void)saveDataWithModel:(RadioDetailListModel *)model andPath:(NSString *)path {
        NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@ (coverimg,isnew,musicUrl,title, musicVisit, savePath) values (?,?,?,?,?,?)", RADIOETATLTABLE];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:0];
    [arguments addObject:model.tingid];
    if (model.coverimg) {
        [arguments addObject:model.coverimg];
    }
    if (model.isnew) {
        [arguments addObject:@(model.isnew)];
    }
    if (model.musicUrl) {
        [arguments addObject:model.musicUrl];
    }
    if (model.title) {
        [arguments addObject:model.title];
    }
    if (model.musicVisit) {
        [arguments addObject:model.musicVisit];
    }
    [arguments addObject:path];
    SQLog(@"%@, %d, %@, %@, %@, %@", model.coverimg, model.isnew, model.musicUrl, model.title, model.musicVisit, path);
    // 执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

/**
 *  删除一条数据
 */
- (void) deleteDetailWithTitle:(NSString *)musicUrl {
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE musicUrl = '%@'", RADIOETATLTABLE, musicUrl];
    SQLog(@"删除成功");
    [_dataBase executeUpdate:query];
}

/**
 *  查询所有数据
 */
- (NSArray *)getAllRadios {
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@", RADIOETATLTABLE];
    FMResultSet * rs = [_dataBase executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next]) {
        RadioDetailListModel * detailModel = [[RadioDetailListModel alloc] init];
        detailModel.coverimg = [rs stringForColumn:@"coverimg"];
        detailModel.isnew = [rs stringForColumn:@"isnew"];
        detailModel.musicUrl = [rs stringForColumn:@"musicUrl"];
        detailModel.title = [rs stringForColumn:@"title"];
        detailModel.musicVisit = [rs stringForColumn:@"musicVisit"];
        detailModel.path = [rs stringForColumn:@"savePath"];
        [array addObject:detailModel];
    }
    [rs close];
    return array;
}

@end
