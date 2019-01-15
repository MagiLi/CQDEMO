//
//  CQHeader.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Frame.h"
#import "UIImageView+AFNetWorking.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CQDownloadData.h"
#import "CQAnimationManager.h"
#import "CQPlayerManager.h"
#import "MJExtension.h"

#define ThemeColor_Left CQColorFromRGB(0xFFAB00)//渐变色左侧
#define ThemeColor_Right CQColorFromRGB(0xFF7D01)// 渐变色右侧
//#define ThemeColor     CQColorFromRGB(0xFF7D01)
#define ThemeGrayColor     CQColorFromRGB(188.0,188.0,188.0)
#define ThemePlaceholderBGColor     CQColorFromRGB(239.0,223.0,201.0)
#define ThemeBackgroundColor     CQColorFromRGB(0xF6F6F6)
#define Theme_Color CQColorFromRGB(0xFF7D01)
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define CQColorFromRGB(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kScreen_W [UIScreen mainScreen].bounds.size.width
#define kScreen_H [UIScreen mainScreen].bounds.size.height
#define kBar_H 49.0
#define kNav_H 64.0

#define kCurrent_Version [[UIDevice currentDevice].systemVersion floatValue]

#define ARRAY_CLIP @"<{|*|}>"
#define SUB_ARRAY_CLIP @"<{*|*}>"

#ifdef DEBUG

#define CQLog(...) NSLog(@"%s %d \n %@ \n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])

#else

#define CQLog(...)

#endif

extern NSString *const notification_CellBeganEditing;
extern NSString *const notification_CellStateChange;
extern NSString *const notification_BeginPlay;
