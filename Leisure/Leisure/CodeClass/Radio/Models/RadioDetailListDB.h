//
//  RadioDetailListDB.h
//  Leisure
//
//  Created by 沈强 on 16/4/13.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DBManager.h"
#import "RadioDetailListModel.h"

@interface RadioDetailListDB : NSObject

/** 数据库操作对象 */
@property (nonatomic, strong) FMDatabase *dataBase;

/** 创建数据表 */
- (void)createDataTable;

/** 保存一条数据，将model数据和本地音频路径保存到数据表中 */
- (void)saveDataWithModel:(RadioDetailListModel *)model andPath:(NSString *)path;

/** 删除一条数据 */
- (void)deleteDetailWithTitle:(NSString *)detailTitle;

/** 查询所有数据 */
- (NSArray *)getAllRadios;

@end
