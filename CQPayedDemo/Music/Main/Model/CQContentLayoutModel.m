//
//  CQContentLayoutModel.m
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQContentLayoutModel.h"

@interface CQContentLayoutModel ()
@property(nonatomic,assign)NSInteger categoryID;
@property(nonatomic,copy)NSString *type;
@end

@implementation CQContentLayoutModel
- (instancetype)initWithCategoryID:(NSInteger)categoryID contentType:(NSString *)type {
    self = [super init];
    if (self) {
        self.categoryID = categoryID;
        self.type = type;
    }
    return self;
}

#pragma mark -
#pragma mark - 获取数据
- (void)getMoreDataCompletionHandle:(void (^)(NSError *))completed {
    __weak typeof(self) weakSelf = self;
    [CQDownloadData getRecommendDataWithBlock:^(NSArray *array, NSError *error) {
        weakSelf.model = [array firstObject];
        if (completed) {
            completed(error);
        }
    } andCategoryId:self.categoryID andContentType:self.type];
}

- (NSUInteger)section {
    return self.model.categoryContents.list.count;
}

- (NSString *)mainTitleForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].title;
}

- (NSUInteger)rowForSection:(NSUInteger)section {
    return [self.model.categoryContents.list[section].list count];
}
- (NSURL *)coverURLForIndexPath:(NSIndexPath *)indexPath {
    NSString *path = nil;
    if (indexPath.section == 0) {
        path =  self.model.categoryContents.list[indexPath.section].list[indexPath.row].coverPath;
    } else {
        path = self.model.categoryContents.list[indexPath.section].list[indexPath.row].coverMiddle;
    }
    return [NSURL URLWithString:path];
}
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    return self.model.categoryContents.list[indexPath.section].list[indexPath.row].title;
}

// 获取组的标题
- (NSArray<NSString *> *)sectionTitle {
    if (!_sectionTitle) {
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = self.model.tags.list;
        for (CQContentTags_List *model in array) {
            [arrayM addObject:model.tname];
        }
        _sectionTitle = arrayM.copy;
    }
    return _sectionTitle;
}

@end
