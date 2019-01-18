//
//  CQButton.m
//  CQPayedDemo
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQButton.h"

@implementation CQButton

- (void)setFont:(CGFloat)font {
    _font = font;
    self.titleLabel.font = [UIFont systemFontOfSize:font];
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.titleLabel.textAlignment = textAlignment;
}

- (void)setHighlighted:(BOOL)highlighted {

}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.y = (self.height - self.imageView.height - self.titleLabel.height) * 0.5;
    self.imageView.x = (self.width - self.imageView.width) * 0.5;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.x = 0;
}

@end
