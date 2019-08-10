//
//  CQDisplayView.m
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQDisplayView.h"
#import "CQCoreTextImageData.h"
#import "CQCoreTextUtils.h"
#import "CQMagnifierView.h"
#import "UIImage+CQExtra.h"

NSString *const CQDisplayViewImagePressedNotification = @"CQDisplayViewImagePressedNotification";
NSString *const CQDisplayViewLinkPressedNotification = @"CQDisplayViewLinkPressedNotification";

@interface CQDisplayView ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)CQMagnifierView *magnifierView;

@end

@implementation CQDisplayView
{
    NSRange _selectedRange;
    NSArray *_pathArray; // 长按时赋值，进行绘制。tap时置为nil取消绘制
    
    CGRect _leftRect;
    CGRect _rightRect;
    
    //是否进入选择状态
    BOOL _selectState;
    BOOL _direction; //滑动方向  (0---左侧滑动 1 ---右侧滑动)
    
    UIPanGestureRecognizer *_panGesture;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupEvents];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupEvents];
    }
    return self;
}
#pragma mark -
#pragma mark - UIGestureRecognizer
- (void)setupEvents {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvents:)];
    [self addGestureRecognizer:pan];
    pan.enabled = NO;
    _panGesture = pan;
}

#pragma mark -
#pragma mark - tap事件
- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    if (_pathArray.count) { // 取消编辑状态
        _pathArray = nil;
        [self setNeedsDisplay];
    }
    
    CGPoint point = [recognizer locationInView:self];
    for (CQCoreTextImageData *imageData in self.data.imageArray) {
        // 翻转坐标系,因为imageData中得坐标是CoreText的坐标系(coretext: y值朝上  UIKit: y值朝下)
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        imageData.frame = rect;
        // 检测点击位置
        if (CGRectContainsPoint(rect, point)) {
            // 图片被点击了
            NSDictionary *userInfo = @{@"imageData" : imageData};
            [[NSNotificationCenter defaultCenter] postNotificationName:CQDisplayViewImagePressedNotification
                                                                object:self
                                                              userInfo:userInfo];
            
            return;
        }
    }
    
    CQCoreTextLinkData *linkData = [CQCoreTextUtils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSDictionary *userInfo = @{@"linkData": linkData };
        [[NSNotificationCenter defaultCenter] postNotificationName:CQDisplayViewLinkPressedNotification
                                                            object:self
                                                          userInfo:userInfo];
        return;  
    }  
}
#pragma mark -
#pragma mark - longPress事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress
{
    CGPoint touchPoint = [longPress locationInView:self];
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        [self showMagnifierViewWithPoint:(CGPoint)touchPoint];
        
        CGRect rect = [CQCoreTextUtils praserRectInView:self atPoint:touchPoint selectedRange:&_selectedRange data:_data];
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            _pathArray = @[NSStringFromCGRect(rect)];
            
            [self setNeedsDisplay];
        }
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
        [self hidenMagnifierView];
    }
}

#pragma mark -
#pragma mark - pan事件
- (void)panEvents:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self showMagnifierViewWithPoint:point];
        if (CGRectContainsPoint(_rightRect, point)||CGRectContainsPoint(_leftRect, point)) {
            if (CGRectContainsPoint(_leftRect, point)) {
                _direction = NO;   //从左侧滑动
            }
            else{
                _direction=  YES;    //从右侧滑动
            }
            _selectState = YES;
        }
        if (_selectState) {
            NSArray *path = [CQCoreTextUtils parserRectsInView:self atPoint:point range:&_selectedRange data:_data paths:_pathArray direction:_direction];
            _pathArray = path;
            [self setNeedsDisplay];
        }
        
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self hidenMagnifierView];
        _selectState = NO;
    }
}

