//
//  CQCoreTextImageData.h
//  Modal
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQCoreTextImageData : NSObject

@property(nonatomic,assign)BOOL imageAlignment;

@property(nonatomic,assign)CGFloat width; // 内容的最大宽度

@property (nonatomic,copy) NSString *name;
// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic,assign) CGRect imagePosition;

@property (nonatomic,assign) CGRect frame;
@property(nonatomic,assign)NSUInteger position;

@end
