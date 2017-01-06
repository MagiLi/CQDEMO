//
//  CQTableViewCell.h
//  CQPayedDemo
//
//  Created by mac on 17/1/4.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQContentLayoutModel.h"

static NSString *cellID = @"reuseIdentifier";

@interface CQTableViewCell : UITableViewCell

+ (CQTableViewCell *)cellWithTableView:(UITableView *)tableView withModel:(CQContentLayoutModel *)layoutModel withIndexPath:(NSIndexPath *)indexPath;
@end
