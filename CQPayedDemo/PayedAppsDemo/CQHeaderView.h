//
//  CQHeaderView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQHeaderView : UICollectionReusableView

+ (CQHeaderView *)headerViewWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title;

@end
