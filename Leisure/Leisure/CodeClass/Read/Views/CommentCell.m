//
//  CommentCell.m
//  Leisure
//
//  Created by 沈强 on 16/4/8.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommentCell

- (void)setModel:(CommentModel *)model {
    _addtimeLabel.text = model.addtime_f;
    _unameLabel.text = model.userInfo.uname;
    _contentLabel.text = model.content;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.icon]];
}

+ (CGFloat)cellHeightForModel:(CommentModel *)model {
    CGFloat height = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    return height + 65;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
