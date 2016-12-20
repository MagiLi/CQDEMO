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

@end
