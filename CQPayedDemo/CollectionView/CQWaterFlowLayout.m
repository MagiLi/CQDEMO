//
//  CQWaterFlowLayout.m
//  CQPayedDemo
//
//  Created by Mac on 2019/1/14.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQWaterFlowLayout.h"

@implementation CQWaterFlowLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        layoutInit(self);
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        layoutInit(self);
    }
    return self;
}
-(void)refresh {
    [self.layoutAttributes removeAllObjects];
    _rectForItemsContainerSize = 4096;
    _rectsForItems = (CGRect *)malloc(sizeof(CGRect) * 4096);
    _numberOfItems = 0;
    _contentHeight = 0;
    _columnHeightSize = 256;
    _perColumnHeights = (CGFloat *)malloc(sizeof(CGFloat) * 256);
//    for (int i = 0; i != _columnNumber; i++) {
//        _perColumnHeights[i] = 0;
//    }
    [self reloadData];
}
/// inline: 内敛函数
/*
优点相比于函数:
inline函数避免了普通函数的,在汇编时必须调用call的缺点:取消了函数的参数压栈，减少了调用的开销,提高效率.所以执行速度确比一般函数的执行速度要快.
2)集成了宏的优点,使用时直接用代码替换(像宏一样);
 
优点相比于宏:
1)避免了宏的缺点:需要预编译.因为inline内联函数也是函数,不需要预编译.
2)编译器在调用一个内联函数时，会首先检查它的参数的类型，保证调用正确。然后进行一系列的相关检查，就像对待任何一个真正的函数一样。这样就消除了它的隐患和局限性。
3)可以使用所在类的保护成员及私有成员。
 
 inline内联函数的说明
 1.内联函数只是我们向编译器提供的申请,编译器不一定采取inline形式调用函数.
 2.内联函数不能承载大量的代码.如果内联函数的函数体过大,编译器会自动放弃内联.
 3.内联函数内不允许使用循环语句或开关语句.
 4.内联函数的定义须在调用之前.
*/
inline void layoutInit(CQWaterFlowLayout *layout) {
    layout->_rectForItemsContainerSize = 4096;
    //malloc()动态分配内存,用malloc分配内存的首地址
    layout->_rectsForItems = (CGRect *)malloc(sizeof(CGRect) * 4096);
    layout->_heightWidthRatio = 1.0;
    layout->_columnHeightSize = 256;
    layout->_perColumnHeights = (CGFloat *)malloc(sizeof(CGFloat) * 256);
    layout->_contentHeight = 0.0;
    layout.sectionInset = UIEdgeInsetsZero;
}
//
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    layoutInit(self);
//}

-(void)setColumnNumber:(NSInteger)columnNumber {
    if (_columnHeightSize < columnNumber) {
        if (_perColumnHeights) {
            free(_perColumnHeights);
        }
        _columnHeightSize = columnNumber / 256 + 1;
        _perColumnHeights = (CGFloat *)malloc(sizeof(CGFloat) * _columnHeightSize);
    }
    _columnNumber = columnNumber;
}
//设置新的单元格数量，会将老的单元格对应的布局信息填写到新的空间中..未超过，则不复制。。
-(void)setNumberOfItems:(NSInteger)numberOfItems {
    if (numberOfItems > _rectForItemsContainerSize) {
        BOOL needExtend = NO;
        if (_rectsForItems) {
            needExtend = YES;
        }
        CGRect *newRectsSpace = (CGRect *)malloc(sizeof(CGRect) * (numberOfItems + _rectForItemsContainerSize));
        memcpy(newRectsSpace, _rectsForItems, _numberOfItems * sizeof(CGRect));
        free(_rectsForItems);
        _rectsForItems = newRectsSpace;
        _rectForItemsContainerSize += numberOfItems;
    }
    _numberOfItems = numberOfItems;
}

-(NSMutableArray *)layoutAttributes
{
    if (_layoutAttributes == nil) {
        _layoutAttributes = [NSMutableArray new];
    }
    return _layoutAttributes;
}

-(void)prepareLayout
{
    if (self.layoutAttributes.count == 0 && _numberOfItems) {
        printf("\n prepareLayout %f",self.collectionView.frame.size.width);
        [self calculateLayoutFromIndex:0];
    }
}

