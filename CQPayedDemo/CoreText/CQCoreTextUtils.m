//
//  CQCoreTextUtils.m
//  Modal
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCoreTextUtils.h"
#import "CQCTFrameParserConfig.h"
#import "CQCoreTextImageData.h"

@implementation CQCoreTextUtils

+ (CQCoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CQCoreTextData *)data
{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) return nil;
    
    CFIndex count = CFArrayGetCount(lines);
    CQCoreTextLinkData *foundLink = nil;
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的rect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转化为相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), CGRectGetMinY(rect));
            // 获取当前点击坐标对应的字符串偏移量
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            // 判断偏移量是否在链接列表中
            foundLink = [self linkAtIndex:idx linkArray:data.linkArray];
            return foundLink;
        }
    }
    return nil;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y, width, height);
}

+ (CQCoreTextLinkData *)linkAtIndex:(CFIndex)index linkArray:(NSArray *)linkArray {
    CQCoreTextLinkData *link = nil;
    for (CQCoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(index, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}

+ (CGRect)praserRectInView:(UIView *)view atPoint:(CGPoint)point selectedRange:(NSRange *)selectedRange data:(CQCoreTextData *)data
{
    
    CFIndex index = -1;
    CFArrayRef lines = CTFrameGetLines(data.ctFrame);
    if (!lines) return CGRectZero;
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(data.ctFrame, CFRangeMake(0, 0), origins);

    // Y值向上为正（正常的坐标系）
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    CGRect flippedRect = CGRectZero; // 翻转后的坐标
    if (count) {
        for (int i = 0; i < count; i++) {
            CGPoint linePoint = origins[i]; // 每一行的起始位置
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            // 获得每一行的rect信息
            CGFloat ascent = 0.0f, descent = 0.0f, linegap = 0.0f;
            CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGFloat height = ascent + descent;
            CGRect tempRect = CGRectMake(linePoint.x, linePoint.y, width, height);
            CGRect rect = CGRectApplyAffineTransform(tempRect, transform); // 翻转坐标系  Y值向下为正
            if (CGRectContainsPoint(rect, point)) {
                CFRange stringRange = CTLineGetStringRange(line); // get current line's range
                // 将点击的坐标转化为相对于当前行的坐标
                CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect) - 8, CGRectGetMinY(rect));
                // 获取当前点击坐标对应的字符串偏移量
                index = CTLineGetStringIndexForPosition(line, relativePoint);
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL); // current line's offset of touch string
                
                CGFloat xEnd;
                //默认选中两个单位
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                    (*selectedRange).location = index-2;
                    
                }
                else{
                    xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                    (*selectedRange).location = index;
                }
                (*selectedRange).length = 2;
                
                flippedRect = CGRectMake(linePoint.x+xStart,linePoint.y-descent,fabs(xStart-xEnd), ascent+descent);
                NSArray *imgArray = data.imageArray;
                // 循环遍历是否选中了居中的图片
                for (CQCoreTextImageData *data in imgArray) {
                    if (data.imageAlignment && CGRectContainsPoint(flippedRect, data.imagePosition.origin)) {
                        CGFloat drawX = linePoint.x+xStart + (data.width - data.imagePosition.size.width) * 0.5 - 27;
                        flippedRect = CGRectMake(drawX,linePoint.y-descent+2,fabs(xStart-xEnd), ascent+descent);
                    }
                }
                break;
            }
        }
    }
    return flippedRect;
/************************** 方法二（不准确） ****************************/
/*
        CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    CGRect rect = CGRectZero;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return rect;
    }
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins); // copy line's origin
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i]; // get current line
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);  // get current line's width
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap+[CQCTFrameParserConfig sharedInstance].lineSpace);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){ // contains touch point
                CFRange stringRange = CTLineGetStringRange(line); // get current line's range
                CGPoint pointTemp = CGPointMake(point.x - 30, point.y);
                index = CTLineGetStringIndexForPosition(line, pointTemp); // stringIndex
                
                NSLog(@"%ld  =  %f /n %ld - %ld", index, point.x, stringRange.location,stringRange.length);
//                NSLog(@"%@", NSStringFromCGPoint(point));
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL); // current line's offset of touch string
                
                CGFloat xEnd;
                //默认选中两个单位
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                    (*selectedRange).location = index-2; 
                    
                }
                else{
                    xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                    (*selectedRange).location = index;
                }
                
                (*selectedRange).length = 2;
                rect = CGRectMake(origins[i].x+xStart,baselineOrigin.y-descent,fabs(xStart-xEnd), ascent+descent);
                
                break;
            }
        }
    }
    free(origins);
    return rect;
*/
}
+(NSArray *)parserRectsInView:(UIView *)view atPoint:(CGPoint)point range:(NSRange *)selectRange data:(CQCoreTextData *)data paths:(NSArray *)paths direction:(BOOL) direction
{
    CFIndex index = -1;
    CFArrayRef lines = CTFrameGetLines(data.ctFrame);
    NSMutableArray *muArr = [NSMutableArray array];
    CFIndex lineCount = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(data.ctFrame, CFRangeMake(0, 0), origins);
//    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    
    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);

    if (lineCount) {
        for (int i = 0; i < lineCount; i++) {
            CGPoint linePoint = origins[i];
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            // 获得每一行的rect信息
            CGFloat ascent, descent, linegap;
            CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGFloat height = ascent + descent;
            CGRect tempRect = CGRectMake(linePoint.x, linePoint.y, width, height);
            CGRect rect = CGRectApplyAffineTransform(tempRect, transform);
            if (CGRectContainsPoint(rect,point)){
                // 将点击的坐标转化为相对于当前行的坐标
                CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect) - 8, CGRectGetMinY(rect));
                index = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
            
        }
    }

