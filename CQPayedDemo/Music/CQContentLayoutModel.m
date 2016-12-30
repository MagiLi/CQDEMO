//
//  CQContentLayoutModel.m
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQContentLayoutModel.h"
#import "CQContentModel.h"

@interface CQContentLayoutModel ()
@property(nonatomic,assign)NSInteger categoryID;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)CQContentModel *model;
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
