//
//  CQMusicBarController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQMusicBarController.h"
#import "CQVideoController.h"
#import "CQTabBar.h"
#import "CQCenterView.h"

@interface CQMusicBarController ()<CQTabBarDelegate, CQVideoControllerDelegate, CQCenterViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)CQTabBar *customeTabBar;
@property(nonatomic,strong)CQCenterView *centerView;

@end

@implementation CQMusicBarController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [UIView animateWithDuration:0.2 animations:^{
        self.centerView.y = kScreen_H - kBar_H - 10.0;
        self.centerView.x = kScreen_W - 60.0;
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.centerView.y = kScreen_H - kBar_H - 20.0;
        self.centerView.x = (kScreen_W - 50.0) * 0.5;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.customeTabBar];
    [self.navigationController.view addSubview:self.centerView];
    
    [self setupSubViewControllersWithTitle:@"推荐" name:@"CQRecommendController" image:@"majorBar_Normal" selectedImage:@"majorBar_Selected" tag:0];
    [self setupSubViewControllersWithTitle:@"主页" name:@"CQMajorController" image:@"recommendBar_Normal" selectedImage:@"recommendBar_Selected" tag:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPlay:) name:notification_BeginPlay object:nil];
    __weak typeof(self) weakSelf = self;
//    [[CQPlayerManager sharedInstance] playVideoProgress:^(CGFloat progress, CGFloat duration) {
//        weakSelf.currentTime.text = [NSString stringWithFormat:@"%f", progress];
//        weakSelf.durationTime.text = [NSString stringWithFormat:@"%f", duration];
//    }];
}

- (void)beginPlay:(NSNotification *)noti {
    [[CQPlayerManager sharedInstance] playWithData:noti.object];
}

- (void)setupSubViewControllersWithTitle:(NSString *)title name:(NSString *)name image:(NSString *)image selectedImage:(NSString *)selectedImage tag:(NSInteger)tag {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
    UIViewController *viewController = SB.instantiateInitialViewController;
    viewController.view.frame = CGRectMake(tag*kScreen_W, 0, kScreen_W, kScreen_H - kNav_H - kBar_H);
    [self.customeTabBar addTabBarItemWithImage:image selectedImage:selectedImage title:title];
    [self.scrollView addSubview:viewController.view];
    [self addChildViewController:viewController];

}
#pragma mark -
#pragma mark - CQVideoControllerDelegate
- (void)playButtonClickedEvents:(UIButton *)sender {
    if (sender.selected) {
        if ([[CQAnimationManager sharedInsatnce] existRotationAnimation:self.centerView.btnLayer]) {
            [[CQAnimationManager sharedInsatnce] resumeRotationAnimation:self.centerView.btnLayer];
        } else {
            [[CQAnimationManager sharedInsatnce] startRotationAnimation:self.centerView.btnLayer duration:10.0];
        }
    } else {
        [[CQAnimationManager sharedInsatnce] pauseRotationAnimation:self.centerView.btnLayer];
    }
    self.centerView.selected = sender.selected;
}
#pragma mark -
#pragma mark - CQTabBarDelegate
- (void)buttonClickedEvents:(UIButton *)sender {
    self.scrollView.contentOffset = CGPointMake(sender.tag * kScreen_W, -kNav_H);
}
- (void)centerViewClicked:(UIButton *)sender {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQVideoController" bundle:[NSBundle mainBundle]];
    CQVideoController *videoVC = sb.instantiateInitialViewController;
    videoVC.animation = sender.selected;
    videoVC.image = sender.currentBackgroundImage;
    videoVC.delegate = self;
    [viewController presentViewController:videoVC animated:YES completion:nil];
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H - kBar_H)];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreen_W * 2, 0);
    }
    return _scrollView;
}

- (CQTabBar *)customeTabBar {
    if (!_customeTabBar) {
        _customeTabBar = [[CQTabBar alloc] initWithFrame:CGRectMake(0, kScreen_H - kBar_H, kScreen_W, kBar_H)];
        _customeTabBar.delegate = self;
    }
    return _customeTabBar;
}

- (CQCenterView *)centerView {
    if (!_centerView) {
        _centerView = [[CQCenterView alloc] initWithFrame:CGRectMake((kScreen_W - 50.0) * 0.5, kScreen_H - kBar_H -20.0, 50.0, 50.0)];
        _centerView.delegate = self;
    }
    return _centerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.centerView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end