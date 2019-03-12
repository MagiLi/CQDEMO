//
//  LPHotProductionCell.h
//  LPYProjrect
//
//  Created by Mac on 2019/2/27.
//  Copyright © 2019 LvPai Culture. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *LPHotProductionCellID = @"LPHotProductionCellID";

@protocol LPHotProductionCellDelegate <NSObject>

@end

@interface LPHotProductionCell : UICollectionViewCell
@property (weak, nonatomic)id<LPHotProductionCellDelegate> delegate;
+ (LPHotProductionCell *)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath withMode:(id )model;
@end

NS_ASSUME_NONNULL_END
