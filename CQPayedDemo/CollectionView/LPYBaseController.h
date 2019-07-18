//
//  LPYBaseController.h
//  LPYProjrect
//
//  Created by Mac on 2018/9/11.
//  Copyright © 2018年 LvPai Culture. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const iPhoneX_S_Width;
extern CGFloat const iPhoneX_S_Height;
extern CGFloat const iPhoneX_Max_R_Width;
extern CGFloat const iPhoneX_Max_R_Height;

@interface LPYBaseController : UIViewController
// 应用主页面的高度
@property (nonatomic, assign, readonly)CGFloat mainViewHeight;
// 状态栏的高度
@property (nonatomic, assign, readonly)CGFloat statusBarHeight;
// 导航条的高度
@property (nonatomic, assign, readonly)CGFloat navgationHeight;
// tabBar的高度
@property (nonatomic, assign, readonly)CGFloat tabBarHeight;
/*
 *  监听状态栏高度的变化
 *  height 状态栏的高度
 */
- (void)statusBarFrameChanged:(CGFloat)height;
- (BOOL)isIPhoneX;
- (CGFloat)getNavgationBarHeight;

@end
