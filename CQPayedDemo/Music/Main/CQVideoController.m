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
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *slide;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *durationTime;

@end

@implementation CQVideoController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupVideoUI];
    
}
- (IBAction)backLastViewController {
//    [[CQAnimationManager sharedInsatnce] removeRotationAnimation:self.circleImageView.layer];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark - CQPlayerManagerDelegate
- (void)playVideoProgress:(CGFloat)progress duration:(CGFloat)duration {
    NSInteger currentMin = (NSInteger)progress / 60;
    NSInteger currentSec = (NSInteger)progress % 60;
    
    NSInteger durMin = (NSInteger)duration / 60;
    NSInteger durSec = (NSInteger)duration % 60;
    
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d", currentMin, currentSec];
    self.durationTime.text = [NSString stringWithFormat:@"%02d:%02d", durMin, durSec];
    self.slide.value = progress / duration;
}
- (void)loadedTimeRangesProgress:(CGFloat)progress {
    [self.progressView setProgress:progress];
}
- (IBAction)sliderProgressDrag:(UISlider *)sender {
    [[CQPlayerManager sharedInstance] changeVideoProgress:sender.value];
}

- (IBAction)playButtonclicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self setupAnimation:sender.selected];
    if ([self.delegate respondsToSelector:@selector(playButtonClickedEvents:)]) {
        [self.delegate playButtonClickedEvents:sender];
    }
}

- (void)currentVideoEnd {
    self.playButton.selected = NO;
    [self setupAnimation:NO];
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
    [self.progressView setProgress:.0];
    self.playButton.selected = self.animation;
    if (self.animation) {
        [self setupAnimation:YES];
    }
    self.titleLab.text =
    [CQPlayerManager sharedInstance].delegate = self;
//    [self.slide setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
}

@end
