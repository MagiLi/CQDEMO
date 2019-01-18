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
@optional
- (void)playVideoProgress:(CGFloat)progress duration:(CGFloat)duration; // 播放进度
- (void)loadedTimeRangesProgress:(CGFloat)progress; // 缓冲进度
- (void)playNextVideoWithModel:(CQTracks_List *)model; // 下一首
- (void)currentVideoEnd; // 播放结束
@end

@interface CQPlayerManager : NSObject
@property (nonatomic, strong) NSArray <CQTracks_List *>*playList;
@property(nonatomic,assign)BOOL isPlaying;  // 是否正在播放
@property(nonatomic,assign)CGFloat duration; // 总时长
@property(nonatomic,strong)NSMutableArray *imageCovers; // 锁屏时的图片
@property(nonatomic,strong)CQTracks_List *currentModel; // 当前model
@property(nonatomic,assign)NSInteger currentIndex;// 正在播放的歌曲的索引
@property(nonatomic,strong)UIImage *currentImage; // 当前图片

+ (instancetype)sharedInstance;
- (void)playWithData:(CQTracks_List *)model;
- (void)play;
- (void)pause;
// 播放进度的改变
- (void)changeVideoProgress:(CGFloat)value;
//- (void)addSong:(CQTracks_List *)model;
- (void)lastSong;
- (void)nextSong;

@property(nonatomic,weak)id<CQPlayerManagerDelegate> delegate;
@end
