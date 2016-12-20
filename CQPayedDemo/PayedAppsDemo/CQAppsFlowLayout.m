//
//  CQAppsFlowLayout.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAppsFlowLayout.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface CQAppsFlowLayout ()<UICollectionViewDelegateFlowLayout>

@end

@implementation CQAppsFlowLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    float cellWidth = floor((SCREEN_W - 50)/4.0);
    self.itemSize = CGSizeMake(cellWidth, cellWidth);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_W, 25);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_W, 15);
}


@end
