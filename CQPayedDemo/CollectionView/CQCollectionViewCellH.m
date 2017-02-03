//
//  CQCollectionViewCellH.m
//  CQCollectionView
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCollectionViewCellH.h"

@interface CQCollectionViewCellH ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation CQCollectionViewCellH

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    
    self.imgView.image = [UIImage imageNamed:icon];
}

@end
