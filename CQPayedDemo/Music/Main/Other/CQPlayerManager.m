//
//  CQPlayerManager.m
//  CQPayedDemo
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static NSString *loadedTimeRanges = @"loadedTimeRanges";
static NSString *status = @"status";

@interface CQPlayerManager ()

@property(nonatomic,strong)AVURLAsset *urlAsset;
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放资源
@property(nonatomic,strong)AVPlayer *player; // 播放器

//@property(nonatomic,strong)NSMutableArray *songs;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSMutableDictionary *lockScreenData;
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
        //AVPlayer播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    }
    return self;
}

#pragma mark -
#pragma mark - playVideo
- (void)playWithData:(CQTracks_List *)model {
    self.currentModel = model;
    [self playMusic];
}

- (void)playMusic {
    self.isPlaying = YES;
    if (self.playerItem) { // 先判断有没有监听
        [self.playerItem removeObserver:self forKeyPath:loadedTimeRanges];
        [self.playerItem removeObserver:self forKeyPath:status];
    }
//    self.urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:self.currentModel.playUrl64] options:<#(nullable NSDictionary<NSString *,id> *)#>]
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.currentModel.playUrl64]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    self.player.automaticallyWaitsToMinimizeStalling = NO;
    [self.playerItem addObserver:self forKeyPath:loadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];// 缓冲进度的监听
    [self.playerItem addObserver:self forKeyPath:status options:NSKeyValueObservingOptionNew context:nil];// 播放状态的监听
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [weakSelf timeStack];
        }
    }];
    [self.player play];
}

#pragma mark -
#pragma mark - playEndObserVer
- (void)playerItemDidPlayToEnd:(id)sender {
    if (self.orderType == CQPlayerOrderTypeSequence) {
        if (self.currentIndex + 1 < self.playList.count) { // 播放下一首
            self.currentIndex += 1;
            [self playOtherVideo];
        } else { // 所有歌曲播放完毕
            self.currentIndex = 0;
//            if ([self.delegate respondsToSelector:@selector(currentVideoEnd)]) {
//                [self.delegate currentVideoEnd];
//            }
//            self.isPlaying = NO;
        }
    } else if (self.orderType == CQPlayerOrderTypeRandom) {
        self.currentIndex = arc4random() % self.playList.count;
    }  else if (self.orderType == CQPlayerOrderTypeSingleCycle) {
        
    }
    [self playOtherVideo];
}
- (void)playOtherVideo {
    self.currentModel = self.playList[self.currentIndex];
    [self playMusic];
//    [self updateLockedScreenMusic];
    if ([self.delegate respondsToSelector:@selector(playNextVideoWithModel:)]) {
        [self.delegate playNextVideoWithModel:self.currentModel];
    }
}
- (void)nextSong {
    if (self.currentIndex + 1 < self.playList.count) {
        self.currentIndex += 1;
    } else {
        self.currentIndex = 0;
    }
    [self playOtherVideo];
}
- (void)lastSong {
    if (self.currentIndex > 0) {
        self.currentIndex -= 1;
    } else {
        self.currentIndex = self.playList.count - 1;
    }
    [self playOtherVideo];
}
#pragma mark -
#pragma mark - playProgress
- (void)changeVideoProgress:(CGFloat)value {
    if (self.playerItem.status == AVPlayerStatusReadyToPlay) {
        CMTime dragedCMTime = CMTimeMake(floorf(self.duration * value), 1);
        //CMTime dragedCMTime = CMTimeMakeWithSeconds(sender.value, self.playerItem.duration.timescale);
        [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            if (finish) {

            }
        }];
        [self timeStack];
    }

}
- (void)timeStack {
    float currentTime = CMTimeGetSeconds(self.player.currentTime);
    if ([self.delegate respondsToSelector:@selector(playVideoProgress:duration:)]) {
        [self.delegate playVideoProgress:currentTime duration:self.duration];
    }
}

#pragma mark -
#pragma mark - loadedTimeRanges
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:loadedTimeRanges]) { // 计算缓冲进度
        self.duration = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSTimeInterval timeInterval = [self availableDuration];
        CGFloat progress = timeInterval / CMTimeGetSeconds(self.playerItem.duration);
        if ([self.delegate respondsToSelector:@selector(loadedTimeRangesProgress:)]) {
            [self.delegate loadedTimeRangesProgress:progress];
        }
    } else if ([keyPath isEqualToString:status]) { // 播放状态
        switch (self.playerItem.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"AVPlayerStatusUnknown");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"AVPlayerStatusReadyToPlay");
                [self updateLockedScreenMusic];
                break;
            case AVPlayerStatusFailed:
                NSLog(@"AVPlayerStatusFailed");
                break;
            default:
                break;
        }
    }
}

- (NSTimeInterval)availableDuration {
    CMTimeRange timeRange = [self.playerItem.loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    // 专辑名称
    self.lockScreenData[MPMediaItemPropertyAlbumTitle] = self.currentModel.title;
    // 歌手
    self.lockScreenData[MPMediaItemPropertyArtist] = self.currentModel.nickname;
    // 歌曲名称
    self.lockScreenData[MPMediaItemPropertyTitle] = self.currentModel.title;
    // 设置图片
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.coverSmall] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.lockScreenData[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:image];
        center.nowPlayingInfo = self.lockScreenData;
    }];
    
    // 设置持续时间（歌曲的总时间）
    [self.lockScreenData setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(self.playerItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [self.lockScreenData setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.playerItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = self.lockScreenData;
    
}
- (void)play {
    [self.player play];
}
- (void)pause {
    [self.player pause];
}
- (NSMutableDictionary *)lockScreenData {
    if (!_lockScreenData) {
        _lockScreenData = [NSMutableDictionary dictionary];
    }
    return _lockScreenData;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
