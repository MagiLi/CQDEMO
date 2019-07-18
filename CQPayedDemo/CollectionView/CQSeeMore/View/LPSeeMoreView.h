//
//  LPSeeMoreView.h
//  LPYProjrect
//
//  Created by Mac on 2019/2/27.
//  Copyright © 2019 LvPai Culture. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SeeMoreLabel_Right 30.0
#define MarginTop 5.0

NS_ASSUME_NONNULL_BEGIN

@interface LPSeeMoreView : UIView
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat minWidth;// 查看更多view最小的width
@property (nonatomic, assign) CGFloat maxWidth;// 查看更多view最大的width
@end

NS_ASSUME_NONNULL_END
