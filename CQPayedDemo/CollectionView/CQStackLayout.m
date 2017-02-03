//
//  CQStackLayout.m
//  CQCollectionView
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQStackLayout.h"

#define kCalcAngle(x) x * M_PI / 180.0

@implementation CQStackLayout


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = CGSizeMake(50, 50);
    attrs.center = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5 - 25);

    NSInteger index = indexPath.item;
    CGFloat angles[] ={0,15,30,45,60};
    NSInteger count = [self.collectionView numberOfItemsInSection:0];

    if (index >= 5) {
        attrs.hidden = YES;
    } else {
        attrs.transform = CGAffineTransformMakeRotation(kCalcAngle(angles[index]));
        attrs.zIndex = count - index;
    }

    return attrs;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];

    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }

    return array;
}


@end
