//
//  CQDisplayView.h
//  Modal
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 wwdx. All rights reserved.
//
///************ http://blog.csdn.net/sinat_27706697/article/details/46270939 *************///

#import <UIKit/UIKit.h>
#import "CQCoreTextData.h"

extern NSString *const CQDisplayViewImagePressedNotification;
extern NSString *const CQDisplayViewLinkPressedNotification;

@interface CQDisplayView : UIView
@property (nonatomic,strong) CQCoreTextData *data;
@end
