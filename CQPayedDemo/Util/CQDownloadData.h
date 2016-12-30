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
@end
