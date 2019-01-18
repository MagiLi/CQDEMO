//
//  CQRangeModel.h
//  LoadingAndSinging
//
//  Created by CQShow on 2018/2/13.
//  Copyright © 2018年 CQShow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CQRangeModelRequestType) {
    CQRequestFromCache = 0,
    CQRequestFromNet = 1
};

@interface CQRangeModel : NSObject

@property (nonatomic,readonly,assign) CQRangeModelRequestType requestType;
@property (nonatomic,readonly,assign) NSRange requestRange;

- (instancetype)initWithRequestType:(CQRangeModelRequestType)requestType RequestRange:(NSRange)requestRange;

@end
