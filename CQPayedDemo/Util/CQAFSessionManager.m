//
//  CQAFSessionManager.m
//  CQPayedDemo
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAFSessionManager.h"

@implementation CQAFSessionManager

+ (instancetype)sharedManager {
    
    static CQAFSessionManager *sessionManager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:kBaseURL_Path];
        sessionManager = [[CQAFSessionManager alloc] initWithBaseURL:url];
        sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/javascript", nil];
    });
    return sessionManager;
}
@end
