//
//  CQAppsView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CQAppsView;
@protocol CQAppsViewDelegate <NSObject>
@required
/**
 *  当数据源更新的到时候调用，必须实现，需将新的数据源设置为当前的数据源
 */
- (void)dragCellCollectionView:(CQAppsView *)collectionView newDataArrayAfterMoving:(NSArray *)newDataArray;
@optional

- (void)dragCellCollectionView:(CQAppsView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath; // 将要拖动cell
- (void)dragCellMovingWithCollectionView:(CQAppsView *)collectionView; // 拖动过程中
- (void)dragCellCollectionView:(CQAppsView *)collectionView cellEndMoveAtIndexPath:(NSIndexPath *)indexPath; // 拖动cell结束
- (void)dragCellCollectionView:(CQAppsView *)collectionView moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath; // 成功交换了cell
@end

@protocol CQAppsViewDataSource <NSObject>

@required
/**
 *  返回整个CollectionView的数据，必须实现，需根据数据进行移动后的数据重排
 */
- (NSArray *)dataSourceArrayOfCollectionView:(CQAppsView *)collectionView;

@end

@interface CQAppsView : UICollectionView

@property(nonatomic,assign)BOOL beginEditing;

@property(nonatomic,weak)id<CQAppsViewDelegate> viewDelegate;
@property(nonatomic,weak)id<CQAppsViewDataSource> viewDataSource;
@end
