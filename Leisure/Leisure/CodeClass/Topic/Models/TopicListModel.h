//
//  TopicListModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"
#import "TopicCounterListModel.h"
#import "TopicUserInfoModel.h"

@interface TopicListModel : BaseModel

@property (nonatomic, assign) BOOL isshot;
/** 是否是推荐贴 */
@property (nonatomic, assign) BOOL isrecommend;
/** 时间戳 */
@property (nonatomic, copy) NSString *addtime;
/** 时间间隔 */
@property (nonatomic, copy) NSString *addtime_f;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 话题的id */
@property (nonatomic, copy) NSString *contentid;
/** 图片地址 */
@property (nonatomic, copy) NSString *coverimg;
/** 标题 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *songid;

/** 计数对象 */
@property (nonatomic, strong) TopicCounterListModel *counter;
/** 用户信息 */
@property (nonatomic, strong) TopicUserInfoModel *userInfo;

@end
