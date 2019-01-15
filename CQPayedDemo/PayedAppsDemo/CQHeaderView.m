//
//  CQHeaderView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQHeaderView.h"

@interface CQHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation CQHeaderView

+ (CQHeaderView *)headerViewWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title {
    CQHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headView.titleLab.text = title;
    
    return headView;
}
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark - setupUI
- (void)setupUI {
    [self setGradientBackgroundWithColors:@[[UIColor whiteColor],[UIColor blackColor]]  locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
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
