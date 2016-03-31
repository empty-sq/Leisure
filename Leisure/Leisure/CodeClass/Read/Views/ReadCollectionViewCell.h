//
//  ReadCollectionViewCell.h
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "ReadListModel.h"

@interface ReadCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) UIImageView *coverImage;
@property (nonatomic, strong) UILabel *ennameLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) ReadListModel *model;

@end
