//
//  CQPlayerManager.m
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface CQPlayerManager ()

@property(nonatomic,strong)AVURLAsset *urlAsset;
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放资源
@property(nonatomic,strong)AVPlayer *player; // 播放器

@property(nonatomic,assign)void(^ loadedBlock)(CGFloat progress);// 缓冲进度
@property(nonatomic,assign)void(^ videoBlock)(CGFloat progress, CGFloat duration); // 播放进度

@property(nonatomic,weak)CQVideoModel *model;
@end

@implementation CQPlayerManager

+ (instancetype)sharedInstance {
    static CQPlayerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];// 支持后台播放
        [[AVAudioSession sharedInstance] setActive:YES error:nil];// 激活
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];// 开始监控
    }
    return self;
}

- (void)playWithData:(CQVideoModel *)model withIndexPath:(NSIndexPath *)indexPath {
    self.model = model;
//    NSDictionary *option = @{AVURLAssetPreferPreciseDurationAndTimingKey: @(NO)};
//    self.urlAsset = [[AVURLAsset alloc] initWithURL:model.url options:option];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
//    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)playWithData:(NSString *)videoStr {

    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoStr]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self playVideo];
}

#pragma mark -
#pragma mark - playVideo
- (void)playVideo {
//    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.player play];
        self.isPlaying = YES;
//        self.duration = self.urlAsset.duration.value / self.urlAsset.duration.timescale;
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf timeStack];
        }];
//    }
}
- (void)timeStack {
    NSLog(@"==========%@",self.videoBlock);
    float currentTime = CMTimeGetSeconds(self.player.currentTime);
//    if (self.videoBlock) {
//        self.videoBlock(currentTime, self.duration);
//    }
    if ([self.delegate respondsToSelector:@selector(playVideoProgress:duration:)]) {
        [self.delegate playVideoProgress:currentTime duration:self.duration];
    }
}
- (void)playVideoProgress:(void (^)(CGFloat, CGFloat))progressBlock {
    self.videoBlock = progressBlock;
}
#pragma mark -
#pragma mark - loadedTimeRanges
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSLog(@"loadedTimeRanges");
        
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CGFloat progress = timeInterval / CMTimeGetSeconds(self.playerItem.duration);
        if (self.loadedBlock) {
            self.loadedBlock(progress);
        }
    }
}
- (NSTimeInterval)availableDuration
{
    CMTimeRange timeRange = [self.playerItem.loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)loadedTimeRangesProgress:(void (^)(CGFloat))progressBlock {
    self.loadedBlock = progressBlock;
}

@end
