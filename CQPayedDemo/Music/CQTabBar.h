//
//  CQTabBar.h
//  CQPayedDemo
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQTabBarDelegate <NSObject>

- (void)buttonClickedEvents:(UIButton *)sender;
- (void)centernButtonClickedEvents:(UIButton *)sender;

@end

@interface CQTabBar : UIView

- (void)addTabBarItemWithImage:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title;
- (void)addTabBarCenterItemWithImage:(NSString *)image;
@property(nonatomic,weak)id<CQTabBarDelegate> delegate;
@end
