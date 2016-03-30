//
//  TopicCounterListModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCounterListModel : BaseModel

/** 评论次数 */
@property (nonatomic, copy) NSString *comment;
/** 喜欢次数 */
@property (nonatomic, copy) NSString *like;
/** 查看次数 */
@property (nonatomic, copy) NSString *view;

@end