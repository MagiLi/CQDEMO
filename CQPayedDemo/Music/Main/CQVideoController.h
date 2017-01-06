//
//  CQVideoController.h
//  CQPayedDemo
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQVideoControllerDelegate <NSObject>

- (void)playButtonClickedEvents:(UIButton *)sender;

@end

@interface CQVideoController : UIViewController

@property(nonatomic,assign)BOOL animation;
@property(nonatomic,weak)UIImage *image;

@property(nonatomic,weak)id<CQVideoControllerDelegate> delegate;
@end
