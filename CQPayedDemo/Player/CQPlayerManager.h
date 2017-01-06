//
//  CQPlayerManager.h
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQVideoModel.h"

@protocol CQPlayerManagerDelegate <NSObject>

- (void)playVideoProgress:(CGFloat)progress duration:(CGFloat)duration;

@end

@interface CQPlayerManager : NSObject

@property(nonatomic,assign)BOOL isPlaying;  // 是否正在播放
@property(nonatomic,assign)CGFloat duration; // 总时长

+ (instancetype)sharedInstance;

- (void)playWithData:(CQVideoModel *)model withIndexPath:(NSIndexPath *)indexPath;
- (void)playWithData:(NSString *)videoStr;
// 播放进度的回调
- (void)playVideoProgress:(void(^)(CGFloat progress, CGFloat duration))progressBlock;
// 缓冲进度的回调
- (void)loadedTimeRangesProgress:(void(^)(CGFloat progress))progressBlock;

@property(nonatomic,weak)id<CQPlayerManagerDelegate> delegate;
@end
