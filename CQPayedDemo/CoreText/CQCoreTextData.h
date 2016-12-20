//
//  CQCoreTextData.h
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//
///************ http://blog.csdn.net/sinat_27706697/article/details/46270939 *************///

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CQCoreTextData : NSObject

@property (nonatomic,assign) CTFrameRef ctFrame;
@property (nonatomic,assign) CGFloat height;

@property(nonatomic,strong)NSArray *imageArray;  // 图片
@property (nonatomic,strong) NSArray *linkArray; // 链接
@end
