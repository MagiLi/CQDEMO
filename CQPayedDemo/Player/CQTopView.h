//
//  CQTopView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQTopViewDelegate <NSObject>
@required
- (void)backButtonClickedEvents:(UIButton *)sender;
- (void)fullScreenButtonClickedEvents:(UIButton *)sender;
@end

@interface CQTopView : UIView
@property(nonatomic,weak)UIButton *fullScreenBtn;
@property(nonatomic,weak)id<CQTopViewDelegate> delegate;
@end
