//
//  CQCollectionHController.m
//  CQCollectionView
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCollectionHController.h"
#import "CQCollectionViewCellH.h"
#import "CQCellHFlowLayout.h"

@interface CQCollectionHController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *images;

@property(nonatomic,weak)UICollectionView *colView;
@end

@implementation CQCollectionHController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    CQCellHFlowLayout *layout = [[CQCellHFlowLayout alloc] init];
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 60) collectionViewLayout:layout];
    colView.delegate = self;
    colView.dataSource = self;
    colView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:colView];
    self.colView = colView;
//    [colView registerClass:[CQCollectionViewCellH class] forCellWithReuseIdentifier:reuseIdentifier];
    UINib *nib = [UINib nibWithNibName:@"CQCollectionViewCellH" bundle:nil];
    [colView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CQCollectionViewCellH *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *string = self.images[indexPath.item];
    cell.icon = string;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 删除模型数据
    [self.images removeObjectAtIndex:indexPath.item];
    
    // 2. 删除UI元素
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - 点击屏幕空白处，切换布局模式
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([self.colView.collectionViewLayout isKindOfClass:[CQCellHFlowLayout class]]) {
//        [self.colView setCollectionViewLayout:[[CQCellHFlowLayout alloc] init] animated:YES];
//    }
//    else{
//        [self.colView setCollectionViewLayout:[[CQCellHFlowLayout alloc] init] animated:YES];
//    }
//
//}

#pragma mark <UICollectionViewDelegate>



/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
-(NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        for (int i=1;i<=14;i++) {
            [_images addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _images;
}
@end
