//
//  CQMusicBarController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQMusicBarController.h"
//#import "CQMajorController.h"
//#import "CQRecommendController.h"
#import "CQVideoController.h"
#import "CQTabBar.h"

@interface CQMusicBarController ()<CQTabBarDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)CQTabBar *customeTabBar;


@end

@implementation CQMusicBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.customeTabBar];

    
    [self setupSubViewControllersWithTitle:@"推荐" name:@"CQMajorController" image:@"majorBar_Normal" selectedImage:@"majorBar_Selected" tag:0];
    [self.customeTabBar addTabBarCenterItemWithImage:@"play_Normal"];
    [self setupSubViewControllersWithTitle:@"主页" name:@"CQRecommendController" image:@"recommendBar_Normal" selectedImage:@"recommendBar_Selected" tag:1];
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
#pragma mark - CQTabBarDelegate
- (void)buttonClickedEvents:(UIButton *)sender {
    self.scrollView.contentOffset = CGPointMake(sender.tag * kScreen_W, -kNav_H);
}
- (void)centernButtonClickedEvents:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQVideoController" bundle:[NSBundle mainBundle]];
    CQVideoController *videoVC = sb.instantiateInitialViewController;
    [self presentViewController:videoVC animated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
