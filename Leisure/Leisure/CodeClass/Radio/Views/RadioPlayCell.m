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
/** 作者名字 */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation RadioPlayCell

- (void)setModel:(RadioDetailListModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _usernameLabel.text = [NSString stringWithFormat:@"by: %@", model.uname];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
