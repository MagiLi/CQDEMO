//
//  CQTableViewCell.m
//  CQPayedDemo
//
//  Created by mac on 17/1/4.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQTableViewCell.h"

@interface CQTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *readCountLab;
@property(nonatomic,weak)CQCategoryCotents_L_List *cateModel;
@end

@implementation CQTableViewCell

+ (CQTableViewCell *)cellWithTableView:(UITableView *)tableView withModel:(CQContentLayoutModel *)layoutModel withIndexPath:(NSIndexPath *)indexPath {

    CQCategoryCotents_L_List *model = layoutModel.model.categoryContents.list[indexPath.section].list[indexPath.row];
    CQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.cateModel = model;
    return cell;
}

- (void)setCateModel:(CQCategoryCotents_L_List *)cateModel {
    _cateModel = cateModel;
    [self.iconView setImageWithURL:[NSURL URLWithString:cateModel.coverMiddle] placeholderImage:[UIImage imageNamed:@"UMS_qzone_icon"]];
    self.titleLab.text = cateModel.title;
    self.detailTitleLab.text = cateModel.intro;
    if (cateModel.playsCounts > 10000) {
        self.readCountLab.text = [NSString stringWithFormat:@"%.1lf万",cateModel.playsCounts/10000.0];
    } else {
        self.readCountLab.text = [NSString stringWithFormat:@"%ld",(long)cateModel.playsCounts];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = Theme_Color.CGColor;
    self.iconView.layer.borderWidth = 1.0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
