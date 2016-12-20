//
//  CQContactSorted.m
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQContactSorted.h"
#import "CQPhoneNumModel.h"

@implementation CQContactSorted

+ (NSMutableArray *)getSectionDataWithArray:(NSMutableArray *)array {
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(CQPhoneNumModel *obj1, CQPhoneNumModel *obj2) {//排序
        // 一、排序
        NSString *strA = obj1.nameAlphabet;
        NSString *strB = obj2.nameAlphabet;
        for (int i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending; // 上升
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending; // 下降
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    
    // 二、分组
    char lastC = '1';
    NSMutableArray *data; // 正常的数据
    NSMutableArray *oth = [[NSMutableArray alloc] init]; // 不是英文字母
    NSMutableArray *cares = [[NSMutableArray alloc] init]; // 置顶
    for (CQPhoneNumModel *user in serializeArray) {
        char c = [user.nameAlphabet characterAtIndex:0];
//        if ([user.isTop boolValue]) {
//            [cares addObject:user];
//        }
        if (!isalpha(c)) {// isalpha是否是英文字母
            [oth addObject:user];
        }
        else if (c != lastC){ // 首字母不一样 加到新的数组里
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else { // 首字母一样 加到同一个数组里
            [data addObject:user];
        }
    }
    // 1.先添加特别关注
    if (cares.count > 0) {
        if (ans.count > 0) {
            [ans insertObject:cares atIndex:0];
        }
    }
    // 2.英文字母
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    // 3.其他字符
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}

+ (NSMutableArray *)getFirstAlphabetWithArray:(NSMutableArray *)array {
    NSMutableArray *sectionIndex = [[NSMutableArray alloc] init];
    for (NSArray *item in array) {
        CQPhoneNumModel *model = [item objectAtIndex:0];
//        if ([model.isTop boolValue]) {
//            [sectionIndex addObject:@"♡"];
//            continue;
//        }
        char c = [model.nameAlphabet characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [sectionIndex addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return sectionIndex;
}

@end
