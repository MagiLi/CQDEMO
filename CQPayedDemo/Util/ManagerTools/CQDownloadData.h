//
//  CQDownloadData.h
//  CQPayedDemo
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQDownloadData : NSObject
// 内容推荐数据
+ (NSURLSessionDataTask *)getRecommendDataWithBlock:(void(^)(NSArray *array, NSError *error))Block andCategoryId:(NSInteger)categoryID andContentType:(NSString *)type;
// 歌曲列表
+ (NSURLSessionDataTask *)getSongDataWithBlock:(void(^)(NSArray *array, NSError *error))Block andAlbumId:(NSInteger)albumID andTitle:(NSString *)title andAsc:(BOOL)asc;
@end
