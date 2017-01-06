//
//  CQSongCell.h
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQSongLayoutModel.h"

static NSString *songCellID = @"SongCellID";

@interface CQSongCell : UITableViewCell

+ (CQSongCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withModel:(CQSongLayoutModel *)layoutModel;

@end
