//
//  RadioDetailViewController.h
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseViewController.h"

@class RadioAlllistModel;

@interface RadioDetailViewController : BaseViewController

/** 电台的id */
@property (nonatomic, copy) NSString *radioid;
/** 作者的名字 */
@property (nonatomic, copy) NSString *uname;

@end