#pragma mark - Privite Method
#pragma mark  Draw Selected Path
-(void)drawSelectedPath:(NSArray *)array LeftDot:(CGRect *)leftDot RightDot:(CGRect *)rightDot{
    if (!array.count) {
        _panGesture.enabled = NO;
//        if ([self.delegate respondsToSelector:@selector(readViewEndEdit:)]) {
//            [self.delegate readViewEndEdit:nil];
//        }
        return;
    }
//    if ([self.delegate respondsToSelector:@selector(readViewEditeding:)]) {
//        [self.delegate readViewEditeding:nil];
//    }
    _panGesture.enabled = YES;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef _path = CGPathCreateMutable();
    
    for (int i = 0; i < [array count]; i++) {
        CGRect rectTemp = CGRectFromString([array objectAtIndex:i]);
        CGRect rect = CGRectMake(rectTemp.origin.x, rectTemp.origin.y, rectTemp.size.width, rectTemp.size.height);
        CGPathAddRect(_path, NULL, rect);
        
        
        if (i == 0) {
            *leftDot = rect;
        }
        if (i == [array count]-1) {
            *rightDot = rect;
        }
        CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(ctx, rect.size.width + rect.origin.x, rect.origin.y);
        [[UIColor purpleColor] set];
        CGContextStrokePath(ctx);
    }
    
    CGContextAddPath(ctx, _path);
    [[UIColor lightGrayColor] setFill];
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    
}
-(void)drawDotWithLeft:(CGRect)Left right:(CGRect)right
{
    if (CGRectEqualToRect(CGRectZero, Left) || (CGRectEqualToRect(CGRectZero, right))) return;
 
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor blueColor] setFill];
    CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMinX(Left)-2, CGRectGetMinY(Left),2, CGRectGetHeight(Left)));
    CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMaxX(right), CGRectGetMinY(right),2, CGRectGetHeight(right)));
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    CGFloat dotSize = 15;
    _leftRect = CGRectMake(CGRectGetMinX(Left)-dotSize/2-10, self.frame.size.height-(CGRectGetMaxY(Left)-dotSize/2-10)-(dotSize+20), dotSize+20, dotSize+20);
    _rightRect = CGRectMake(CGRectGetMaxX(right)-dotSize/2-10,self.frame.size.height- (CGRectGetMinY(right)-dotSize/2-10)-(dotSize+20), dotSize+20, dotSize+20);
    
    //    CGImageRef img = [UIImage imageNamed:@"r_drag-dot"].CGImage;
    CGImageRef img = [[UIImage alloc] creatRadiusImage:CGSizeMake(dotSize, dotSize) strokeColor:[UIColor whiteColor] fillColor:[UIColor blueColor]].CGImage;
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMinX(Left)-dotSize/2 - 1, CGRectGetMaxY(Left)-dotSize/2 + 5, dotSize, dotSize),img);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMaxX(right)-dotSize/2 + 1, CGRectGetMinY(right)-dotSize/2 - 6, dotSize, dotSize),img);
}


#pragma mark -
#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CGRect leftDot = CGRectZero,rightDot = CGRectZero;
        [self drawSelectedPath:_pathArray LeftDot:&leftDot RightDot:&rightDot];
        CTFrameDraw(self.data.ctFrame, context);
        [self drawDotWithLeft:leftDot right:rightDot];
    }
    
    // 绘制出图片
    for (CQCoreTextImageData *imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
        
    }
}


- (void)showMagnifierViewWithPoint:(CGPoint)touchPoint
{
    if (!_magnifierView) {
        _magnifierView = [[CQMagnifierView alloc] init];
        _magnifierView.displayView = self;
//        [[UIApplication sharedApplication].keyWindow addSubview:_magnifierView];
        [self addSubview:_magnifierView];
    }

//    UIScrollView *scrollView = (UIScrollView *)self.superview;
//    CGPoint point = CGPointMake(touchPoint.x, touchPoint.y - scrollView.contentOffset.y - 64.0);
    self.magnifierView.touchPoint = touchPoint;
}

- (void)hidenMagnifierView
{
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}

@end
