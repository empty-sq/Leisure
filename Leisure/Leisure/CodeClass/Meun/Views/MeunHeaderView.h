//
//  MeunHeaderView.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseView.h"
#import "MenuSearchBar.h"

@interface MeunHeaderView : BaseView

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *favoButton;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *writeButton;
@property (nonatomic, strong) MenuSearchBar *searchBar;

@end