//    index = [self parserIndexInView:view atPoint:point frameRef:frameRef];  // 获取当前文字的索引
    if (index == -1) {
        return paths;
    }
    if (direction) //从右侧滑动
    {
        if (!(index>(*selectRange).location)) { // 判断当前点是在选中区域的前面还是后面
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
        else{ // 后面
            (*selectRange).length = index-(*selectRange).location;
        }
    }
    else    //从左侧滑动
    {
        if (!(index>(*selectRange).location+(*selectRange).length)) {
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
    }

    for (int i = 0; i<lineCount; i++){
        CGPoint baselineOrigin = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
        CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
        CFRange stringRange = CTLineGetStringRange(line);
        NSRange drawRange = [self selectRange:NSMakeRange((*selectRange).location, (*selectRange).length) lineRange:NSMakeRange(stringRange.location, stringRange.length)];
        //            NSLog(@"\n drawRange = %lu - %lu ", (unsigned long)drawRange.location, (unsigned long)drawRange.length);
        if (drawRange.length) {
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
            
            CGRect rect = CGRectMake(xStart+baselineOrigin.x, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
            NSArray *imgArray = data.imageArray;
            // 循环遍历是否选中了居中的图片
            for (CQCoreTextImageData *data in imgArray) {
                if (data.imageAlignment && CGRectContainsPoint(rect, data.imagePosition.origin)) {
                    CGFloat drawX = baselineOrigin.x+xStart + (data.width - data.imagePosition.size.width) * 0.5 - 27;
                    rect = CGRectMake(drawX,baselineOrigin.y-descent+2,fabs(xStart-xEnd), ascent+descent);
                }
            }
            
            if (rect.size.width ==0 || rect.size.height == 0) {
                continue;
            }
            [muArr addObject:NSStringFromCGRect(rect)];
        }
    }
    
    return muArr;
}
+(CFIndex)parserIndexInView:(UIView *)view atPoint:(CGPoint)point frameRef:(CTFrameRef)frameRef
{
    CFIndex index = -1;
    CFArrayRef lines = CTFrameGetLines(frameRef);
    if (!lines) return index;
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);

    if (count) {
        for (int i = 0; i < count; i++) {
            CGPoint linePoint = origins[i];
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            // 获得每一行的rect信息
            CGFloat ascent = 0.0f, descent = 0.0f, linegap = 0.0f;
            CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGFloat height = ascent + descent;
            CGRect tempRect = CGRectMake(linePoint.x, linePoint.y, width, height);
            CGRect rect = CGRectApplyAffineTransform(tempRect, transform);
            if (CGRectContainsPoint(rect,point)){
                // 将点击的坐标转化为相对于当前行的坐标
                CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect) - 8, CGRectGetMinY(rect));
                index = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }

        }
    }
    return index;
/************************** 方法二（不准确） ****************************/
//    CFIndex index = -1;
//    CGPathRef pathRef = CTFrameGetPath(frameRef);
//    CGRect bounds = CGPathGetBoundingBox(pathRef);
//    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
//    if (!lines) {
//        return index;
//    }
//    NSInteger lineCount = [lines count];
//    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
//    if (lineCount) {
//        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
//        for (int i = 0; i<lineCount; i++) {
//            CGPoint baselineOrigin = origins[i];
//            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
//            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
//            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
//            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap+[CQCTFrameParserConfig sharedInstance].lineSpace);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
//            if (CGRectContainsPoint(lineFrame,point)){
//                index = CTLineGetStringIndexForPosition(line, point);
//                break;
//            }
//        }
//    }
//    free(origins);
//    return index;
    
}
+(NSRange)selectRange:(NSRange)selectRange lineRange:(NSRange)lineRange
{
    //    NSLog(@"\n selectRange = %lu - %lu \n lineRange = %lu - %lu", (unsigned long)selectRange.location, (unsigned long)selectRange.length, lineRange.location, lineRange.length);
    
    NSRange range = NSMakeRange(NSNotFound, 0);
    if (lineRange.location>selectRange.location) {
        NSRange tmp = lineRange;
        lineRange = selectRange;
        selectRange = tmp;
    }
    if (selectRange.location<lineRange.location+lineRange.length) {
        range.location = selectRange.location;
        NSUInteger end = MIN(selectRange.location+selectRange.length, lineRange.location+lineRange.length);
        range.length = end-range.location;
    }
    return range;
}

@end
