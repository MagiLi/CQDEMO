//
//  CQAppsController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAppsController.h"
#import "CQAppsView.h"
#import "CQHeaderView.h"
#import "CQFooterView.h"
#import "CQAppsCell.h"
#import "CQAppsDataManager.h"


@interface CQAppsController () <CQAppsViewDelegate, CQAppsViewDataSource>
@property(nonatomic,strong)CQAppsDataManager *dataManager;
@property (weak, nonatomic) IBOutlet CQAppsView *colView;


@end

@implementation CQAppsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(baginEditing:)];
    self.colView.viewDelegate = self;
    self.colView.viewDataSource = self;
    
    self.dataManager = [CQAppsDataManager sharedAppsDataManager];
    
}
- (void)baginEditing:(id)sender {
    
    self.colView.beginEditing = !self.colView.beginEditing;
    
    if (self.colView.beginEditing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else {
        self.navigationItem.rightBarButtonItem.title = @"管理";
    }
}

#pragma mark -
#pragma mark - CQAppsViewDelegate
- (void)dragCellCollectionView:(CQAppsView *)collectionView newDataArrayAfterMoving:(NSArray *)newDataArray {
    self.dataManager.dataArray = newDataArray.mutableCopy;
}

- (void)dragCellCollectionView:(CQAppsView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem.title = @"完成";
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)dragCellCollectionView:(CQAppsView *)collectionView cellEndMoveAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark - CQAppsViewDataSource
- (NSArray *)dataSourceArrayOfCollectionView:(CQAppsView *)collectionView {
    return self.dataManager.dataArray;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataManager.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataManager.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CQAppsCell *cell = [CQAppsCell cellWithCollectionView:collectionView withIndexPath:indexPath withModel:self.dataManager.dataArray[indexPath.section][indexPath.row] withEditing:self.colView.beginEditing];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader){
        reusableView = [CQHeaderView headerViewWithCollectionView:collectionView withIndexPath:indexPath withTitle:self.dataManager.titleArray[indexPath.section]];
    }else if (kind == UICollectionElementKindSectionFooter){
        
        reusableView = [CQFooterView footerViewWithCollectionView:collectionView withIndexPath:indexPath];
    }
    return reusableView;

}

#pragma mark <UICollectionViewDelegate>


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"=====dealloc=====");
}

@end
