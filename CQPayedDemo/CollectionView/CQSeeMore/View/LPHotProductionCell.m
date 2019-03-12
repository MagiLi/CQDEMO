//
//  LPHotProductionCell.m
//  LPYProjrect
//
//  Created by Mac on 2019/2/27.
//  Copyright © 2019 LvPai Culture. All rights reserved.
//

#import "LPHotProductionCell.h"

@implementation LPHotProductionCell
+ (LPHotProductionCell *)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath withMode:(id )model {
    LPHotProductionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LPHotProductionCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = kColor_random;
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
