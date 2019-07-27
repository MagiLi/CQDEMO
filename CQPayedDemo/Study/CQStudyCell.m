//
//  CQStudyCell.m
//  CQPayedDemo
//
//  Created by 李超群 on 2019/7/27.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQStudyCell.h"

@implementation CQStudyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(15.0, 0.0, self.width, self.height);
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor redColor];
    }
    return _titleLab;
}
@end
