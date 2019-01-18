//
//  XTAudioPlayer.m
//  LoadingAndSinging
//
//  Created by XTShow on 2018/2/9.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "XTAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "XTDataManager.h"
#import "XTRangeManager.h"
#import "XTDownloader.h"

static XTAudioPlayer *audioPlayer = nil;
static dispatch_once_t onceToken;
static NSString *XTCustomScheme = @"XTShow";

@interface XTAudioPlayer ()
<
AVAssetResourceLoaderDelegate,
XTDataManagerDelegate
>

@property (nonatomic,copy) NSString *originalUrlStr;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) XTDataManager *dataManager;
@property (nonatomic,strong) XTDownloader *lastToEndDownloader;
@property (nonatomic,strong) NSMutableArray *nonToEndDownloaderArray;
@property (nonatomic,copy) PlayCompleteBlock playCompleteBlock;
@property (nonatomic,assign) BOOL addedNoti;
@property (nonatomic,assign) BOOL buffering;//buffer正在充能
@property (nonatomic,assign) BOOL fileCacheComplete;//当前文件下载成功并copy到指定缓存目录
@property (nonatomic,assign) BOOL fileExist;//当前文件本地有缓存(直接播放模式)
@property (nonatomic,assign) BOOL playedToEnd;//已经接收到了playToEnd的通知

@end

@implementation XTAudioPlayer

-(XTPlayerConfiguration *)config{
    if (!_config) {
        _config = [XTPlayerConfiguration new];
    }
    return _config;
}

#pragma mark - 生命周期
+ (instancetype)sharePlayer {
    
    dispatch_once(&onceToken, ^{
        audioPlayer = [XTAudioPlayer new];
    });
    return audioPlayer;
}

-(void)dealloc{
    NSLog(@"[XTAudioPlayer]%@:%s",self,__func__);
}

- (void)playWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath completion:(PlayCompleteBlock)playCompleteBlock{
    
    [self cancel];
    self.fileCacheComplete = NO;
    self.originalUrlStr = urlStr;
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:self.config.audioSessionCategory?self.config.audioSessionCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"[XTAudioPlayer]%s:%@",__func__,error);
    }
    
    NSString *filePath;
    BOOL fileExist;
    if (cachePath) {
        filePath = cachePath;
        fileExist = ([XTDataManager checkCachedWithFilePath:cachePath] != nil);
    }else{
        filePath = [XTDataManager checkCachedWithUrl:urlStr];
        fileExist = ([XTDataManager checkCachedWithUrl:urlStr] != nil);
    }
    self.fileExist = fileExist;
    
    if (fileExist) {
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];

        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];

        self.player = player;
        [player play];
        
    }else{
        
        XTDataManager *dataManager = [[XTDataManager alloc] initWithUrlStr:urlStr cachePath:filePath];
        dataManager.delegate = self;
        
        if (dataManager) {
            
            self.dataManager = dataManager;
            //此处需要将原始的url的协议头处理成系统无法处理的自定义协议头，此时才会进入AVAssetResourceLoaderDelegate的代理方法中
            NSURL *audioUrl = [self handleUrl:urlStr];
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            //为asset.resourceLoader设置代理对象
            [asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
            [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
            
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            self.player = player;
            
            //决定音频是否马上开始播放的关键性参数！！！
            if (@available(iOS 10.0, *)) {
                player.automaticallyWaitsToMinimizeStalling = NO;
            }
            
            [player play];
        }
        
    }
    
    if (self.player) {
        self.playCompleteBlock = playCompleteBlock;
        if (!self.addedNoti) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failToEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
            self.addedNoti = YES;
        }
        
    }

}

- (void)playWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath videoFrame:(CGRect)videoFrame inView:(UIView *)bgView completion:(PlayCompleteBlock)playCompleteBlock{
    
    [self playWithUrlStr:urlStr cachePath:cachePath completion:playCompleteBlock];
    
    if ((!CGRectEqualToRect(videoFrame, CGRectZero)) & (bgView != nil)) {
        
        if (self.player) {
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer = playerLayer;
            playerLayer.transform = CATransform3DRotate(CATransform3DIdentity, self.config.playerLayerRotateAngle?self.config.playerLayerRotateAngle:0, 0, 0, 1);
            playerLayer.videoGravity = self.config.playerLayerVideoGravity?self.config.playerLayerVideoGravity:AVLayerVideoGravityResizeAspect;
            playerLayer.frame = videoFrame;//注意此处三者间的顺序
            [bgView.layer addSublayer:playerLayer];
        }
    }
}

