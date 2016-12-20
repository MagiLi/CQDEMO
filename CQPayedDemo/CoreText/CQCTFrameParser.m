//
//  CQCTFrameParser.m
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCTFrameParser.h"

static CGFloat ascentCallback(void * __nullable refCon) {
    
    CGFloat height = [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:@"height"] floatValue];
    
    NSLog(@"height: %f", height);
    return height;
}

static CGFloat descentCallback(void * __nullable refCon) {
    return 0;
}

static CGFloat widthCallback(void * __nullable refCon) {
    
    CGFloat width = [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:@"width"] floatValue];
    NSLog(@"width: %f", width);
    return width;
}

@implementation CQCTFrameParser

#pragma mark -
#pragma mark - 对整段文字进行排版

+ (CQCoreTextData *)parseContent:(NSString *)content config:(CQCTFrameParserConfig *)config
{
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
    return [self parseAttributedContent:contentString config:config];
}
#pragma mark -
#pragma mark - 设置文字样式
+ (NSDictionary *)attributesWithConfig:(CQCTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    
    const CFIndex kNumberOfSettings = 5;
    CTTextAlignment alignment = kCTTextAlignmentJustified; // 对齐方式
    CGFloat fristlineindent = 25.0f; // 首行缩进
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&alignment},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(CGFloat),&fristlineindent}
    };
//    对齐方式
//    CTParagraphStyleSetting paragraphStyle;
//    paragraphStyle.spec = kCTParagraphStyleSpecifierAlignment;
//    paragraphStyle.valueSize = sizeof(alignment);
//    paragraphStyle.value = &alignment;
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)config.textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}
#pragma mark -
#pragma mark - 获取CQCoreTextData
+ (CQCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CQCTFrameParserConfig *)config {
    // 创建CTFramesetterRef实例  注意：此方法自动回调callback
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    // 获得要绘制区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的绘制高度保存到CoreTextData实例中，并返回
    CQCoreTextData *data = [[CQCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 内存释放
    CFRelease(frame);
    CFRelease(framesetter);
    
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CQCTFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

#pragma mark -
#pragma mark - 自定义自己的排版

+ (CQCoreTextData *)parseTemplateFile:(NSString *)path config:(CQCTFrameParserConfig *)config
{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    // 1.获取属性字符串
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    // 2.根据属性字符串获取 CQCoreTextData
    CQCoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}
#pragma mark -
#pragma mark - 获取属性字符串
+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(CQCTFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray  linkArray:(NSMutableArray *)linkArray {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    // JSON方式获取数据
    //        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    if (array) {
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]) {
                    CQCoreTextImageData *imageData = [[CQCoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.imageAlignment = [dict[@"width"] floatValue] > 100.0;
                    imageData.width = config.width;
                    // 占位字符所在的位置
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"link"]) {
                
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                    // 创建CoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    
                    CQCoreTextLinkData *linkData = [[CQCoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    return result;
}
#pragma mark -
#pragma mark - 添加callback
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(CQCTFrameParserConfig *)config {
    CTRunDelegateCallbacks callbacks;
    // memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    // dict：回调的参数
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    // 使用0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
//    NSDictionary *attributes = [self attributesWithConfig:config];
    if ([dict[@"width"] floatValue] > 100.0) { // 是否居中展示
        NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", content]];
//        NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", content] attributes:attributes];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(1, 1), kCTRunDelegateAttributeName, delegate);
        CFRelease(delegate);
        return space;
    }
    else {
        NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content];
//        NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
        CFRelease(delegate);
        return space;
    }
    
}
#pragma mark -
#pragma mark - 设置文字的属性
+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(CQCTFrameParserConfig *)config {
    
    NSMutableDictionary *attributes = (NSMutableDictionary *)[self attributesWithConfig:config];
    
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    if ([dict[@"type"] isEqualToString:@"link"]) {
        // 设置文字下滑线及颜色
        attributes[(id)kCTUnderlineStyleAttributeName] = (id)[NSNumber numberWithInt:kCTUnderlineStyleSingle];
        UIColor *color = [self colorFromTemplate:dict[@"color"]];
        attributes[(id)kCTUnderlineColorAttributeName] = (id)color.CGColor;
    }
    
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
    
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    } else {
        return [UIColor lightGrayColor];
    }
}

@end
