//
//  CQAFSessionManager.h
//  CQPayedDemo
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CQAFSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
