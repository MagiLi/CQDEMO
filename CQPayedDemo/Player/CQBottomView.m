//
//  CQBottomView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQBottomView.h"

#define TimeLable_W 90.0

@interface CQBottomView ()
@property(nonatomic,weak)UIButton *playBtn;
@property(nonatomic,weak)UILabel *labTime;

@end

@implementation CQBottomView

- (void)dragSlider:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(dragSliderEvents:)]) {
        [self.delegate dragSliderEvents:sender];
    }
}

- (void)setPlayBtnSelected:(BOOL)playBtnSelected {
    _playBtnSelected = playBtnSelected;
    self.playBtn.selected = playBtnSelected;
}

- (void)setCurrentTime:(NSString *)currentTime {
    self.labTime.text = currentTime;
}

- (void)playButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(playButtonClickedEvents:)]) {
        [self.delegate playButtonClickedEvents:sender];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playBtn.frame = CGRectMake(0, 0, 40.0, self.height);
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame), 0, self.width - TimeLable_W - 40.0, self.height);
    self.progressView.frame = CGRectMake(self.slider.x+2.0, (self.height - 2.0)*0.5, self.slider.width - 4.0, 2.0);
    self.labTime.frame = CGRectMake(self.width-TimeLable_W, 0, TimeLable_W, self.height);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:.0f / 255.0 green:.0f / 255.0 blue:.0f / 255.0 alpha:0.5f];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setImage:[UIImage imageNamed:@"play_Normal"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"play_Selected"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    self.playBtn = playBtn;

    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.trackTintColor = [UIColor lightGrayColor];
    progressView.progressTintColor = [UIColor greenColor];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UISlider *slider = [[UISlider alloc] init];
    [slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    slider.maximumValue = 1;
    slider.minimumTrackTintColor = Theme_Color;
    slider.maximumTrackTintColor = [UIColor clearColor];
    [slider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    self.slider = slider;

    UILabel *labTime = [[UILabel alloc] init];
    labTime.font = [UIFont systemFontOfSize:13.0];
    labTime.textColor = [UIColor whiteColor];
    labTime.textAlignment = NSTextAlignmentCenter;
    labTime.text = @"00:00/00:00";
    [self addSubview:labTime];
    self.labTime = labTime;
}

@end
