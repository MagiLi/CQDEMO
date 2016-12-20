//
//  CQCTFrameParserConfig.m
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCTFrameParserConfig.h"

#define RGB(A,B,C) [UIColor colorWithRed:(A/255.0) green:(B/255.0) blue:(C/255.0) alpha:1.0]

@interface CQCTFrameParserConfig ()

@end

@implementation CQCTFrameParserConfig

+ (instancetype)sharedInstance
{
    static CQCTFrameParserConfig *parserConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parserConfig = [[self alloc] init];
    });
    return parserConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        self.width = [UIScreen mainScreen].bounds.size.width;
        self.fontSize = 16.0f;
        self.lineSpace = 8.0f;
        self.textColor = RGB(108, 108, 108);
    }
    return  self;
}


@end
