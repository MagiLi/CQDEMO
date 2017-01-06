//
//  CQSongListHeadView.m
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQSongListHeadView.h"

@interface CQSongListHeadView ()
@property(nonatomic,strong)UIImageView *iconBigView;
@property(nonatomic,strong)UIImageView *iconSmallView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *descLab;


@end

@implementation CQSongListHeadView

- (void)setModel:(CQAlbum *)model {
    _model = model;
    [self.iconSmallView sd_setImageWithURL:[NSURL URLWithString:model.coverSmall] placeholderImage:[UIImage imageNamed:@"UMS_qzone_icon"]];
    [self.iconBigView sd_setImageWithURL:[NSURL URLWithString:model.coverOrigin] placeholderImage:[UIImage imageNamed:@"UMS_qzone_icon"]];
    self.titleLab.text = model.nickname;
    self.descLab.text = model.intro;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.iconBigView];
        [self addSubview:self.iconSmallView];
        [self addSubview:self.titleLab];
        [self addSubview:self.descLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat marginX = 20.0;
    CGFloat iconBigH = 100.0;
    CGFloat iconBigY = (self.height - iconBigH) * 0.5;
    self.iconBigView.frame = CGRectMake(marginX, iconBigY, iconBigH, iconBigH);
    
    CGFloat iconSmallX = marginX + iconBigH + 10.0;
    CGFloat iconSmallW = 40.0;
    self.iconSmallView.frame = CGRectMake(iconSmallX , self.iconBigView.y, iconSmallW, iconSmallW);
    self.iconSmallView.layer.cornerRadius = iconSmallW * 0.5;
    
    CGFloat titleLabX = CGRectGetMaxX(self.iconSmallView.frame) + 5.0;
    self.titleLab.frame = CGRectMake(titleLabX, self.iconSmallView.y, self.width - titleLabX - 10.0, iconSmallW);
    
    self.descLab.frame = CGRectMake(iconSmallX, CGRectGetMaxY(self.iconSmallView.frame), self.width - iconSmallX - 10.0, 60.0);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    }
    return _imageView;
}
- (UIImageView *)iconBigView {
    if (!_iconBigView) {
        _iconBigView = [[UIImageView alloc] init];
    }
    return _iconBigView;
}
- (UIImageView *)iconSmallView {
    if (!_iconSmallView) {
        _iconSmallView = [[UIImageView alloc] init];
    }
    return _iconSmallView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 2.0;
    }
    return _titleLab;
}
- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        _descLab.numberOfLines = 4.0;
        _descLab.textColor = [UIColor whiteColor];
        _descLab.font = [UIFont systemFontOfSize:13.0];
    }
    return _descLab;
}

@end
