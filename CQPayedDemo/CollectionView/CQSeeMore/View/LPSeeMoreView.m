//
//  LPSeeMoreView.m
//  LPYProjrect
//
//  Created by Mac on 2019/2/27.
//  Copyright © 2019 LvPai Culture. All rights reserved.
//

#import "LPSeeMoreView.h"

@interface LPSeeMoreView ()
@property (nonatomic, weak) UILabel *titleLab;
@end

@implementation LPSeeMoreView

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
}
- (void)setMinWidth:(CGFloat)minWidth {
    _minWidth = minWidth;

}
- (void)setMaxWidth:(CGFloat)maxWidth {
    _maxWidth = maxWidth;

}
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(self.mj_w - SeeMoreLabel_Right, 0, 20.0, self.mj_h);
}
#pragma mark - setupUI
- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont boldSystemFontOfSize:UITitle2Font];
    titleLab.textColor = UITitle3Color;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.text = @"查看更多";
    titleLab.numberOfLines = 0;
    [self addSubview:titleLab];
    self.titleLab = titleLab;
}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    CGFloat x = viewWidth - self.minWidth;
    CGFloat h = x > MarginTop*2.0 ? viewHeight - MarginTop*2.0 : viewHeight - x;
    CGFloat y = (viewHeight - h) * 0.5;
    NSLog(@"height: %f y: %f",h, y);
    [UIThemeGrayColor set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path moveToPoint:CGPointMake(x, y)];
    [path addLineToPoint:CGPointMake(x, h + y)];
    [path addLineToPoint:CGPointMake(viewWidth, h + y)];
    [path addLineToPoint:CGPointMake(viewWidth, y)];
    path.lineCapStyle = kCGLineCapRound;//线条拐角
    path.lineJoinStyle = kCGLineJoinRound;//终点处理
    [path fill];
    
    
    // d = viewWidth - self.minWidth
    // 直角三角形 (利用此公式求出半径r)
    // (r - d)*(r - d) + (h/2)(h/2) = r * r
    CGFloat centerY = viewHeight*0.5;
    CGFloat d = x;
    CGFloat radius = d*0.5 + (h*h)/(d*8.0);
    CGFloat centerX = radius;
    CGFloat startAngle = M_PI - asinf(h*0.5/radius);
    CGFloat endAngle = M_PI + asinf(h*0.5/radius);
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path fill];
//    UIBezierPath *pathArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//    [pathArc fill];
    
//    CGFloat width = rect.size.width;
//    CGFloat height = rect.size.height;
//    CGFloat x = width - self.minWidth;
//    [UIThemeGrayColor set];
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth = 1;
//    [path moveToPoint:CGPointMake(x, 0)];
//    [path addLineToPoint:CGPointMake(x, height)];
//    [path addLineToPoint:CGPointMake(width, height)];
//    [path addLineToPoint:CGPointMake(width, 0)];
//    path.lineCapStyle = kCGLineCapRound;//线条拐角
//    path.lineJoinStyle = kCGLineJoinRound;//终点处理
//    [path fill];
//
//    // d = width - self.minWidth
//    // 直角三角形 (利用此公式求出半径r)
//    // (r - d)*(r - d) + (h/2)(h/2) = r * r
//    CGFloat centerY = height*0.5;
//    CGFloat d = x;
//    CGFloat radius = d*0.5 + (height*height)/(d*8.0);
//    CGFloat centerX = radius;
//    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:radius startAngle:M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
//    [path fill];
}
@end
