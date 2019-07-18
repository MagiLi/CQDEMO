//
//  CQCenterView.h
//  CQPayedDemo
//
//  Created by mac on 17/1/6.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQCenterViewDelegate <NSObject>

- (void)centerViewClicked:(UIButton *)sender;

@end

@interface CQCenterView : UIView

@property(nonatomic,strong)CALayer *btnLayer;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,copy)NSString *coverUrl;


@property(nonatomic,weak)id<CQCenterViewDelegate> delegate;
@end
