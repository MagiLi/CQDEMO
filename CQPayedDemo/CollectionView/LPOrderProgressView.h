//
//  LPOrderProgressView.h
//  LPYProjrect
//
//  Created by Mac on 2018/12/26.
//  Copyright © 2018 LvPai Culture. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPOrderProgressViewDelegate <NSObject>
- (void)titleButtonClickedEvent:(UIButton *)sender;
@end

@interface LPOrderProgressView : UIView
@property (nonatomic, assign) id<LPOrderProgressViewDelegate> delegate;
@property (nonatomic, strong) UIColor *bgColor;
- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr highlightColor:(UIColor *)highlightColor normalColor:(UIColor *)normalColor radius:(CGFloat)radius roundIndex:(NSInteger)roundIndex;
- (void)setCurrentRoundIndex:(NSInteger)roundIndex;
@end

NS_ASSUME_NONNULL_END
