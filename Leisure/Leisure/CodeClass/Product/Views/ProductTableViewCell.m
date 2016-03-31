//
//  ProductTableViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ProductTableViewCell.h"

@interface ProductTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ProductTableViewCell

- (void)setModel:(ProductListModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"占位图.jpg"]];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
