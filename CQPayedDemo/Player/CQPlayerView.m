//
//  CQPlayerView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPlayerView.h"
#import "CQTopView.h"
#import "CQBottomView.h"
#import <MediaPlayer/MediaPlayer.h>

#define Bar_H 40.0
#define BarHidden_T 4.0
#define BarAfterTime 10.0

@interface CQPlayerView () <CQTopViewDelegate, CQBottomViewDelegate>

@property(nonatomic,strong)AVURLAsset *urlAsset;
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放资源
@property(nonatomic,strong)AVPlayer *player; // 播放器
@property(nonatomic,strong)AVPlayerLayer *playerLayer; // 播放图层

@property(nonatomic,strong)CQTopView *topView;
@property(nonatomic,strong)CQBottomView *bottomView;
@property(nonatomic,strong)UIActivityIndicatorView *indicateView;

@property(nonatomic,assign)BOOL barHidden;

@end

@implementation CQPlayerView

- (void)stopVideo {
    [self.player pause];
    self.bottomView.playBtnSelected = NO;
    
}
- (void)playerVideo {
    
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        self.bottomView.playBtnSelected = YES;
        [self.player play];
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf timeStack];
            
        }];
    }

}

- (void)timeStack {

    if (self.urlAsset.duration.timescale != 0) {
        float currentTime = CMTimeGetSeconds(self.player.currentTime);
        float durationTime = self.urlAsset.duration.value / self.urlAsset.duration.timescale;
        [self setTimeWithDurationTime:(NSInteger)durationTime withCurrentTime:(NSInteger)currentTime];// 播放时间
        self.bottomView.slider.value = currentTime / durationTime;//当前进度
    }
}
#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic{
    
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"阿杜专辑";
    // 歌手
    info[MPMediaItemPropertyArtist] = @"阿杜";
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = @"天黑";
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"slider"]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(self.urlAsset.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.playerItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    
}


#pragma mark -
#pragma mark - 播放时间
- (void)setTimeWithDurationTime:(NSInteger)durationTime withCurrentTime:(NSInteger)currentTime {
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = currentTime % 60;
    
    NSInteger durMin = durationTime / 60;
    NSInteger durSec = durationTime % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", (long)currentMin, (long)currentSec, (long)durMin, (long)durSec];
    [self.bottomView setCurrentTime:timeStr];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

}

#pragma mark -
#pragma mark - CQTopViewDelegate
- (void)backButtonClickedEvents:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(backViewController)]) {
        [self.delegate backViewController];
    }
}

- (void)fullScreenButtonClickedEvents:(UIButton *)sender {
    if (kScreen_W < kScreen_H) { // 横屏
        sender.selected = YES;
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        self.frame = CGRectMake(0, 0, kScreen_W, kScreen_H);
    } else { // 竖屏
        sender.selected = NO;
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        self.frame = CGRectMake(0, 0, kScreen_W, kScreen_H * 0.5);
    }
}

- (void)playButtonClickedEvents:(UIButton *)sender {
    if (sender.selected) {
        [self stopVideo];
    } else {
        [self playerVideo];
    }
}
#pragma mark -
#pragma mark - 缓冲进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self.indicateView stopAnimating];
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CGFloat totalDuration = CMTimeGetSeconds(self.playerItem.duration);
        [self.bottomView.progressView setProgress:timeInterval / totalDuration animated:YES];
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

#pragma mark -
#pragma mark - dragSliderEvents
- (void)dragSliderEvents:(UISlider *)sender {
    //拖动改变视频播放进度
    if (self.playerItem.status == AVPlayerStatusFailed || self.playerItem.status == AVPlayerItemStatusUnknown) {
        [self stopVideo];
    }
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        CGFloat durationTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSInteger dragedSeconds = floorf(durationTime * sender.value);
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
//        CMTime dragedCMTime = CMTimeMakeWithSeconds(sender.value, self.playerItem.duration.timescale);
        [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            if (finish) {
                [self playerVideo];
            }
        }];
        
        [self setTimeWithDurationTime:(NSInteger)durationTime withCurrentTime:dragedSeconds];
    }

}

#pragma mark -
#pragma mark - AVPlayerItemDidPlayToEndTimeNotification
- (void)playerItemDidPlayToEnd:(id)sender {
    self.bottomView.playBtnSelected = NO;
}

#pragma mark -
#pragma mark - tapGesture
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(barHiddenAnimation:)]) {
        [self.delegate barHiddenAnimation:!self.barHidden];
    }
    if (self.barHidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.topView.y = 0;
            self.bottomView.y = self.height - self.bottomView.height;
        } completion:^(BOOL finished) {
            self.barHidden = NO;
            [self performSelector:@selector(hiddenBars) withObject:nil afterDelay:BarAfterTime];
        }];
    } else {
        [self hiddenBars];
    }
}

- (void)hiddenBars {
    if ([self.delegate respondsToSelector:@selector(barHiddenAnimation:)]) {
        [self.delegate barHiddenAnimation:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.topView.y = -self.topView.height;
        self.bottomView.y = self.height;
    } completion:^(BOOL finished) {
        self.barHidden = YES;
    }];
}

#pragma mark -
#pragma mark - set方法
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    NSDictionary *option = @{AVURLAssetPreferPreciseDurationAndTimingKey: @(NO)};
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:option];
    self.urlAsset = urlAsset;
    self.playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    
//    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setupUI];

    [self performSelector:@selector(hiddenBars) withObject:nil afterDelay:BarAfterTime];
}

// 获取视频截图
- (UIImage *)getVideImage:(AVURLAsset *)urlAssert {
    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAssert];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime actualTime;
    NSError *error;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:&actualTime error:&error];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}


- (void)setupUI {
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.indicateView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerLayer.frame = CGRectMake(0, 0, self.width, self.height);
    self.topView.frame = CGRectMake(0, 0, kScreen_W, Bar_H + 20.0);
    self.bottomView.frame = CGRectMake(0, self.height - Bar_H, kScreen_W, Bar_H);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGesture];
        //AVPlayer播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];

    }
    return self;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playerLayer;
}

- (CQTopView *)topView {
    if (!_topView) {
        _topView = [[CQTopView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}

- (CQBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CQBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
- (UIActivityIndicatorView *)indicateView {
    if (!_indicateView) {
        _indicateView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicateView.center = CGPointMake(self.centerX, self.centerY);
    }
    [_indicateView startAnimating];
    return _indicateView;
}
- (void)invalidatePlayerView {
    [self.player pause];
    self.player = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    NSLog(@"CQPlayerView: dealloc");
}

@end
