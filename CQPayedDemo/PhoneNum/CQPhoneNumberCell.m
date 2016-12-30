//
//  CQPhoneNumberCell.m
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPhoneNumberCell.h"
#import "CQPhoneNumModel.h"


static CGFloat effectiveMinX = 50.0;

@interface CQPhoneNumberCell ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *bgName;
@property (weak, nonatomic) IBOutlet UILabel *bgPhone;
@property(nonatomic,strong)CQPhoneNumModel *model;
@property(nonatomic,assign)BOOL moved;


@end

@implementation CQPhoneNumberCell

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        // fabs(translation.x) > fabs(translation.y) 确定是左右滑动 不是上下滑动
        if (fabs(translation.x) > fabs(translation.y)) {
            if ([self.delegate respondsToSelector:@selector(cellWillBeginPanGesture)]) {
                [self.delegate cellWillBeginPanGesture];
            }
            // translation.x < 0 确定是左滑
            if (translation.x < 0) {
                return YES;
            }
            return self.moved;
        }
        return NO;
    }
    return YES;
}

- (void)foregroundViewPaned:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture translationInView:self.contentView];
    CGPoint locationPoint = [panGesture locationInView:self.contentView];
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (self.moved) { // 处于侧滑状态
            CGFloat x = locationPoint.x - kScreen_W + 50.0;
            if (x < 1) {
                self.foregroundView.x = x;
            } else {
                self.foregroundView.x = 0;
            }
        } else {
            if (point.x < 1) {
                self.foregroundView.x = point.x;
            } else {
                self.foregroundView.x = 0;
            }
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self foregroundViewMovedWithX:point.x];
    } else if (panGesture.state == UIGestureRecognizerStateCancelled) {
        [self foregroundViewMovedWithX:point.x];
    }
}

// 移动
- (void)foregroundViewMovedWithX:(CGFloat)x {
    if (self.moved) { // 处于侧滑状态
        if (x < effectiveMinX) {
            [self foregroundViewMovedLeft];
        } else {
            [self foregroundViewMovedNormal];
        }
    } else {
        if (-x > effectiveMinX) {
            [self foregroundViewMovedLeft];
        } else {
            [self foregroundViewMovedNormal];
        }
    }
}

- (void)foregroundViewMovedLeft {
    [UIView animateWithDuration:0.1 animations:^{
        self.foregroundView.x = -kScreen_W;
    }];
    self.moved = YES;
    if ([self.delegate respondsToSelector:@selector(cellEndPanGesture:)]) {
        [self.delegate cellEndPanGesture:YES];
    }
}
- (void)foregroundViewMovedNormal {
    [UIView animateWithDuration:0.1 animations:^{
        self.foregroundView.x = 0;
    }];
    self.moved = NO;
    if ([self.delegate respondsToSelector:@selector(cellEndPanGesture:)]) {
        [self.delegate cellEndPanGesture:NO];
    }
}
+ (CQPhoneNumberCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)array {
    CQPhoneNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phoneNumCell" forIndexPath:indexPath];
    cell.model = array[indexPath.section][indexPath.row];
    return cell;
}

- (void)setModel:(CQPhoneNumModel *)model {
    _model = model;
    if (model.head) {
        self.iconView.image = [UIImage imageWithData:model.head];
    } else {
        self.iconView.image = [UIImage imageNamed:@"UMS_qzone_icon"];
    }
    self.nameLab.text = model.name;
    self.bgName.text = model.name;
    
    NSArray *arrayMobile = [model.mobile componentsSeparatedByString:ARRAY_CLIP];
    model.mobile = [arrayMobile objectAtIndex:0];
    NSArray *arrayPhone = [model.mobile componentsSeparatedByString:SUB_ARRAY_CLIP];
    if (arrayPhone.count > 1) {
        model.mobile = [arrayPhone objectAtIndex:1];
    }
    self.phoneLab.text = model.mobile;
    self.bgPhone.text = model.mobile;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(foregroundViewPaned:)];
    panGesture.delegate = self;
//    panGesture.delaysTouchesBegan = YES; // 防止视图处理触摸或按下多余的手势
    [self addGestureRecognizer:panGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
