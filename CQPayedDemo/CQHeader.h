//
//  CQHeader.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Frame.h"
#import "CQDownloadData.h"
#import "MJExtension.h"

#define Theme_Color [UIColor colorWithRed:237.0 / 255.0 green:170.0 / 255.0 blue:20.0 / 255.0 alpha:1.0]
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define kScreen_W [UIScreen mainScreen].bounds.size.width
#define kScreen_H [UIScreen mainScreen].bounds.size.height

#define kCurrent_Version [[UIDevice currentDevice].systemVersion floatValue]

#define ARRAY_CLIP @"<{|*|}>"
#define SUB_ARRAY_CLIP @"<{*|*}>"

extern NSString *const notification_CellBeganEditing;
extern NSString *const notification_CellStateChange;
