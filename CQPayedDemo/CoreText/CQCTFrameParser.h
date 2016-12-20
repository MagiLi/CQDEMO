//
//  CQCTFrameParser.h
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//
///************ http://blog.csdn.net/sinat_27706697/article/details/46270939 *************///

#import <Foundation/Foundation.h>
#import "CQCoreTextData.h"
#import "CQCTFrameParserConfig.h"
#import "CQCoreTextImageData.h"
#import "CQCoreTextLinkData.h"

@interface CQCTFrameParser : NSObject
/* 对整段文字进行排版 */
+ (CQCoreTextData *)parseContent:(NSString *)content config:(CQCTFrameParserConfig *)config;

/* 自定义自己的排版 */
+ (CQCoreTextData *)parseTemplateFile:(NSString *)path config:(CQCTFrameParserConfig *)config;
@end
