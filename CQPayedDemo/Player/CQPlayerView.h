//
//  CQPlayerView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol CQPlayerViewDelegate <NSObject>

- (void)backViewController;
- (void)barHiddenAnimation:(BOOL)hidden;
@end

@interface CQPlayerView : UIView

@property(nonatomic,strong)NSURL *videoUrl;

// 销毁播放页面
- (void)invalidatePlayerView;

- (void)interfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@property(nonatomic,weak)id<CQPlayerViewDelegate> delegate;
@end
