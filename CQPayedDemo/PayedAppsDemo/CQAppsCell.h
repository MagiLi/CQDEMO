//
//  CQAppsCell.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQAppsModel.h"

static NSString * const reuseIdentifier = @"AppsCell";

@class CQAppsCell;
@protocol CQAppsCellDelegate <NSObject>
@required
- (void)stateButtonClickedEvents:(CQAppsCell *)cell;

@end

@interface CQAppsCell : UICollectionViewCell

+ (CQAppsCell *)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath withModel:(CQAppsModel *)model withEditing:(BOOL)editing;

@property(nonatomic,strong)CQAppsModel *model;
@property (nonatomic, weak) NSIndexPath *indexPath;
@property(nonatomic,weak)id<CQAppsCellDelegate> delegate;

@end
