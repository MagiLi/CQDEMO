//
//  CQVideoController.m
//  CQPayedDemo
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQVideoController.h"
#import "UIImageView+CQBlur.h"

@interface CQVideoController ()<CQPlayerManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *slide;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *durationTime;

@end

@implementation CQVideoController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupVideoUI];
    
}

- (void)playVideoProgress:(CGFloat)progress duration:(CGFloat)duration {
    self.currentTime.text = [NSString stringWithFormat:@"%f", progress];
    self.durationTime.text = [NSString stringWithFormat:@"%f", duration];
}

- (IBAction)backLastViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)playButtonclicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self setupAnimation:sender.selected];
    if ([self.delegate respondsToSelector:@selector(playButtonClickedEvents:)]) {
        [self.delegate playButtonClickedEvents:sender];
    }
}

- (void)setupAnimation:(BOOL)animation {
    if (animation) {
        if ([[CQAnimationManager sharedInsatnce] existRotationAnimation:self.circleImageView.layer]) {
            [[CQAnimationManager sharedInsatnce] resumeRotationAnimation:self.circleImageView.layer];
        } else {
            [[CQAnimationManager sharedInsatnce] startRotationAnimation:self.circleImageView.layer duration:10.0];
        }
    } else {
        [[CQAnimationManager sharedInsatnce] pauseRotationAnimation:self.circleImageView.layer];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.circleImageView.layer.cornerRadius = self.circleImageView.width * 0.5;
}
- (void)setupVideoUI {
    UIImage *image = self.image ? self.image : [UIImage imageNamed:@"backGroundImage"];
    self.circleImageView.image = image;
    self.circleImageView.layer.masksToBounds = YES;
    self.circleImageView.layer.borderColor = Theme_Color.CGColor;
    self.circleImageView.layer.borderWidth = 5.0;
    [self.backgroundView setBlurImage:image];
    
    self.playButton.selected = self.animation;
    [self setupAnimation:self.animation];
    
    [CQPlayerManager sharedInstance].delegate = self;
//    [self.slide setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
