//
//  CQBaseLayoutModel.h
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CQBaseLayoutModelDelegate <NSObject>

/** 获取更多 */
- (void)getMoreDataCompletionHandle:(void(^)(NSError *error))completed;

@end

@interface CQBaseLayoutModel : NSObject<CQBaseLayoutModelDelegate>

@end
