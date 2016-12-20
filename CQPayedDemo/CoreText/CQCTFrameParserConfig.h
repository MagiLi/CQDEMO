//
//  CQCTFrameParserConfig.h
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//
///************ http://blog.csdn.net/sinat_27706697/article/details/46270939 *************///

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CQCTFrameParserConfig : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *textColor;


@end
