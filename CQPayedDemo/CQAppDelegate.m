//
//  AppDelegate.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAppDelegate.h"
#import "CQMainController.h"
#import "CQMainNavController.h"
#import "CQPlayerManager.h"
@interface CQAppDelegate ()

@end

@implementation CQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.window makeKeyAndVisible];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQMainController" bundle:[NSBundle mainBundle]];
    CQMainNavController *nav = [sb instantiateInitialViewController];
    [self.window setRootViewController:nav];

    return YES;
}
//UIEventSubtypeNone                              = 0,//触摸事件的亚类型
//
//UIEventSubtypeMotionShake                       = 1,//摇晃
//
//UIEventSubtypeRemoteControlPlay                 = 100,//播放
//UIEventSubtypeRemoteControlPause                = 101,//暂停
//UIEventSubtypeRemoteControlStop                 = 102,//停止
//UIEventSubtypeRemoteControlTogglePlayPause      = 103,//播放和暂停切换
//UIEventSubtypeRemoteControlNextTrack            = 104,//下一首
//UIEventSubtypeRemoteControlPreviousTrack        = 105,//上一首
//UIEventSubtypeRemoteControlBeginSeekingBackward = 106,//开始后退
//UIEventSubtypeRemoteControlEndSeekingBackward   = 107,//结束后退
//UIEventSubtypeRemoteControlBeginSeekingForward  = 108,//开始快进
//UIEventSubtypeRemoteControlEndSeekingForward    = 109,//结束快进
#pragma mark - UIApplicationDelegate
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [[CQPlayerManager sharedInstance] play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [[CQPlayerManager sharedInstance] pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [[CQPlayerManager sharedInstance] nextSong];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [[CQPlayerManager sharedInstance] lastSong];
            break;
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
