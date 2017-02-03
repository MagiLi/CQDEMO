//
//  CQCollectionViewAnimation.m
//  CQCollectionView
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCollectionViewAnimation.h"
#import "CQCycleLayout.h"
#import "CQStackLayout.h"
#import "CQCollectionViewCell.h"

@interface CQCollectionViewAnimation ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,weak)UICollectionView *colView;
@property (nonatomic,strong) NSMutableArray *images;
@end

static NSString * const reuseIdentifier = @"CellAnim";

@implementation CQCollectionViewAnimation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CQCycleLayout *layout = [[CQCycleLayout alloc] init];
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400) collectionViewLayout:layout];
    colView.delegate = self;
    colView.dataSource = self;
    colView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:colView];
    self.colView = colView;
    //    [colView registerClass:[CQCollectionViewCellH class] forCellWithReuseIdentifier:reuseIdentifier];
    UINib *nib = [UINib nibWithNibName:@"CQCollectionViewCell" bundle:nil];
    [colView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.colView.collectionViewLayout isKindOfClass:[CQStackLayout class]]) {
        [self.colView setCollectionViewLayout:[[CQCycleLayout alloc] init] animated:YES];
    }
    else{
        [self.colView setCollectionViewLayout:[[CQStackLayout alloc] init] animated:YES];
        [self.colView reloadData];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
