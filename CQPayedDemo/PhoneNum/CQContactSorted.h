//
//  CQContactSorted.h
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQContactSorted : NSObject
/*
 *  对数据排序 并且分组
 */
+ (NSMutableArray *)getSectionDataWithArray:(NSMutableArray *)array;

/*
 *  获取每一组首字母的索引
 */
+ (NSMutableArray *)getFirstAlphabetWithArray:(NSMutableArray *)array;
@end
