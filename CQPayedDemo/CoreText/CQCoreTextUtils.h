//
//  CQCoreTextUtils.h
//  Modal
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQCoreTextLinkData.h"
#import "CQCoreTextData.h"




@interface CQCoreTextUtils : NSObject

///****** 用来判断是否点击文字链接 *********///
+ (CQCoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CQCoreTextData *)data;


/*
 * 选中文字区域范围
 * return 选中区域
 */
+ (CGRect)praserRectInView:(UIView *)view atPoint:(CGPoint)point selectedRange:(NSRange *)selectedRange data:(CQCoreTextData *)data;

/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域的集合
 *  @direction 滑动方向 (0 -- 从左侧滑动 1-- 从右侧滑动)
 */
+(NSArray *)parserRectsInView:(UIView *)view atPoint:(CGPoint)point range:(NSRange *)selectRange data:(CQCoreTextData *)data paths:(NSArray *)paths direction:(BOOL) direction;
@end
