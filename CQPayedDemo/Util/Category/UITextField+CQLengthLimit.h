//
//  UITextField+CQLengthLimit.h
//  CQPayedDemo
//
//  Created by 李超群 on 2019/8/10.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TextLengthMoreThanBlock)(void);

@interface UITextField (CQLengthLimit)
/** 输入限制长度  */
@property (nonatomic, strong) NSNumber *limitLength;

/** 输入长度超过限制回调 */
@property (nonatomic, copy) TextLengthMoreThanBlock lenghtBlock;

@end

NS_ASSUME_NONNULL_END
