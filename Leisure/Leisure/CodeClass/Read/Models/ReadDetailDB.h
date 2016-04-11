//
//  ReadDetailDB.h
//  Leisure
//
//  Created by 沈强 on 16/4/11.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "DBManager.h"
#import "ReadDetailListModel.h"

@interface ReadDetailDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

/** 创建数据表 */
- (void)createDataTable;

/** 插入一条数据 */
- (void)saveDetailModel:(ReadDetailListModel *)model;

/** 删除一条数据 */
- (void)deleteDetailWithTitle:(NSString *)detailTitle;

/** 查询所有数据 */
- (NSArray *)findWithUserID:(NSString *)userID;

@end