- (AVPlayerViewController *)playByPlayerVCWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath completion:(PlayCompleteBlock)playCompleteBlock{
    
    [self playWithUrlStr:urlStr cachePath:cachePath completion:playCompleteBlock];
    
    if (self.player) {
        AVPlayerViewController *playerVC = [AVPlayerViewController new];
        playerVC.player = self.player;
        return playerVC;
    }
    return nil;
}

- (void)restart {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)cancel {
    if (!self.fileExist) {
        [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.dataManager = nil;
    [self.lastToEndDownloader cancel];
    self.lastToEndDownloader = nil;
    for (XTDownloader *downloader in self.nonToEndDownloaderArray) {
        [downloader cancel];
    }
}

- (void)completeDealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [XTRangeManager completeDealloc];
    onceToken = 0;
    audioPlayer = nil;
}

#pragma mark - AVAssetResourceLoaderDelegate
/*!
 @method         resourceLoader:shouldWaitForLoadingOfRequestedResource:
 @abstract        应用需要帮助时被调用
 @param         resourceLoader
 //创建加载请求 AVAssetResourceLoader(资源加载器)的实例对象
 The instance of AVAssetResourceLoader for which the loading request is being made.
 @param         loadingRequest
 //提供请求资源的信息 AVAssetResourceLoadingRequest(加载请求)的实例对象
 An instance of AVAssetResourceLoadingRequest that provides information about the requested resource.
 //假如delegate通过AVAssetResourceLoadingRequest(加载请求)表明能够加载资源返回yes,否则返回no
 @result         YES if the delegate can load the resource indicated by the AVAssetResourceLoadingRequest; otherwise NO.
 @discussion
 //当应用需要帮助去加载一个资源的时候delegates接收到这个信息.例如:去加载一个特殊的自定义URL的schames时这个方法就会被唤醒
 Delegates receive this message when assistance is required of the application to load a resource. For example, this method is invoked to load decryption keys that have been specified using custom URL schemes.
 
 //如果结果为yes,资源加载器期望稍后或者立刻调用,调用 -[AVAssetResourceLoadingRequest finishLoading] 或者 -[AVAssetResourceLoadingRequest finishLoadingWithError:].处理这个信息的返回值后,如果你打算完成资源的加载,你必须retain AVAssetResourceLoadingRequest(加载请求)的实例对象直到加载完成
 If the result is YES, the resource loader expects invocation, either subsequently or immediately, of either -[AVAssetResourceLoadingRequest finishLoading] or -[AVAssetResourceLoadingRequest finishLoadingWithError:]. If you intend to finish loading the resource after your handling of this message returns, you must retain the instance of AVAssetResourceLoadingRequest until after loading is finished.
 
 //如果返回no,资源加载器就认为加载资源失败了
 If the result is NO, the resource loader treats the loading of the resource as having failed.
 
 // 注意:假如代理的回调方法 在没有立刻完成加载资源请求时 返回yes,在之前的请求完成之前这个方法可能会被别的加载请求再次调用;因此基于这种情况单例应该准备去管理多个请求
 Note that if the delegate's implementation of -resourceLoader:shouldWaitForLoadingOfRequestedResource: returns YES without finishing the loading request immediately, it may be invoked again with another loading request before the prior request is finished; therefore in such cases the delegate should be prepared to manage multiple loading requests.
 
 //假如AVURLAsset(url资源)被加到AVContentKeySession对象上并且设置了AVAssetResourceLoader(资源加载器)的代理,代理方法(resourceLoader:shouldWaitForLoadingOfRequestedResource:)必须指定哪一个自定义的URL请求需要被当做内容keys处理.通过返回yes处理,并且在-[AVAssetResourceLoadingContentInformationRequest setContentType:]方法里通过AVStreamingKeyDeliveryPersistentContentKeyType或者AVStreamingKeyDeliveryContentKeyType然后请求-[AVAssetResourceLoadingRequest finishLoading]方法.
 If an AVURLAsset is added to an AVContentKeySession object and a delegate is set on its AVAssetResourceLoader, that delegate's resourceLoader:shouldWaitForLoadingOfRequestedResource: method must specify which custom URL requests should be handled as content keys. This is done by returning YES and passing either AVStreamingKeyDeliveryPersistentContentKeyType or AVStreamingKeyDeliveryContentKeyType into -[AVAssetResourceLoadingContentInformationRequest setContentType:] and then calling -[AVAssetResourceLoadingRequest finishLoading].
 
 */
-(BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    [self handleLoadingRequest:loadingRequest];
    return YES;
}

#pragma mark - XTDataManagerDelegate
-(void)fileDownloadAndSaveSuccess{
    if (!self.fileExist) {
        self.fileCacheComplete = YES;
        if (self.playedToEnd) {
            [self playToEnd];
        }
    }
}

#pragma mark - 播放状态
-(void)playToEnd{
    
    self.playedToEnd = YES;
    if (!self.fileExist && !self.fileCacheComplete) {
        return;
    }

    [self cancel];
    if (self.playCompleteBlock) {
        self.playCompleteBlock(nil);
    }
    
    self.playedToEnd = NO;
    
}

-(void)failToEnd:(NSNotification *)noti{
    [self cancel];
    NSError *error = noti.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
    if (self.playCompleteBlock) {
        self.playCompleteBlock(error);
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.playbackBufferEmpty) {
            if ([self.delegate respondsToSelector:@selector(suspendForLoadingDataWithPlayer:)]) {
                self.buffering = YES;
                [self.delegate suspendForLoadingDataWithPlayer:self.player];
            }
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        if ([self.delegate respondsToSelector:@selector(activeToContinueWithPlayer:)] && self.buffering) {
            self.buffering = NO;
            [self.delegate activeToContinueWithPlayer:self.player];
        }
    }
}

#pragma mark - 逻辑方法
- (void)handleLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    NSLog(@"loadingRequest.dataRequest: %@", loadingRequest.dataRequest);
    //取消上一个requestsAllDataToEndOfResource的请求
    if (loadingRequest.dataRequest.requestsAllDataToEndOfResource) {// 所有数据请求完成
        if (self.lastToEndDownloader) {
            
            long long lastRequestedOffset = self.lastToEndDownloader.loadingRequest.dataRequest.requestedOffset;
            long long lastRequestedLength = self.lastToEndDownloader.loadingRequest.dataRequest.requestedLength;
            long long lastCurrentOffset = self.lastToEndDownloader.loadingRequest.dataRequest.currentOffset;
    
            //requested offset = 65536, requested length = 65536, requests all data to end of resource = NO, current offset = 65536>
            //requested offset = 131072, requested length = 65536, requests all data to end of resource = NO, current offset = 131072>
            //requested offset = 786432, requested length = 17007329, requests all data to end of resource = YES, current offset = 786432>
            long long currentRequestedOffset = loadingRequest.dataRequest.requestedOffset;// 距离当前请求第一个被请求的字节的距离
            long long currentRequestedLength = loadingRequest.dataRequest.requestedLength;// 该次请求数据的长度 65536 B = 64 KB
            long long currentCurrentOffset = loadingRequest.dataRequest.currentOffset;// 当前请求的数据距在总数据中的偏移量
            
            if (lastRequestedOffset == currentRequestedOffset && lastRequestedLength == currentRequestedLength && lastCurrentOffset == currentCurrentOffset) {
                return;//在弱网络情况下，下载文件最后部分时，会出现所请求数据完全一致的loadingRequest（且requestsAllDataToEndOfResource = YES），此时不应取消前一个与其相同的请求；否则会无限生成相同的请求范围的loadingRequest，无限取消，产生循环
            }
            [self.lastToEndDownloader cancel];
        }
    }
    
    XTRangeManager *rangeManager = [XTRangeManager shareRangeManager];
    //将当前loadingRequest根据本地是否已缓存拆分成本多个rangeModel
    NSMutableArray *rangeModelArray = [rangeManager calculateRangeModelArrayForLoadingRequest:loadingRequest];
    
    NSString *urlScheme = [NSURL URLWithString:self.originalUrlStr].scheme;
    //根据loadingRequest和rangeModel进行下载和数据回调
    XTDownloader *downloader = [[XTDownloader alloc] initWithLoadingRequest:loadingRequest RangeModelArray:rangeModelArray UrlScheme:urlScheme InDataManager:self.dataManager];
    
    if (loadingRequest.dataRequest.requestsAllDataToEndOfResource) {
        self.lastToEndDownloader = downloader;
    }else{
        if (!self.nonToEndDownloaderArray) {//对于不是requestsAllDataToEndOfResource的请求也要收集，在取消当前请求时要一并取消掉
            self.nonToEndDownloaderArray = [NSMutableArray array];
        }
        [self.nonToEndDownloaderArray addObject:downloader];
    }
    
}

#pragma mark - 工具方法
- (NSURL *)handleUrl:(NSString *)urlStr{
    
    if (!urlStr) {
        return nil;
    }
    
    NSURL *originalUrl = [NSURL URLWithString:urlStr];
    
    NSURL *useUrl = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:originalUrl.scheme withString:XTCustomScheme]];

    return useUrl;
}

@end
