//
//  CQContentLayoutModel.h
//  CQPayedDemo
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQBaseLayoutModel.h"
#import "CQContentModel.h"

@interface CQContentLayoutModel : CQBaseLayoutModel

@property(nonatomic,strong)CQContentModel *model;

@property(nonatomic,assign)NSUInteger section;// 组数
@property(nonatomic,strong)NSArray<NSString *> *sectionTitle; // 组的标题
/**  获取组的title */
- (NSString *)mainTitleForSection:(NSInteger)section;
/**  通过分组数, 获取行数 */
- (NSUInteger)rowForSection:(NSUInteger)section;
/**  通过分组数和行数(IndexPath), 获取图标 */
- (NSURL *)coverURLForIndexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithCategoryID:(NSInteger)categoryID contentType:(NSString *)type;
@end
