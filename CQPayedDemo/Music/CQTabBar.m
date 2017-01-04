//
//  CQTabBar.m
//  CQPayedDemo
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQTabBar.h"
#import "CQButton.h"

@interface CQTabBar ()
@property(nonatomic,weak)UIButton *selectedButton;
@end

@implementation CQTabBar

- (void)buttonClicked:(UIButton *)sender {
    self.selectedButton.selected =  NO;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    if ([self.delegate respondsToSelector:@selector(buttonClickedEvents:)]) {
        [self.delegate buttonClickedEvents:sender];
    }
}

- (void)centernButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(centernButtonClickedEvents:)]) {
        [self.delegate centernButtonClickedEvents:sender];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(237.0, 180.0, 20.0, 1.0);
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0, 0, kScreen_W, 0.5);
        line.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:line];
    }
    return self;
}

- (void)addTabBarItemWithImage:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    CQButton *button = [[CQButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(87, 173, 104, 1.0f) forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)addTabBarCenterItemWithImage:(NSString *)image {
    UIButton *centerBtn = [[UIButton alloc] init];
    [centerBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(centernButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn setBackgroundColor:RGBCOLOR(237.0, 180.0, 20.0, 1.0)];
    [self addSubview:centerBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    CGFloat centerIndex = (count - 1) * 0.5;
    CGFloat centerW = 50.0;
    CGFloat centerX = (self.width - centerW) * 0.5;
    CGFloat buttonW = (self.width - centerW) / (count - 1);
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];
        if (i == centerIndex && i != 0) {
            button.frame = CGRectMake(centerX, -20.0, centerW, centerW);
            button.layer.cornerRadius = centerW * 0.5;
            button.layer.masksToBounds = YES;
        } else if (i > centerIndex) {
            button.tag = i - 1;
            button.frame = CGRectMake((i - 1) * buttonW + centerW, 0, buttonW, kBar_H);
        } else {
            button.tag = i;
            button.frame = CGRectMake(i * buttonW, 0, buttonW, kBar_H);
            if (i == 0) {
                self.selectedButton = button;
                self.selectedButton.selected = YES;
            }
        }
    }
}

@end
