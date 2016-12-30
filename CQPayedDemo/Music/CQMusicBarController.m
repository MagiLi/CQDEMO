//
//  CQMusicBarController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQMusicBarController.h"
#import "CQMajorController.h"
#import "CQRecommendController.h"

@interface CQMusicBarController ()

@end

@implementation CQMusicBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *majorSB = [UIStoryboard storyboardWithName:@"CQMajorController" bundle:[NSBundle mainBundle]];
    CQMajorController *majorVC = majorSB.instantiateInitialViewController;
    UINavigationController *majorNav = [[UINavigationController alloc] initWithRootViewController:majorVC];
    majorNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:[UIImage imageNamed:@"majorBar_Normal"] selectedImage:[UIImage imageNamed:@"majorBar_Selected"]];
    
    UIStoryboard *recommendSB = [UIStoryboard storyboardWithName:@"CQRecommendController" bundle:[NSBundle mainBundle]];
    CQRecommendController *recommendVC = recommendSB.instantiateInitialViewController;
    UINavigationController *recommendNav = [[UINavigationController alloc] initWithRootViewController:recommendVC];
    recommendNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"recommendBar_Normal"] selectedImage:[UIImage imageNamed:@"recommendBar_Selected"]];
    self.viewControllers = @[majorNav, recommendNav];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(87, 173, 104, 1.0f), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setBarTintColor:RGBCOLOR(237.0, 180.0, 20.0, 1.0)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
