//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"
#import "RadioPlayOtherModel.h"

@interface RadioDetailListModel : BaseModel

/** 图标 */
@property (nonatomic, copy) NSString *coverimg;
/** 播放量 */
@property (nonatomic, strong) NSString *musicVisit;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 作者名字 */
@property (nonatomic, copy) NSString *uname;
/** 电台总数 */
@property (nonatomic, assign) NSInteger total;
/** 网页地址 */
@property (nonatomic, copy) NSString *webview_url;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, assign) bool isnew;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, assign) bool isSelect;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *imgTitle;

@end
