//
//  CQVideoController.h
//  CQPayedDemo
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQSongModel.h"

@protocol CQVideoControllerDelegate <NSObject>

- (void)playButtonClickedEvents:(BOOL)isSelected;

@end

@interface CQVideoController : UIViewController

@property(nonatomic,assign)BOOL animation;
@property(nonatomic,weak)CQTracks_List *model;
@property(nonatomic,weak)id<CQVideoControllerDelegate> delegate;
@end
