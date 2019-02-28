//
//  UIViewController+CurrentViewController.m
//  LPYProjrect
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 LvPai Culture. All rights reserved.
//

#import "UIViewController+CurrentViewController.h"

@implementation UIViewController (CurrentViewController)

+ (instancetype)currentViewController {
    UIViewController *resultVC;
    resultVC = [self _currentViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _currentViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_currentViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _currentViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _currentViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
//- (UIViewController *)getMerchantHomeController {
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[LPMerchantHomeController class]]) {
//            return controller;
//        }
//        if ([controller isKindOfClass:[LPYModelHomeViewController class]]) {
//            return controller;
//        }
//    }
//    return nil;
//}
//- (void)presentLoginController {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//    UINavigationController *loginNav = [storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
//    [self presentViewController:loginNav animated:YES completion:nil];
//}

@end
