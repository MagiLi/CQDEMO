//
//  LPYBaseController.m
//  LPYProjrect
//
//  Created by Mac on 2018/9/11.
//  Copyright © 2018年 LvPai Culture. All rights reserved.
//

#import "LPYBaseController.h"

CGFloat const iPhoneX_S_Width = 375.0;
CGFloat const iPhoneX_S_Height = 812.0;

CGFloat const iPhoneX_Max_R_Width = 414.0;
CGFloat const iPhoneX_Max_R_Height = 896.0;
//2436 x 1125    x/xs           812 x 375
//2688 x 1242   xs Max          896 x 414
//1792 x 828      xr            896 x 414
@interface LPYBaseController ()
@property (nonatomic, assign)CGRect statusBarFrame;
@end

@implementation LPYBaseController
-(instancetype)init{
    self = [super init];
    if (self) {
        if (![self isMemberOfClass:[LPYBaseController class]]) {
            NSLog(@"init:%@",NSStringFromClass([self class]));
        }
    }
    return self;
}

-(void)dealloc{
    if (![self isMemberOfClass:[LPYBaseController class]]) {
        NSLog(@"init:%@",NSStringFromClass([self class]));
    }
}


- (void)statusBarFrameChanged:(CGFloat)height {
    self.mainViewHeight = kScreen_H-44-height;
    self.statusBarHeight = height;
    [self.view setNeedsLayout];
}

#pragma mark - statusBarFrameDidChanged
- (void)statusBarFrameDidChanged:(NSNotification *)noti {
    [self statusBarFrameChanged:self.statusBarFrame.size.height ];
}
- (void)statusBarFrameWillChanged:(NSNotification *)noti {
    NSValue *statusBarValue = noti.userInfo[@"UIApplicationStatusBarFrameUserInfoKey"];
    self.statusBarFrame = statusBarValue.CGRectValue;
}
- (void)setMainViewHeight:(CGFloat)mainViewHeight {
    _mainViewHeight = mainViewHeight;
}
- (void)setNavgationHeight:(CGFloat)navgationHeight {
    _navgationHeight = navgationHeight;
}
- (void)setTabBarHeight:(CGFloat)tabBarHeight {
    _tabBarHeight = tabBarHeight;
}
- (void)setStatusBarHeight:(CGFloat)statusBarHeight {
    _statusBarHeight = statusBarHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height ;
    self.mainViewHeight=kScreen_H-44-statusBarH;
    self.navgationHeight = [self getNavgationBarHeight];
    self.tabBarHeight =  [self getTabBarHeight];
    [self statusBarFrameChanged:statusBarH];
    // 状态栏变化的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameWillChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"打印%@的层级：\n%@",NSStringFromClass([self class]),[self.view performSelector:@selector(recursiveDescription)]);
}

- (BOOL)isIPhoneX {
    return  kScreen_H >= 812.0;

//    return (kScreenWidth == iPhoneX_S_Width && kScreenHeight == iPhoneX_S_Height);
}
- (CGFloat)getNavgationBarHeight {
    return (kISiPhoneX ? 44.0 : 20.0) + 44.0;
}
- (CGFloat)getTabBarHeight {
    return kISiPhoneX ? 83.0 : 49.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
