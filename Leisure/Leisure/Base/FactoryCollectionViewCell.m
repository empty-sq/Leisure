//
//  FactoryCollectionViewCell.m
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+ (BaseCollectionViewCell *)createCollectionViewCellWithModel:(BaseModel *)model collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    // 1、类名转字符串
    NSString *name = NSStringFromClass([model class]);
    // 字符串转cell类名
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
    return cell;
}

@end
