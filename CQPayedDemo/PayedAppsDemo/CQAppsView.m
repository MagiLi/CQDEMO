//
//  CQAppsView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAppsView.h"
#import "CQAppsCell.h"
#import "CQAppsDataManager.h"

@interface CQAppsView ()<CQAppsCellDelegate>

@property(nonatomic,weak)UILongPressGestureRecognizer *longPressGesture;
@property(nonatomic,strong)NSIndexPath *touchIndexPath;
@property(nonatomic,strong)NSIndexPath *moveIndexPath;

@property(nonatomic,assign)CGPoint lastPoint;
@property(nonatomic,weak)UIView *snapshotView;
@property(nonatomic,weak)UICollectionViewCell *pressedCell;

@end

@implementation CQAppsView

- (void)stateButtonClickedEvents:(CQAppsCell *)cell {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    NSMutableArray *sourceArray;
    if ([self.viewDataSource respondsToSelector:@selector(dataSourceArrayOfCollectionView:)]) {
        sourceArray = [NSMutableArray arrayWithArray:[self.viewDataSource dataSourceArrayOfCollectionView:self]];
    }
    
    if (indexPath.section == 0) {
        [sourceArray[0] removeObjectAtIndex:indexPath.item];
        if ([self.viewDelegate respondsToSelector:@selector(dragCellCollectionView:newDataArrayAfterMoving:)]) {
            [self.viewDelegate dragCellCollectionView:self newDataArrayAfterMoving:sourceArray];
            [self deleteItemsAtIndexPaths:@[indexPath]];
        }
        [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            [cell removeFromSuperview];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];

    } else {
        cell.model.buttonState = ServeButtonSelected;
        [sourceArray[0] addObject:cell.model];

        NSArray *indexPathArray = [self findAllLastIndexPathInVisibleSection];
        NSIndexPath *headLastIndexPath = nil;
        for (NSIndexPath *indexPath in indexPathArray) {
            if (indexPath.section == 0) {
                headLastIndexPath = indexPath;
            }
        }

        NSInteger num = [sourceArray[0] count] - 1;
        //假定每行显示4个cell
        NSInteger rowNumber = num %4;
        UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
        tempMoveCell.center = cell.center;
        [self addSubview:tempMoveCell];
        // 获取第一组的最后一个cell
        UICollectionViewCell *lastCell;
        if (headLastIndexPath) {
            lastCell = [self cellForItemAtIndexPath:headLastIndexPath];
        }
        float width = self.frame.size.width / 4;
        // 计算将要添加上的cell的位置
        CGPoint center = CGPointMake(width * rowNumber + width/2, CGRectGetMaxY(lastCell.frame));
        
        
        [UIView animateWithDuration:0.2 animations:^{
            tempMoveCell.center = center;
            tempMoveCell.transform = CGAffineTransformMakeScale(0.3, 0.3);
            tempMoveCell.alpha = 0;
        } completion:^(BOOL finished) {
            [tempMoveCell removeFromSuperview];
            [self reloadData];
        }];
    }
}

#pragma mark -
#pragma mark - 找出所有可视分组中最后一个item的位置
- (NSArray *)findAllLastIndexPathInVisibleSection {
    
    NSArray *array = [self indexPathsForVisibleItems];
    // 按照组的大小排序
    array = [array sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.section > obj2.section;
    }];
    
    NSMutableArray *totalArray = [NSMutableArray arrayWithCapacity:0];// 记录最终的数据
    NSInteger tempSection = -1;
    NSMutableArray *tempArray = nil; // 遍历时记录当前组的数据
    for (NSIndexPath *indexPath in array) {
        if (tempSection != indexPath.section) { // 确保每组只进来一次
            tempSection = indexPath.section;
            if (tempArray) {
                // 对上一组的数据 按照item的大小 进行排序
                NSArray *temp = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
                    return obj1.item > obj2.item;
                }];
                // 取出上一组的最后一条数据 也就是最大的数据
                [totalArray addObject:temp.lastObject];
            }
            tempArray = [NSMutableArray arrayWithCapacity:0]; // 清空上一组的数据 （第一次进来时起到初始化的效果）
        }
        [tempArray addObject:indexPath];
    }
    // 对最后一组的数据进行排序
    NSArray *temp = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.item > obj2.item;
    }];
    if (temp.lastObject) {
        [totalArray addObject:temp.lastObject];
    }
    return totalArray.copy;
}

