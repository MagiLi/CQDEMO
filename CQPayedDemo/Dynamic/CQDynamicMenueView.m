//
//  CQDynamicMenueView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/14.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQDynamicMenueView.h"

//static const CGFloat kAngleOffset = M_PI_2 / 2;
static const CGFloat kSphereLength = 80.0;
static const float kSphereDamping = 0.3;

@interface CQDynamicMenueView ()<UICollisionBehaviorDelegate>

@property(nonatomic,strong)NSArray *images;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *positions;
@property (strong, nonatomic) NSMutableArray *snaps;
@property (strong, nonatomic) NSMutableArray *taps;

@property (strong, nonatomic) UIDynamicAnimator *animator; // 物理仿真器
@property (strong, nonatomic) UICollisionBehavior *collision; // 碰撞行为
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior; // 动力元素行为

@property (strong, nonatomic) id<UIDynamicItem> bumper;
@property (assign, nonatomic) BOOL expanded;
@end

@implementation CQDynamicMenueView

#pragma mark -
#pragma mark - menueButtonClicked
- (void)menueButtonClicked {
    [self.animator removeBehavior:self.collision];
    [self.animator removeBehavior:self.itemBehavior];
    [self removeSnapBehaviors];
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
    
    self.expanded = !self.expanded;
}
- (void)expandSubmenu
{
    for (int i = 0; i < self.images.count; i++) {
        [self snapToPostionsWithIndex:i];
    }
}

- (void)shrinkSubmenu
{
    for (int i = 0; i < self.images.count; i++) {
        [self snapToStartWithIndex:i];
    }
}
- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.center];
    snap.damping = kSphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}
// 抓捕当前item的原始位置
- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = kSphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

#pragma mark -
#pragma mark - collisionDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    [self.animator addBehavior:self.itemBehavior];
    
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

#pragma mark -
#pragma mark - 计算每个item展开时的位置
- (CGPoint)centerForSphereAtIndex:(int)index
{
    CGFloat firstAngle = M_PI + M_PI / (self.images.count + 1) * (index + 1);
//    CGFloat firstAngle = M_PI + (M_PI_2 - kAngleOffset) + index * kAngleOffset;
    CGPoint startPoint = self.center;
    CGFloat radius = kSphereLength * self.images.count / 3.0;
    CGFloat x = startPoint.x + cos(firstAngle) * radius;
    CGFloat y = startPoint.y + sin(firstAngle) * radius;
    CGPoint position = CGPointMake(x, y);
    return position;
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    UIView *touchedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.itemBehavior];
        [self.animator removeBehavior:self.collision];
        [self removeSnapBehaviors];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchedView.center = [gesture locationInView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.bumper = touchedView;
        [self.animator addBehavior:self.collision];
        NSUInteger index = [self.items indexOfObject:touchedView];
        
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}
- (void)tapped:(UITapGestureRecognizer *)gesture
{
    NSUInteger index = [self.taps indexOfObject:gesture];
    self.expanded = NO;
    [self shrinkSubmenu];
}
- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images {
    self = [super init];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        self.center = startPoint;
        
        UIButton *menueBtn = [[UIButton alloc] init];
        [menueBtn setImage:startImage forState:UIControlStateNormal];
        menueBtn.frame = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        [menueBtn addTarget:self action:@selector(menueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menueBtn];
        
        self.images = images;
    }
    return self;
}
- (void)didMoveToSuperview {
    [self setupUI];
}

- (void)setupUI {

    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    self.snaps = [NSMutableArray array];
    self.taps = [NSMutableArray array];
    // setup the items
    for (int i = 0; i < self.images.count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithImage:self.images[i]];
        item.layer.cornerRadius = self.bounds.size.width * 0.51;
        item.backgroundColor = [UIColor orangeColor];
        item.userInteractionEnabled = YES;
        item.center = self.center;
        [self.superview addSubview:item];
        
        CGPoint position = [self centerForSphereAtIndex:i];
        
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:tap];
        [self.taps addObject:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [item addGestureRecognizer:pan];
        
        [self.items addObject:item];
        
        // 捕捉行为
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.center];
        snap.damping = kSphereDamping;
        [self.snaps addObject:snap];
    }
    
    [self.superview bringSubviewToFront:self];
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = NO;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.5;
}

- (void)removeFromSuperview
{
    for (int i = 0; i < self.images.count; i++) {
        [self.items[i] removeFromSuperview];
    }
    
    [super removeFromSuperview];
}
- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}
@end
