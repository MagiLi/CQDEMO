//
//  NSString+CQUtil.h
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CQUtil)

/*
 *  汉语拼音
 */

- (NSString *)chinesePhoneticAlphabet;


///  拼接文档目录
- (NSString *)appendDocumentDir;

///  拼接缓存目录
- (NSString *)appendCacheDir;

///  拼接临时目录
- (NSString *)appendTmpDir;
@end
