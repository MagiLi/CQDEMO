//
//  CQPlayerManager.h
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQSongModel.h"

@protocol CQPlayerManagerDelegate <NSObject>
- (void)playVideoProgress:(CGFloat)progress duration:(CGFloat)duration;
- (void)loadedTimeRangesProgress:(CGFloat)progress;
- (void)currentVideoEnd;
@end

@interface CQPlayerManager : NSObject

@property(nonatomic,assign)BOOL isPlaying;  // 是否正在播放
@property(nonatomic,assign)CGFloat duration; // 总时长
@property(nonatomic,strong)NSMutableArray *imageCovers; // 锁屏时的图片

+ (instancetype)sharedInstance;
- (void)playWithData:(CQTracks_List *)model;
- (void)play;
- (void)pause;
// 播放进度的改变
- (void)changeVideoProgress:(CGFloat)value;
- (void)addSong:(CQTracks_List *)model;

@property(nonatomic,weak)id<CQPlayerManagerDelegate> delegate;
@end
