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

- (NSString *)appendDocumentDir
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}
- (NSString *)appendCacheDir
{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return [dir stringByAppendingString:self.lastPathComponent];
    
}
- (NSString *)appendTmpDir
{
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}
@end
