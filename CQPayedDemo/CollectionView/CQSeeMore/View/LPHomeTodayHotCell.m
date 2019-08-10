//
//  LPHomeTodayHotCell.m
//  LPYProjrect
//
//  Created by Mac on 2019/2/27.
//  Copyright © 2019 LvPai Culture. All rights reserved.
//

#import "LPHomeTodayHotCell.h"
#import "LPHotProductionCell.h"
#import "LPSeeMoreView.h"

#define ItemCount 5
#define ItemWidth 111.0
#define ItemLineSpacing 10.0
#define ItemTopSpacing 10.0
#define ItemLefttSpacing 10.0
#define ItemBottomSpacing 10.0
#define ItemRightSpacing 10.0

@interface LPHomeTodayHotCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *productionView;
@property (nonatomic, strong) LPSeeMoreView *moreView;
@property (nonatomic, assign) CGFloat moreViewMinWidth;// 查看更多view最小的width
@property (nonatomic, assign) CGFloat moreViewMaxWidth;// 查看更多view最大的width
@property (nonatomic, assign) CGFloat moreViewHeight;// 查看更多view的height
@end

@implementation LPHomeTodayHotCell
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f %f",scrollView.contentSize.width,scrollView.contentOffset.x + kScreenWidth);
    if (scrollView.contentSize.width < kScreen_W) return;// 内容较少没有更多
    // 查看更多view移动的值value
    CGFloat value = scrollView.contentOffset.x + kScreen_W - scrollView.contentSize.width - ItemLineSpacing;
    if (value > 0) {// 滚动到最后的位置,展示 "查看更多"View
        if (value <= self.moreViewMinWidth) {
            self.moreView.width = self.moreViewMinWidth;
            self.moreView.x = kScreen_W - value;
        } else {
            if (value <= self.moreViewMaxWidth) {
                self.moreView.width = value;
            } else {
                self.moreView.width = self.moreViewMaxWidth;
            }
            self.moreView.x = kScreen_W - self.moreView.width;
        }
        if (value > self.moreViewMinWidth + 20) {// +10的目的是为了展示出来一定的弧度再显示"松开查看"
            self.moreView.title = @"松开查看";
        } else {
            self.moreView.title = @"查看更多";
        }
        [self.moreView setNeedsDisplay];
    } else {
        if (self.moreView.x < kScreen_W) {
            self.moreView.x = kScreen_W;
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentSize.width < kScreen_W) return;// 内容较少没有更多
    CGFloat value = scrollView.contentOffset.x + kScreen_W - scrollView.contentSize.width - ItemLineSpacing;
    if (value > self.moreViewMinWidth + 20) {
        if ([self.delegate respondsToSelector:@selector(seeMoreEvent)]) {
            [self.delegate seeMoreEvent];
        }
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ItemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPHotProductionCell *cell = [LPHotProductionCell cellWithCollectionView:collectionView withIndexPath:indexPath withMode:nil];
    return cell;;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}
+ (LPHomeTodayHotCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withData:(NSArray *)dictArray {
    LPHomeTodayHotCell *cell = [tableView dequeueReusableCellWithIdentifier:LPHomeTodayHotCellID forIndexPath:indexPath];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.moreViewHeight = LPHomeTodayHotCellH - ItemTopSpacing - ItemBottomSpacing;
        self.moreViewMinWidth = 50.0;
        self.moreViewMaxWidth = self.moreViewMinWidth + (self.moreViewHeight - MarginTop*2.0)*0.5;
        [self.contentView  addSubview:self.moreView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ItemWidth, LPHomeTodayHotCellH - ItemTopSpacing - ItemBottomSpacing);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = ItemLineSpacing;
        layout.minimumInteritemSpacing = 0;
        UICollectionView *productionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, LPHomeTodayHotCellH) collectionViewLayout:layout];
//        productionView.pagingEnabled = YES;
        productionView.delegate = self;
        productionView.dataSource = self;
        productionView.backgroundColor = [UIColor clearColor];
        productionView.alwaysBounceHorizontal = YES;
        productionView.showsHorizontalScrollIndicator = NO;
        productionView.contentInset = UIEdgeInsetsMake(ItemTopSpacing, ItemLefttSpacing, ItemBottomSpacing, ItemRightSpacing + self.moreViewMinWidth - SeeMoreLabel_Right);
        [productionView registerClass:[LPHotProductionCell class] forCellWithReuseIdentifier:LPHotProductionCellID];
        [self.contentView addSubview:productionView];
        self.productionView = productionView;
    }
    return self;
}
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
}
- (LPSeeMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[LPSeeMoreView alloc] initWithFrame:CGRectMake(kScreen_W, ItemLineSpacing, self.moreViewMinWidth, self.moreViewHeight)];
        _moreView.minWidth = self.moreViewMinWidth;
        _moreView.maxWidth = self.moreViewMaxWidth;
//        _moreView.layer.cornerRadius = 3.0;
//        _moreView.layer.masksToBounds = YES;
    }
    return _moreView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
