//
//  BaseNavigationController.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"

@interface BaseNavigationController : UINavigationController

@property (nonatomic, strong) CustomNavigationBar *bar;

@end
