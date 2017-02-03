//
//  CQCollectionViewCell.m
//  CQCollectionView
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCollectionViewCell.h"

@interface CQCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation CQCollectionViewCell

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    
    self.imgView.image = [UIImage imageNamed:icon];
}


@end
