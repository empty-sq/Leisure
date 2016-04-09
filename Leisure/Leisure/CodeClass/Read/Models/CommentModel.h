//
//  CommentModel.h
//  Leisure
//
//  Created by 沈强 on 16/4/8.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"
#import "CommentUserModel.h"

@interface CommentModel : BaseModel

@property (nonatomic, strong) NSString *addtime_f;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentid;
@property (nonatomic, assign) BOOL isdel;
/** 总数 */
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) CommentUserModel *userInfo;

@end
