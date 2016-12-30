//
//  CQContentModel.m
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQContentModel.h"

@implementation CQContentModel
@end

@implementation CQFocusImages
+ (NSDictionary *)objectClassInArray {
    return @{@"list" : [CQFocusimages_List class]};
}
@end

@implementation CQFocusimages_List
@end

@implementation CQCategorycontents
+ (NSDictionary *)objectClassInArray {
    return @{@"list" : [CQCategorycontents_List class]};
}
@end

@implementation CQCategorycontents_List
+ (NSDictionary *)objectClassInArray {
    return @{@"list" : [CQCategorycontents_List class]};
}
@end

@implementation CQContentTags
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CQContentTags_List class]};
}
@end

@implementation CQContentTags_List
@end
