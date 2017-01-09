//
//  CQSongCell.m
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQSongCell.h"

@interface CQSongCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property(nonatomic,weak)CQTracks_List *model;

@end

@implementation CQSongCell
+ (CQSongCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withModel:(CQSongLayoutModel *)layoutModel {
    CQTracks_List *model = layoutModel.songModel.tracks.list[indexPath.row];
    CQSongCell *cell = [tableView dequeueReusableCellWithIdentifier:songCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)setModel:(CQTracks_List *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coverSmall] placeholderImage:[UIImage imageNamed:@"app_add"]];

    self.titleLab.text = model.title;
    self.detailLab.text = [NSString stringWithFormat:@"作者：%@", model.nickname];
    self.dateLab.text = [NSString stringWithFormat:@"%lld", model.createdAt];
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
