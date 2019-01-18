//
//  XTAudioPlayer.h
//  LoadingAndSinging
//
//  Created by XTShow on 2018/2/9.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CQPlayerConfiguration.h"
#import <AVKit/AVKit.h>

typedef void(^PlayCompleteBlock)(NSError *error);

@protocol CQAudioPlayerDelegate<NSObject>

@optional

/**
 通知代理因为缓冲资源耗尽暂停播放
 Tells the delegate the player is suspended because of the buffer is empty.

 @param player The AVPlayer object informing the delegate of this event.
 */
-(void)suspendForLoadingDataWithPlayer:(AVPlayer *)player;


/**
 通知代理播放器准备继续播放
 Tells the delegate the player is ready to continue to playback.

 @param player The AVPlayer object informing the delegate of this event.
 */
-(void)activeToContinueWithPlayer:(AVPlayer *)player;

@end

@interface CQAudioPlayer : NSObject

@property (nonatomic,weak) id<CQAudioPlayerDelegate> delegate;

// 播放器的配置属性
@property (nonatomic,strong) CQPlayerConfiguration *config;

+ (instancetype _Nonnull )sharePlayer;
/*
 @param urlStr 音频资源的链接或者本地缓存路径
 @param cachePath 指定缓存路径,如果为空则默认缓存路径
 @param playCompleteBlock 结束播放时的回调,如果结束失败则返回错误信息
 */
- (void)playWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath completion:(PlayCompleteBlock)playCompleteBlock;


/*
 @param urlStr 视频资源的链接或者本地缓存路径
 @param cachePath 指定缓存路径,如果为空则默认缓存路径
 @param videoFrame 播放容器的frame
 @param bgView 播放容器view
 @param playCompleteBlock 结束播放时的回调,如果结束失败则返回错误信息
 */
- (void)playWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath videoFrame:(CGRect)videoFrame inView:(UIView *)bgView completion:(PlayCompleteBlock)playCompleteBlock;

//使用系统AVPlayerViewController
- (AVPlayerViewController *)playByPlayerVCWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath completion:(PlayCompleteBlock)playCompleteBlock;

- (void)restart;//重新播放
- (void)pause;//暂停播放

//取消当前播放和当前播放的所有剩余网络请求的播放。
- (void)cancel;
//完全销毁Player，释放掉CQAudioPlayer所占用的全部内存，如非特殊需要，不建议使用。
- (void)completeDealloc;
@end
