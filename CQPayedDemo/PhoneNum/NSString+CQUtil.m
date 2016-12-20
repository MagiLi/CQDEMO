//
//  NSString+CQUtil.m
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "NSString+CQUtil.h"

@implementation NSString (CQUtil)

- (NSString *)chinesePhoneticAlphabet{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

@end