#pragma mark -
#pragma mark - 更新数据源
- (void)updateDataSource {
    NSMutableArray *arrayM = [NSMutableArray array];
    if ([self.viewDataSource respondsToSelector:@selector(dataSourceArrayOfCollectionView:)]) {
        [arrayM addObjectsFromArray:[self.viewDataSource dataSourceArrayOfCollectionView:self]];
    }
    //判断数据源是单个数组还是数组套数组的多section形式，YES表示数组套数组
    BOOL dataTypeCheck = ([self numberOfSections] != 1 || ([self numberOfSections] == 1 && [arrayM[0] isKindOfClass:[NSArray class]]));
    if (dataTypeCheck) {
        for (int i = 0; i < arrayM.count; i ++) {
            [arrayM replaceObjectAtIndex:i withObject:[arrayM[i] mutableCopy]];
        }
    }
    if (_moveIndexPath.section == _touchIndexPath.section) {
        NSMutableArray *orignalSection = dataTypeCheck ? arrayM[_touchIndexPath.section] : arrayM;
        if (_moveIndexPath.item > _touchIndexPath.item) {
            for (NSUInteger i = _touchIndexPath.item; i < _moveIndexPath.item ; i ++) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }else{
            for (NSUInteger i = _touchIndexPath.item; i > _moveIndexPath.item ; i --) {
                [orignalSection exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        }
        
    }else{
        NSMutableArray *orignalSection = arrayM[_touchIndexPath.section];
        NSMutableArray *currentSection = arrayM[_moveIndexPath.section];
        [currentSection insertObject:orignalSection[_touchIndexPath.item] atIndex:_moveIndexPath.item];
        [orignalSection removeObject:orignalSection[_touchIndexPath.item]];
    }

    if ([self.viewDelegate respondsToSelector:@selector(dragCellCollectionView:newDataArrayAfterMoving:)]) {
        [self.viewDelegate dragCellCollectionView:self newDataArrayAfterMoving:arrayM.copy];
    }
}

- (void)setBeginEditing:(BOOL)beginEditing {
    if (_beginEditing == beginEditing) return;
    _beginEditing = beginEditing;
    // 通知cell改变状态
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_CellStateChange object:@(beginEditing)];
}

- (void)longPressBegin {
    if (!self.beginEditing) {
        self.beginEditing = YES;
    }
    
    _lastPoint = [_longPressGesture locationInView:self];
    _touchIndexPath = [self indexPathForItemAtPoint:_lastPoint];
    if (_touchIndexPath.section == 0 && _touchIndexPath) {
        UICollectionViewCell *pressedCell = [self cellForItemAtIndexPath:_touchIndexPath];
        self.pressedCell = pressedCell;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *snapshotView = [pressedCell snapshotViewAfterScreenUpdates:NO];
            snapshotView.frame = pressedCell.frame;
            [self addSubview:snapshotView];
            snapshotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            pressedCell.hidden = YES;
            _snapshotView = snapshotView;
        });
    }
    if ([self.viewDelegate respondsToSelector:@selector(dragCellCollectionView:cellWillBeginMoveAtIndexPath:)]) {
        [self.viewDelegate dragCellCollectionView:self cellWillBeginMoveAtIndexPath:_touchIndexPath];
    }

}
- (void)longPressChanged {
    if ([self.viewDelegate respondsToSelector:@selector(dragCellMovingWithCollectionView:)]) {
        [self.viewDelegate dragCellMovingWithCollectionView:self];
    }
    CGPoint currentPoint = [_longPressGesture locationInView:self];
    CGFloat translateX = currentPoint.x - _lastPoint.x;
    CGFloat translateY = currentPoint.y - _lastPoint.y;
    _snapshotView.center = CGPointApplyAffineTransform(_snapshotView.center, CGAffineTransformMakeTranslation(translateX, translateY));
    _lastPoint = [_longPressGesture locationInView:self];
    
    for (UICollectionViewCell *cell in [self visibleCells]) {
        if ([self indexPathForCell:cell] == _touchIndexPath) continue;
        //计算中心距
        CGFloat spacingX = fabs(_snapshotView.center.x - cell.center.x);
        CGFloat spacingY = fabs(_snapshotView.center.y - cell.center.y);
        if (spacingX <= _snapshotView.bounds.size.width / 2.0f && spacingY <= _snapshotView.bounds.size.height / 2.0f) {
            _moveIndexPath = [self indexPathForCell:cell];
            if (_moveIndexPath.section != 0)return;
            //更新数据源
            [self updateDataSource];
            //移动
            [self moveItemAtIndexPath:_touchIndexPath toIndexPath:_moveIndexPath];
            //通知代理
            if ([self.delegate respondsToSelector:@selector(dragCellCollectionView:moveCellFromIndexPath:toIndexPath:)]) {
                [self.viewDelegate dragCellCollectionView:self moveCellFromIndexPath:_touchIndexPath toIndexPath:_moveIndexPath];
            }
            //设置移动后的起始indexPath
            _touchIndexPath = _moveIndexPath;
        }
    }

}

- (void)longPressedEndedOrCancelled {
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:[_longPressGesture locationInView:self]];
    if ([self.viewDelegate respondsToSelector:@selector(dragCellCollectionView:cellEndMoveAtIndexPath:)]) {
        [self.viewDelegate dragCellCollectionView:self cellEndMoveAtIndexPath:indexPath];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _snapshotView.center = self.pressedCell.center;
    } completion:^(BOOL finished) {
        self.pressedCell.hidden = NO;
        [self.snapshotView removeFromSuperview];
//        self.userInteractionEnabled = YES;
    }];
}

- (void)longPressed:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {

        [self longPressBegin];

    }
    if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        if (_touchIndexPath.section != 0) return;
        [self longPressChanged];
    }
    if (longPressGesture.state == UIGestureRecognizerStateCancelled ||
        longPressGesture.state == UIGestureRecognizerStateEnded){
        [self longPressedEndedOrCancelled];
    }
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addLongPressedGesture];
    }
    return self;
}
- (void)addLongPressedGesture{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self addGestureRecognizer:longPress];
    _longPressGesture = longPress;
}
@end
