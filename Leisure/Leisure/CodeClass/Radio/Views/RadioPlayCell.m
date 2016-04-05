//
//  RadioPlayCell.m
//  Leisure
//
//  Created by 沈强 on 16/4/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "RadioPlayCell.h"

@interface RadioPlayCell ()

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 选中时出现的颜色 */
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageVIew;

@end

@implementation RadioPlayCell

- (void)setModel:(RadioDetailListModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _usernameLabel.text = [NSString stringWithFormat:@"by: %@", model.uname];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedImageVIew.hidden = !selected;
}

/**
 *  可以在这个方法中监听cell的选中和取消选中
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    // 重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 4;
}

@end
