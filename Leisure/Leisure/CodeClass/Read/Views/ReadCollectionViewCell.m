//
//  ReadCollectionViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation ReadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        [self addSubview:_coverImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight - 20, 30, 20)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_nameLabel];
        
        _ennameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right, kHeight - 15, 30, 10)];
        _ennameLabel.numberOfLines = 0;
        _ennameLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_ennameLabel];
    }
    return self;
}

/**
 *  重写model的set方法
 */
- (void)setModel:(ReadListModel *)model {
    _model = model;

    [_coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:kImage];
    _nameLabel.text = model.name;
    _ennameLabel.text = model.enname;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize nameSize = [_nameLabel.text sizeWithAttributes:@{NSFontAttributeName : _nameLabel.font}];
    _nameLabel.frame = CGRectMake(0, kHeight - 20, nameSize.width, 20);
    
    CGSize ennameSize = [_ennameLabel.text sizeWithAttributes:@{NSFontAttributeName : _ennameLabel.font}];
    _ennameLabel.frame = CGRectMake(_nameLabel.right, kHeight - 15, ennameSize.width, 10);
}

@end
