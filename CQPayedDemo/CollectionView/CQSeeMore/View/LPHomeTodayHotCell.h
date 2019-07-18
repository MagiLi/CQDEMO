//
//  LPHomeTodayHotCell.h
//  LPYProjrect
//
//  Created by Mac on 2019/2/27.
//  Copyright © 2019 LvPai Culture. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LPHomeTodayHotCellH 570.0

NS_ASSUME_NONNULL_BEGIN
static NSString *LPHomeTodayHotCellID = @"LPHomeTodayHotCellID";

@protocol LPHomeTodayHotCellDelegate <NSObject>
- (void)seeMoreEvent;
@end
@interface LPHomeTodayHotCell : UITableViewCell
@property (nonatomic, weak) id<LPHomeTodayHotCellDelegate> delegate;
+ (LPHomeTodayHotCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withData:(NSArray *)dictArray;
@end

NS_ASSUME_NONNULL_END
