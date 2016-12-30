//
//  CQPlayerManager.h
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQVideoModel.h"

@interface CQPlayerManager : NSObject

@property(nonatomic,assign)BOOL isPlaying;  // 是否正在播放
@property(nonatomic,assign)CGFloat duration; // 总时长



+ (instancetype)sharedInstance;

- (void)playWithData:(CQVideoModel *)model withIndexPath:(NSIndexPath *)indexPath;

// 播放进度的回调
- (void)playVideoProgress:(void(^)(CGFloat progress, CGFloat duration))progressBlock;
// 缓冲进度的回调
- (void)loadedTimeRangesProgress:(void(^)(CGFloat progress))progressBlock;

@end
