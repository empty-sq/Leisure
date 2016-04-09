//
//  ProductCommentlistModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"
#import "ProductUserInfoModel.h"

@interface ProductCommentlistModel : BaseModel

/** 评论的时间 */
@property (nonatomic, copy) NSString *addtime_f;
/** 评论的内容 */
@property (nonatomic, copy) NSString *content;
/** 评论id */
@property (nonatomic, copy) NSString *contentid;
/** 页面 */
@property (nonatomic, copy) NSString *html;

/** 评论的用户信息 */
@property (nonatomic, strong) ProductUserInfoModel *userInfo;

@end
