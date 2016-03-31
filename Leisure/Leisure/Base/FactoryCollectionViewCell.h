//
//  FactoryCollectionViewCell.h
//  Leisure
//
//  Created by 沈强 on 16/3/31.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"

@interface FactoryCollectionViewCell : NSObject

+ (BaseCollectionViewCell *)createCollectionViewCellWithModel:(BaseModel *)model collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
