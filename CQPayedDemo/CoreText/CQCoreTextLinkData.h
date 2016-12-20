//
//  CQCoreTextLinkData.h
//  Modal
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQCoreTextLinkData : NSObject
/* 文字标题 */
@property (nonatomic,copy) NSString *title;
/* 链接url */
@property (nonatomic,copy) NSString *url;
/* 文字所在的区域 */
@property (nonatomic,assign) NSRange range;
@end
