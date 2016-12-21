//
//  CQTopView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQTopView.h"

#define StatusBar_H 20.0

@interface CQTopView ()
@property(nonatomic,weak)UIView *statusBarView;
@property(nonatomic,weak)UIButton *backBtn;
@property(nonatomic,weak)UIButton *fullScreenBtn;
@end

@implementation CQTopView

- (void)backButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(backButtonClickedEvents:)]) {
        [self.delegate backButtonClickedEvents:sender];
    }
}

- (void)fullScreenButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fullScreenButtonClickedEvents:)]) {
        [self.delegate fullScreenButtonClickedEvents:sender];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.statusBarView.frame = CGRectMake(0, 0, self.frame.size.width, StatusBar_H);
    self.backBtn.frame = CGRectMake(0, StatusBar_H, 50.0, self.frame.size.height-StatusBar_H);
    self.fullScreenBtn.frame = CGRectMake(self.frame.size.width - 80.0, StatusBar_H, 80.0, self.frame.size.height-StatusBar_H);
}

- (instancetype)init {
    self = [super init];
    if (self) {
       self.backgroundColor = [UIColor colorWithRed:.0f / 255.0 green:.0f / 255.0 blue:.0f / 255.0 alpha:0.5f];
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    UIView *statusBarView = [[UIView alloc] init];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self addSubview:statusBarView];
    self.statusBarView = statusBarView;
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back_Nav"] forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [backBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIButton *fullScreenBtn = [[UIButton alloc] init];
    [fullScreenBtn setImage:[UIImage imageNamed:@"screen_Max"] forState:UIControlStateNormal];
    [fullScreenBtn setImage:[UIImage imageNamed:@"screen_Min"] forState:UIControlStateSelected];
    [fullScreenBtn setTintColor:[UIColor whiteColor]];
    [fullScreenBtn addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fullScreenBtn];
    self.fullScreenBtn = fullScreenBtn;
}

@end