/*此方法在当前线程计算布局*/
-(NSMutableArray *)calculateLayoutFromIndex:(NSInteger)startIndex
{
    printf("\n开始计算布局 %f",CFAbsoluteTimeGetCurrent());
    if (startIndex == 0) {
        for (int i = 0; i != _columnNumber; i++) {
            _perColumnHeights[i] = self.sectionInset.top;
            printf("\n startIndex == 0 i %d %f",i,_perColumnHeights[i]);
        }
        [_layoutAttributes removeAllObjects];
    }
    _collectionViewWidth = self.collectionView.frame.size.width;
    NSMutableArray *array = nil;
    _contentHeight = 0.0;
    if (startIndex < _numberOfItems && _columnNumber > 0) {
        CGFloat width = (_collectionViewWidth - self.sectionInset.left - self.sectionInset.right - _horizontalMargin * (_columnNumber - 1)) / _columnNumber;
        CGFloat height = 0.0;
        for (NSInteger i = startIndex;  i!= _numberOfItems; i++) {
            if ([_delegate respondsToSelector:@selector(heightWidthRatioForItemAtIndex:)]) {
                height = width * [_delegate heightWidthRatioForItemAtIndex:i];
            }
            else{
                height = width * _heightWidthRatio;
            }
            //计算当前cell的布局位置。
            NSInteger currentColumn = 0;
            CGFloat currentTop = _perColumnHeights[0];
            //获取当前最小高度
            for (int a = 0; a != _columnNumber; a++) {
                if (currentTop > _perColumnHeights[a]) {
                    currentTop = _perColumnHeights[a];
                    currentColumn = a;
                }
            }
            _rectsForItems[i] = CGRectMake(self.sectionInset.left + (_horizontalMargin + width) * currentColumn , currentTop,width,height);
            //刷新当前列的高度
            _perColumnHeights[currentColumn] = currentTop + height  + _verticalMargin;
            printf("\n i %ld %f",(long)i,_perColumnHeights[currentColumn]);
        }
        for (int i = 0; i != _columnNumber; i++) {
            if (_perColumnHeights[i] > _contentHeight) {
                _contentHeight = _perColumnHeights[i];
            }
            printf("\n i %d %f",i,_perColumnHeights[i]);
        }
        printf("\n _contentHeight %f",_contentHeight);
        //将对应的布局信息填写到 UICollectionViewLayoutAttributes 对象当中。
        array = [NSMutableArray arrayWithArray:self.layoutAttributes];
        for (NSInteger i = startIndex; i != _numberOfItems; i++) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            attributes.frame = _rectsForItems[i];
            [array insertObject:attributes atIndex:i];
        }
    }
    printf("\n结束计算布局 %f",CFAbsoluteTimeGetCurrent());
    return array;
}

-(void)dealloc {
    if (_rectsForItems) {
        free(_rectsForItems);
    }
    if (_perColumnHeights) {
        free(_perColumnHeights);
    }
}

/*此方法在子线程计算布局*/
-(void)calculateLayoutFromIndex:(NSInteger)index reloadAfterCalculated:(BOOL)needReload {
    _collectionViewWidth = self.collectionView.frame.size.width;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (needReload) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *array = [self calculateLayoutFromIndex:index];
                self.layoutAttributes = array;
                [self reloadData];
            });
        }
    });
}

-(void)calculateLayoutFromIndex:(NSInteger)index calculateFinishedBlock:(void (^)(CQWaterFlowLayout *layout))block{
    _collectionViewWidth = self.collectionView.frame.size.width;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *array = [self calculateLayoutFromIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layoutAttributes = array;
            if (block) {
                block(self);
            }
        });
    });
}
#pragma mark - CollectionView的滚动范围
-(CGSize)collectionViewContentSize {
    CGSize size = CGSizeMake(self.collectionView.frame.size.width, MAX(_contentHeight + self.sectionInset.top + self.sectionInset.bottom, self.collectionView.frame.size.height));
    return size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _layoutAttributes[indexPath.row];
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)Rect {
    //过滤出处于rect当中的attributes
    return _layoutAttributes;
}


-(void)addItemsAtIndex:(NSInteger)insertIndex addedItemsCount:(NSInteger)addedItemsCount{
    BOOL addedAtEnd = (insertIndex >= self.numberOfItems);
    NSInteger oldMaxIndex = self.numberOfItems;
    self.numberOfItems += addedItemsCount;
    if (addedItemsCount) {
        [self calculateLayoutFromIndex:addedAtEnd ? oldMaxIndex : 0  reloadAfterCalculated:YES];
    }
}

-(void)reloadData
{
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //    [self.collectionView relo]
}

@end
