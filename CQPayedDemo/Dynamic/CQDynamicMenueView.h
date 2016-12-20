//
//  CQDynamicMenueView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/14.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQDynamicMenueView : UIView
- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images;
@end
