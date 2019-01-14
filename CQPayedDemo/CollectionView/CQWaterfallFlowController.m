//
//  CQWaterfallFlowController.m
//  CQCollectionView
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQWaterfallFlowController.h"
#import "CQWaterfallFlowCell.h"
#import "CQWaterFlowLayout.h"

@interface CQWaterfallFlowController ()<UICollectionViewDelegate,UICollectionViewDataSource,CQWaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet CQWaterFlowLayout *flowLayout;

@end

@implementation CQWaterfallFlowController

static NSString * const reuseIdentifier = @"CellWaterfall";

- (void)refreshData {
    [self.flowLayout refresh];
}
- (void)loadMoreData {
    
    [self.flowLayout addItemsAtIndex:self.flowLayout.numberOfItems addedItemsCount:10];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshData)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"加载" style:UIBarButtonItemStylePlain target:self action:@selector(loadMoreData)];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    self.flowLayout.numberOfItems = 10;
    self.flowLayout.delegate = self;
    self.flowLayout.columnNumber = 4;
    self.flowLayout.verticalMargin = 5.0;
    self.flowLayout.horizontalMargin = 10.0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.flowLayout calculateLayoutFromIndex:0 reloadAfterCalculated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)heightWidthRatioForItemAtIndex:(NSInteger)index{
    return ((rand() % 10) + 1) * 0.3;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.flowLayout.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CQWaterfallFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.titleLab.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    
    return cell;
}


@end
