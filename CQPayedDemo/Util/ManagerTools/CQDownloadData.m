//
//  CQDownloadData.m
//  CQPayedDemo
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQDownloadData.h"
#import "CQAFSessionManager.h"
#import "CQContentModel.h"
#import "CQSongModel.h"

@implementation CQDownloadData
//discovery/v2/category/recommends?categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
+ (NSURLSessionDataTask *)getRecommendDataWithBlock:(void(^)(NSArray *array, NSError *error))Block andCategoryId:(NSInteger)categoryID andContentType:(NSString *)type {
    NSString *path = [NSString stringWithFormat:@"discovery/v2/category/recommends?categoryId=%ld&contentType=%@&device=ios&scale=2&version=4.3.32.2", (long)categoryID,type];
    return [[CQAFSessionManager sharedManager] GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CQContentModel *model = [CQContentModel mj_objectWithKeyValues:responseObject];
        if (Block) {
            Block([NSArray arrayWithObject:model], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Block) {
            Block([NSArray array], error);
        }
    }];
}
//others/ca/album/track/2758446/true/1/20?position=1&albumId=2758446&isAsc=true&device=android&title=%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90&pageSize=20
+ (NSURLSessionDataTask *)getSongDataWithBlock:(void(^)(NSArray *array, NSError *error))Block andAlbumId:(NSInteger)albumID andTitle:(NSString *)title andAsc:(BOOL)asc {
    NSString *stringUtf8 = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"others/ca/album/track/%d/true/1/20?position=1&albumId=%d&isAsc=%d&device=ios&title=%@", albumID, albumID, asc, stringUtf8];
//    NSDictionary *parameters = @{@"albumId": @(albumID), @"title": title, @"isAsc": @(asc), @"device": @"ios", @"position": @1};
//    NSString *path = [NSString stringWithFormat:@"others/ca/album/track/%ld/true/1/20",(long)albumID];
    return [[CQAFSessionManager sharedManager] GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CQSongModel *model = [CQSongModel mj_objectWithKeyValues:responseObject];
        if (Block) {
            Block([NSArray arrayWithObject:model], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Block) {
            Block([NSArray array], error);
        }
    }];
}
@end
