//
//  LPOrderProgressView.m
//  LPYProjrect
//
//  Created by Mac on 2018/12/26.
//  Copyright © 2018 LvPai Culture. All rights reserved.
//

#import "LPOrderProgressView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*线宽*/
#define kLineWidth 2
/*间距*/
#define kSideSpace 30.0f
#define kFontSize 12.0f

@interface LPOrderProgressView ()
{
    //原点间距
    CGFloat _betweenSpace;
    //圆圈总数
    NSInteger _totalRoundCount;
    //原点高亮坐标
    NSInteger _roundIndex;
    
    /*  直线高亮
     *  从-1开始
     *  中间段一半为坐标1
     *    - * —— —— * —— —— * —
     * -1 0   1  2    3  4   5
     */
    //直线初始坐标
    CGFloat _oriPointX;
    //圆半径
    CGFloat _roundRadius;
    //高亮颜色
    UIColor *_highlightedColor;
    //普通颜色
    UIColor *_normalColor;
    //文字和图形上下间距
    CGFloat _verticalSpace;
    
}
@property (nonatomic,strong) NSMutableArray *titlesArr;
@end

@implementation LPOrderProgressView
#pragma mark - clicked
- (void)titleButtonClicked:(UIButton *)sender {
    if (!sender.selected) return;
    if ([self.delegate respondsToSelector:@selector(titleButtonClickedEvent:)]) {
        [self.delegate titleButtonClickedEvent:sender];
    }
}
- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr highlightColor:(UIColor *)highlightColor normalColor:(UIColor *)normalColor radius:(CGFloat)radius roundIndex:(NSInteger)roundIndex {
    self = [super initWithFrame:frame];
    if (self) {
        _highlightedColor = highlightColor;
        _normalColor = normalColor;
        _roundIndex = roundIndex > titlesArr.count ? titlesArr.count : roundIndex;
        _roundRadius = radius/2.0f;
        
        _totalRoundCount = titlesArr.count;
        self.titlesArr = [NSMutableArray arrayWithArray:titlesArr];
        _verticalSpace = frame.size.height/3.0 - kFontSize;
        // 每个圆点之间的间隔
        _betweenSpace = (frame.size.width - 2*kSideSpace)/ (_totalRoundCount - 1);

        for (NSInteger i = 0; i < titlesArr.count; i ++) {
            CGFloat highStartLineX = kSideSpace;
//            CGFloat highSartLineY = self.frame.size.height/3.0f + _verticalSpace + _roundRadius*2.0f;
            CGFloat highSartLineY = self.frame.size.height/3.0f;
            CGFloat indexSpace = _betweenSpace/2.0f;
            CGPoint center =  CGPointMake(highStartLineX + i *(indexSpace*2), highSartLineY + 5.0);
            UIButton *titleBtn = [[UIButton alloc] init];
            titleBtn.bounds = CGRectMake(0, 0, 60, 30.0f);
            [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
            titleBtn.center = center;
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            [titleBtn setTitleColor:UIColorFromRGB(0x323232) forState:UIControlStateSelected];
            [titleBtn setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
            if (i<_roundIndex) {
                titleBtn.selected = YES;
            } else {
                titleBtn.selected = NO;
            }
            [titleBtn setTitle:titlesArr[i] forState:UIControlStateNormal];
            titleBtn.tag = i + 10;
            [titleBtn addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleBtn];
        }
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setCurrentRoundIndex:(NSInteger)roundIndex {
    _roundIndex = roundIndex;
    for (NSInteger i = 0; i < self.titlesArr.count; i ++) {
        UIButton *titleBtn = [self viewWithTag:i + 10];
        if (i<_roundIndex) {
            titleBtn.selected = YES;
        } else {
            titleBtn.selected = NO;
        }
    }
    [self setNeedsDisplay];
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    // 下面两句代码的作用就是填充背景色
    if (self.bgColor) {
        [self.bgColor setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(rect);
    
    CGFloat highStartLineX = kSideSpace;
    CGFloat highSartLineY = self.frame.size.height/3.0f + _verticalSpace + _roundRadius*2.0f;
    CGFloat highEndLineX = highStartLineX + _betweenSpace * (_roundIndex > 1 ? (_roundIndex - 1) : 0);
    if (_roundIndex > 0) {// 亮线
        UIBezierPath *highPath = [UIBezierPath bezierPath];
        [highPath moveToPoint:CGPointMake(highStartLineX, highSartLineY)];
        [highPath addLineToPoint:CGPointMake(highEndLineX, highSartLineY)];
        [_highlightedColor set];
        highPath.lineWidth = kLineWidth;
        [highPath stroke];
    }
    CGFloat normalEndLineX = highStartLineX + self.frame.size.width - 2*kSideSpace;
    // 灰色的线
    UIBezierPath *normalPath = [UIBezierPath bezierPath];
    [normalPath moveToPoint:CGPointMake(highEndLineX, highSartLineY)];
    [normalPath addLineToPoint:CGPointMake(normalEndLineX, highSartLineY)];
    [[UIColor lightGrayColor] set];
    normalPath.lineWidth = kLineWidth;
    [normalPath stroke];
    
    
    for (NSInteger i = 0; i < _totalRoundCount; i ++) {// 圆点
        CGPoint pointX =  CGPointMake(highStartLineX + i *_betweenSpace, highSartLineY);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:pointX radius:_roundRadius startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
        if (i<_roundIndex) {
            [_highlightedColor setFill];
            [_highlightedColor setStroke];
        }else{
            [_normalColor setFill];
            [_normalColor setStroke];
        }
        [path stroke];
        [path fill];
    }
}


@end
