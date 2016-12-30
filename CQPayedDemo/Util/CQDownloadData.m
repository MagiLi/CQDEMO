//
//  CQDownloadData.m
//  CQPayedDemo
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQDownloadData.h"
#import "CQAFSessionManager.h"

@implementation CQDownloadData
//categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
+ (NSURLSessionDataTask *)getRecommendDataWithBlock:(void(^)(NSArray *array, NSError *error))Block andCategoryId:(NSInteger)categoryID andContentType:(NSString *)type {
    NSString *path = [NSString stringWithFormat:@"v2/category/recommends?categoryId=%d&contentType=%@&device=ios&scale=2&version=4.3.32.2", categoryID,type];
    return [[CQAFSessionManager sharedManager] GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (Block) {
            Block([NSArray array], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (Block) {
            Block([NSArray array], error);
        }
    }];
}
@end
