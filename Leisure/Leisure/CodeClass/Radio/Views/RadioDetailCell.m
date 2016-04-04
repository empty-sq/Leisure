//
//  RadioDetailCell.m
//  Leisure
//
//  Created by 沈强 on 16/4/3.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioDetailCell.h"

@interface RadioDetailCell ()

/** 图标 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 播放量 */
@property (weak, nonatomic) IBOutlet UILabel *playLabel;

@end

@implementation RadioDetailCell

- (void)setModel:(RadioDetailListModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:kImage];
    _titleLabel.text = model.title;
    _playLabel.text = model.musicVisit;
}

- (void)awakeFromNib {
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.playBtn.layer.cornerRadius = 15;
    self.playBtn.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
