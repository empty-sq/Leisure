//
//  RadioTableViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/4/2.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioTableViewCell.h"

@interface RadioTableViewCell ()

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 作者 */
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
/** 介绍 */
@property (weak, nonatomic) IBOutlet UILabel *introudeLabel;
/** 播放量 */
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

@end

@implementation RadioTableViewCell

- (void)setModel:(RadioAlllistModel *)model {
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:kImage];
    _titleLabel.text = model.title;
    _unameLabel.text = [NSString stringWithFormat:@"by: %@", model.uname];
    _introudeLabel.text = model.desc;
    _playCountLabel.text = [NSString stringWithFormat:@"%@", model.count];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
