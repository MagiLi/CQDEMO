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
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)CALayer *line;


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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(237.0, 180.0, 20.0, 1.0);
        [self addSubview:self.contentView];
        [self.contentView.layer addSublayer:self.line];
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
    [self.contentView addSubview:button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.contentView.subviews.count;
    NSInteger centerIndex = count / 2;
    CGFloat buttonW = (self.width - 50.0) / count;
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = self.contentView.subviews[i];
        button.tag = i;
        if (i < centerIndex) {
            button.frame = CGRectMake(buttonW * i, 0, buttonW, kBar_H);
            if (i == 0) {
                self.selectedButton = button;
                self.selectedButton.selected = YES;
            }
        } else {
            button.frame = CGRectMake(buttonW * i + 50.0, 0, buttonW, kBar_H);
        }
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kBar_H)];
    }
    return _contentView;
}
- (CALayer *)line {
    if (!_line) {
        _line = [[CALayer alloc] init];
        _line.frame = CGRectMake(0, 0, self.contentView.width, 0.5);
        _line.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    return _line;
}

@end
