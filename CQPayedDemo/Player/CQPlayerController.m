//
//  CQPlayerController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPlayerController.h"
#import "CQPlayerView.h"

@interface CQPlayerController ()<CQPlayerViewDelegate>

@property(nonatomic,weak)CQPlayerView *playerView;
@property(nonatomic,assign)BOOL statusBarHidden;

@end

@implementation CQPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat scale = 0.5;
    if (kScreen_W > kScreen_H) { // 横屏
        scale = 1.0;
    }
    
    CQPlayerView *playerView = [[CQPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H*scale)]; 
    
//    playerView.videoUrl = [NSURL URLWithString:@"http://img.readerday.com/cover/1481785184.mp3"];
    playerView.videoUrl = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4"];
//    playerView.videoUrl = [NSURL URLWithString:@"http://img.readerday.com/cover/978711136541910.mp3"];
    playerView.delegate = self;
    [self.view addSubview:playerView];
    self.playerView = playerView;
    
    [self backgroundObserver];

}

- (void)backgroundObserver {
    // 开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // 后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 激活
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark - CQPlayerViewDelegate
- (void)backViewController {

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)barHiddenAnimation:(BOOL)hidden {
    self.statusBarHidden = hidden;
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark -
#pragma mark - statusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

//获取将要旋转的状态
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.playerView interfaceOrientation:toInterfaceOrientation];
}

//获取旋转中的状态
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

}
//屏幕旋转完成的状态
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientationN
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.playerView invalidatePlayerView];
}

@end
