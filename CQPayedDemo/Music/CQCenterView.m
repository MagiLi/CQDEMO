//
//  CQCenterView.m
//  CQPayedDemo
//
//  Created by mac on 17/1/6.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQCenterView.h"

@interface CQCenterView ()
@property(nonatomic,weak)UIButton *btn;
@end

@implementation CQCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(237.0, 180.0, 20.0, 1.0);
        self.layer.cornerRadius = self.width * 0.5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = RGBCOLOR(237.0, 180.0, 20.0, 1.0).CGColor;
        self.layer.borderWidth = 2.0;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.btn = btn;
    }
    return self;
}

- (void)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(centerViewClicked:)]) {
        [self.delegate centerViewClicked:sender];
    }
}

- (CALayer *)btnLayer {
    return self.btn.layer;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.btn.selected = selected;
}

- (void)setCoverUrl:(NSString *)coverUrl {
    _coverUrl = coverUrl;
    [self.btn sd_setBackgroundImageWithURL:[NSURL URLWithString:coverUrl] forState:UIControlStateNormal];
}

@end
