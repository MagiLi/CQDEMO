//
//  CQFooterView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQFooterView.h"

@implementation CQFooterView

+ (CQFooterView *)footerViewWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath {
    CQFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    return footerView;
}
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - setupUI
- (void)setupUI {
    [self setGradientBackgroundWithColors:@[[UIColor blackColor],[UIColor whiteColor]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

@end
