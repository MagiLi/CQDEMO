//
//  CQEllipsisLabel.h
//  CQPayedDemo
//
//  Created by 李超群 on 2019/8/23.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQEllipsisLabel : UIView

@property (nonatomic, assign) NSUInteger numberOfLines;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) NSInteger lineSpace;
@property (nonatomic) NSTextAlignment textAlignment;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
