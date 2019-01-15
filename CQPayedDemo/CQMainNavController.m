//
//  CQMainNavController.m
//  CQPayedDemo
//
//  Created by Mac on 2019/1/15.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQMainNavController.h"

@interface CQMainNavController ()

@end

@implementation CQMainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *backView = [self.navigationBar valueForKey:@"backgroundView"];
    [backView setGradientBackgroundWithColors:@[ThemeColor_Left,ThemeColor_Right] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
