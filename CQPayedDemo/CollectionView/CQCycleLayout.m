//
//  CQCollectionViewLayout.m
//  CQCollectionView
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCycleLayout.h"

#define kCalcAngle(x) x * M_PI / 180.0

@implementation CQCycleLayout
//- (void)prepareLayout
//- (CGSize)collectionViewContentSize

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    
    return array;
}
// 返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = CGSizeMake(50, 50);
    
    // 第几个Item
    NSInteger index = indexPath.item;
    
    // 半径100
    CGFloat radius = 100;
    
    // 圆心
    CGFloat circleX = self.collectionView.frame.size.width * 0.5;
    CGFloat circleY = self.collectionView.frame.size.height * 0.5;
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat singleItemAngle = 360.0 / count;
    
    // cosf:余弦  sinf:正弦
    // 计算各个环绕的图片center
    attrs.center = CGPointMake(circleX + radius * cosf(kCalcAngle(singleItemAngle * index)), circleY - radius * sinf(kCalcAngle(singleItemAngle * index)) - 25);
    return attrs;
}

@end
