//
//  CQLoadPhoneNumber.h
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQPhoneNumModel.h"

@interface CQLoadPhoneNumber : NSObject

+ (instancetype)sharedInstance;

- (NSMutableArray *)loadUserPhoneNumber;

@end
