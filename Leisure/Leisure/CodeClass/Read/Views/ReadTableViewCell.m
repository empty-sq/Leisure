//
//  ReadTableViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ReadTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface ReadTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ReadTableViewCell

- (void)setModel:(ReadDetailListModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:kImage];
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
