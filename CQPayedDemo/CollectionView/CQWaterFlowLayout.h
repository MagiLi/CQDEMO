//
//  CQWaterFlowLayout.h
//  CQPayedDemo
//
//  Created by Mac on 2019/1/14.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CQWaterFlowLayout;
void layoutInit(CQWaterFlowLayout *layout);
@protocol CQWaterFlowLayoutDelegate <NSObject>

@optional
/*获取指定位置的单元格长宽比*/
-(CGFloat)heightWidthRatioForItemAtIndex:(NSInteger)index;

@end
@interface CQWaterFlowLayout : UICollectionViewFlowLayout
{
    //全体内容的高度
    CGFloat _contentHeight;
    //各列的高度
    CGFloat *_perColumnHeights;
    //各个单元格的布局信息
    CGRect *_rectsForItems;
    int _rectForItemsContainerSize;
    NSInteger _columnHeightSize;
}
@property (nonatomic,weak) id<CQWaterFlowLayoutDelegate> delegate;
/*底部空白区域的大小*/
@property (nonatomic) CGFloat horizontalMargin;
@property (nonatomic) CGFloat verticalMargin;
@property (nonatomic) CGFloat collectionViewWidth;
/*列数*/
@property (nonatomic) NSInteger columnNumber;
@property (nonatomic,strong) NSMutableArray *layoutAttributes;
@property (nonatomic) NSInteger numberOfItems;
//单元格的高度与宽度的比例
@property (nonatomic) CGFloat heightWidthRatio;
/*此方法在当前线程计算布局*/
-(NSMutableArray<UICollectionViewLayoutAttributes *> *)calculateLayoutFromIndex:(NSInteger)index;
/*此方法在子线程计算布局*/
-(void)calculateLayoutFromIndex:(NSInteger)index reloadAfterCalculated:(BOOL)needReload;
/*此方法在子线程计算布局,并提供回调,供开发者自行进行下一步操作*/
-(void)calculateLayoutFromIndex:(NSInteger)index calculateFinishedBlock:(void (^)(CQWaterFlowLayout *layout))block;
-(void)reloadData;
-(void)refresh;
-(void)addItemsAtIndex:(NSInteger)insertIndex addedItemsCount:(NSInteger)addedItemsCount;
@end

NS_ASSUME_NONNULL_END
