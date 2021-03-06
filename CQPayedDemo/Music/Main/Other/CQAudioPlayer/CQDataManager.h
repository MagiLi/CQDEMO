//
//  CQDataManager.h
//  LoadingAndSinging
//
//  Created by XTShow on 2018/2/13.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CQDataManagerDelegate<NSObject>

@optional
-(void)fileDownloadAndSaveSuccess;

@end

@interface CQDataManager : NSObject

@property (nonatomic,weak) id<CQDataManagerDelegate> delegate;

@property (nonatomic,assign) NSUInteger contentLength;

- (instancetype _Nullable)initWithUrlStr:(nonnull NSString *)urlStr cachePath:(nullable NSString *)cachePath;
NS_ASSUME_NONNULL_BEGIN
+ (NSString *)checkCachedWithUrl:(NSString *)urlStr;
+ (NSString *)checkCachedWithFilePath:(NSString *)filePath;
- (void)addCacheData:(NSData *)data ForRange:(NSRange)range;
- (NSData *)readCacheDataInRange:(NSRange)range;
NS_ASSUME_NONNULL_END
@end
