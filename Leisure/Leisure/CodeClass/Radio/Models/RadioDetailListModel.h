//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by 沈强 on 16/3/29.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseModel.h"

@interface RadioDetailListModel : BaseModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger musicVisit;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, assign) bool isnew;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, assign) bool isSelect;

@end
