//
//  CQAppsModel.h
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ServeButtonState) {
    ServeButtonNormal   = 0,
    ServeButtonSelected = 1
};

@interface CQAppsModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)ServeButtonState buttonState;

@end
