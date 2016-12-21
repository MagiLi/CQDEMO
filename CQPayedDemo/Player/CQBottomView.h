//
//  CQBottomView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQBottomViewDelegate <NSObject>
@required
- (void)playButtonClickedEvents:(UIButton *)sender;
- (void)dragSliderEvents:(UISlider *)sender;

@end

@interface CQBottomView : UIView
@property(nonatomic,weak)UISlider *slider;
@property(nonatomic,assign)BOOL playBtnSelected;

- (void)setCurrentTime:(NSString *)currentTime;

@property(nonatomic,weak)id<CQBottomViewDelegate> delegate;
@end
