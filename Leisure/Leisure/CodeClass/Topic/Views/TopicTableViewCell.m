//
//  TopicTableViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/4/1.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "TopicTableViewCell.h"

@interface TopicTableViewCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 时间 */
@property (nonatomic, strong)  UILabel *timeLabel;
/** 图片 */
@property (nonatomic, strong) UIImageView *coverImage;
/** 精 */
@property (nonatomic, strong) UIImageView *recommendImage;
/** 话题 */
@property (nonatomic, strong) UIImageView *topicImage;
/** 评论数 */
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation TopicTableViewCell

#define kMargin 10
#define kCoverImageW 80

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _recommendImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _recommendImage.image = [UIImage imageNamed:@"jing"];
        [self.contentView addSubview:_recommendImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        
        _coverImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_coverImage];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_contentLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
        
        _topicImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topicImage.image = [UIImage imageNamed:@"评论1"];
        [self.contentView addSubview:_topicImage];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_model.isrecommend) {
        _recommendImage.frame = CGRectMake(kMargin, kMargin, 20, 20);
    }
    
    CGFloat titleX = CGRectGetMaxX(_recommendImage.frame) + 5;
    CGFloat titleW = kScreenWidth - kMargin -titleX;
    _titleLabel.frame = CGRectMake(titleX, kMargin, titleW, 20);
    
    CGFloat timeY = 0;
    self.coverImage.hidden = YES;
    if (![_model.coverimg  isEqual: @""]) {
        self.coverImage.hidden = NO;
        CGFloat coverY = CGRectGetMaxY(_titleLabel.frame) + kMargin;
        _coverImage.frame = CGRectMake(kMargin, coverY, kCoverImageW, kCoverImageW);
        timeY = CGRectGetMaxY(_coverImage.frame) + kMargin;
    }
    
    if (![_model.content isEqualToString:@""]) {
        CGFloat contentH = [_model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        contentH = contentH <= kCoverImageW ? contentH : kCoverImageW;
        CGFloat contentX = CGRectGetMaxX(_coverImage.frame) + kMargin;
        CGFloat contentY = CGRectGetMaxY(_titleLabel.frame) + kMargin;
        CGFloat contentW = kScreenWidth - contentX - kMargin;
        _contentLabel.frame = CGRectMake(contentX, contentY, contentW, contentH);
        if (timeY == 0) {
            timeY = CGRectGetMaxY(_contentLabel.frame) + kMargin;
        }
    } else {
        timeY = CGRectGetMaxY(_titleLabel.frame) + kMargin;
    }
    
    _timeLabel.frame = CGRectMake(kMargin, timeY, 100, 20);
    
    CGFloat topicImgX = kScreenWidth - 80;
    _topicImage.frame = CGRectMake(topicImgX, timeY + 3, 15, 15);
    
    CGFloat commentX = CGRectGetMaxX(_topicImage.frame) + kMargin;
    _commentLabel.frame = CGRectMake(commentX, timeY + 3, kCoverImageW, 20);
    [_commentLabel sizeToFit];
}

- (void)setModel:(TopicListModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    if (![_model.coverimg  isEqual: @""]) {
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:kImage];
    }
    _timeLabel.text = model.addtime_f;
    _contentLabel.text = model.content;
    _commentLabel.text = [NSString stringWithFormat:@"%@", model.counter.comment];
}

+ (CGFloat)cellHeightForModel:(TopicListModel *)model {
    CGFloat height = 0;
    CGFloat otherH = 75;
    if (![model.coverimg isEqualToString:@""]) {
        height = kCoverImageW;
    } else {
        if (![model.content isEqualToString:@""]) {
            height = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            height = height <= kCoverImageW ? height : kCoverImageW;
        } else {
            otherH = 65;
        }
    }
    return height + otherH;
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
