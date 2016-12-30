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

@implementation CQDownloadData
//categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
+ (NSURLSessionDataTask *)getRecommendDataWithBlock:(void(^)(NSArray *array, NSError *error))Block andCategoryId:(NSInteger)categoryID andContentType:(NSString *)type {
    NSString *path = [NSString stringWithFormat:@"v2/category/recommends?categoryId=%ld&contentType=%@&device=ios&scale=2&version=4.3.32.2", (long)categoryID,type];
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
@end
