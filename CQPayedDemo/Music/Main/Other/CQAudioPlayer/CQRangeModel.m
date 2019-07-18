//
//  CQRangeModel.m
//  LoadingAndSinging
//
//  Created by XTShow on 2018/2/13.
//  Copyright © 2018年 XTShow. All rights reserved.
//

#import "CQRangeModel.h"

@implementation CQRangeModel
- (instancetype)initWithRequestType:(CQRangeModelRequestType)requestType RequestRange:(NSRange)requestRange
{
    self = [super init];
    if (self) {
        _requestType = requestType;
        _requestRange = requestRange;
    }
    return self;
}

@end
