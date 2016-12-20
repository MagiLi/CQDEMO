//
//  CQCoreTextData.m
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCoreTextData.h"
#import "CQCoreTextImageData.h"


@interface CQCoreTextData ()

@end

@implementation CQCoreTextData

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self fillImagePosition];
}

- (void)fillImagePosition {
    if (self.imageArray.count == 0) return;
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = lines.count;
    // 每行的起始坐标
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imageIndex = 0;
    CQCoreTextImageData *imageData = self.imageArray[0];
    for (int i = 0; i < lineCount; i++) {
        if (!imageData) break;
        
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        NSArray *runObjectArray = (NSArray *)CTLineGetGlyphRuns(line);
        
//        CFArrayRef runs = CTLineGetGlyphRuns(line);
//        CFIndex runCount = CFArrayGetCount(runs);
//        CTRunRef run = CFArrayGetValueAtIndex(runs, k);
        
        for (id runObject in runObjectArray) {
            CTRunRef run = (__bridge CTRunRef)(runObject);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes valueForKey:(id)kCTRunDelegateAttributeName]);
            // 如果delegate是空，表明不是图片
            if (!delegate) continue;
            
            NSDictionary *metaDict = CTRunDelegateGetRefCon(delegate);
            if (![metaDict isKindOfClass:[NSDictionary class]]) continue;
            
            /* 确定图片run的frame */
            CGRect runBounds;
            CGFloat ascent=10,descent=10;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); // 得到run的width
            runBounds.size.height = ascent + descent;
//            NSLog(@"width: %f  height: %f", runBounds.size.width, runBounds.size.height);
            // 计算出图片相对于每行起始位置x方向上面的偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            
            if (imageData.imageAlignment) {
                runBounds.origin.x = (imageData.width - runBounds.size.width) * 0.5; // 图片居中展示
            }
            else {
                runBounds.origin.x = lineOrigins[i].x + xOffset;
            }
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            imageData.imagePosition = runBounds;
            imageIndex++;
            if (imageIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imageIndex];
            }
        }
    }
}

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if(_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

@end
