//
//  CQContentLayoutModel.h
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQBaseLayoutModel.h"


@class CQContentModel;
@interface CQContentLayoutModel : CQBaseLayoutModel

@property(nonatomic,assign)NSUInteger section;// 组数
@property(nonatomic,strong)NSArray<NSString *> *sectionTitle; // 组的标题
/**  获取组的title */
- (NSString *)mainTitleForSection:(NSInteger)section;
/**  通过分组数, 获取行数 */
- (NSUInteger)rowForSection:(NSUInteger)section;

- (instancetype)initWithCategoryID:(NSInteger)categoryID contentType:(NSString *)type;
@end
