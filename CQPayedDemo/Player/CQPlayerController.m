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
#warning 该调控方式适用于支持横竖屏的demo
    if (kScreen_W > kScreen_H) { // 横屏
        scale = 1.0;
    }
    
    CQPlayerView *playerView = [[CQPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H*scale)];
    playerView.videoUrl = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4"];
    playerView.delegate = self;
    [self.view addSubview:playerView];
    self.playerView = playerView;

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
#pragma mark -
#pragma mark - 横屏/竖屏
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    
//    NSLog(@"====== %d", toInterfaceOrientation);
//    
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.playerView invalidatePlayerView];
}

@end
