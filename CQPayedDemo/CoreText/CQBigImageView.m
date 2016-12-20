//
//  CQBigImageView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQBigImageView.h"
#import "CQHeader.h"

@interface CQBigImageView ()
@property(nonatomic,assign)CGRect originFrame;
@property(nonatomic,weak)UIImageView *imgView;
@end

@implementation CQBigImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.originFrame = self.frame;
        [self addSubViews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImg:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)addSubViews {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.originFrame.size.width, self.originFrame.size.height)];
    self.imgView = imgView;
    [self addSubview:imgView];
}

- (void)setImgStr:(NSString *)imgStr {
    _imgStr = imgStr;
    self.imgView.image = [UIImage imageNamed:imgStr];
}

- (void)beginAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, kScreen_W, kScreen_H);
        CGFloat x = 10.0;
        CGFloat w = kScreen_W - x * 2.0;
        CGFloat h = self.originFrame.size.height / self.originFrame.size.width * w;
        CGFloat y = (kScreen_H - h)*0.5;
        self.imgView.frame = CGRectMake(x, y, w, h);
    }];
}

- (void)hiddenImg:(UITapGestureRecognizer *)tapGesture
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.2f;
        self.frame = self.originFrame;
        self.imgView.frame = CGRectMake(0, 0, self.originFrame.size.width, self.originFrame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
