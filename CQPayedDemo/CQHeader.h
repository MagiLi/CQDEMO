//
//  CQHeader.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Frame.h"

#define kScreen_W [UIScreen mainScreen].bounds.size.width
#define kScreen_H [UIScreen mainScreen].bounds.size.height

#define kCurrent_Version [[UIDevice currentDevice].systemVersion floatValue]

#define ARRAY_CLIP @"<{|*|}>"
#define SUB_ARRAY_CLIP @"<{*|*}>"

extern NSString *const notification_CellBeganEditing;
extern NSString *const notification_CellStateChange;
