//
//  CQContentModel.h
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQBaseModel.h"
@class CQContentTags, CQContentTags_List, CQFocusImages, CQFocusimages_List, CQCategorycontents, CQCategorycontents_List;

@interface CQContentModel : CQBaseModel
@property (nonatomic, strong) CQContentTags *tags;
@property (nonatomic, strong) CQCategorycontents *categoryContents;
@property (nonatomic, assign) BOOL hasRecommendedZones;
@property (nonatomic, strong) CQFocusImages *focusImages;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger ret;
@end

@interface CQFocusImages : CQBaseModel
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CQFocusimages_List *> *list;
@end

@interface CQFocusimages_List : CQBaseModel
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *shortTitle;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, assign) BOOL is_External_url;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *longTitle;
@end

@interface CQCategorycontents : CQBaseModel
@property (nonatomic, assign) NSInteger ret;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CQCategorycontents_List *> *list;
@end

@interface CQCategorycontents_List : CQBaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CQCategorycontents_List *> *list;
@property (nonatomic, assign) NSInteger moduleType;
@property (nonatomic, assign) BOOL hasMore;

// 推荐类多了这几个属性
@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,strong) NSString *calcDimension;
@property (nonatomic,strong) NSString *tagName;
@end

@interface CQContentTags : CQBaseModel
@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray<CQContentTags_List *> *list;
@end

@interface CQContentTags_List : CQBaseModel
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, assign) NSInteger category_id;
@end
