//
//  ReadInfoViewController.h
//  Leisure
//
//  Created by 沈强 on 16/3/28.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadDetailListModel.h"

@interface ReadInfoViewController : BaseViewController

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) ReadDetailListModel *model;

@end
