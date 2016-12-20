//
//  CQPhoneNumberCell.h
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQPhoneNumberCellDelegate <NSObject>

- (void)cellWillBeginPanGesture;
- (void)cellEndPanGesture:(BOOL)moved;
@end

@interface CQPhoneNumberCell : UITableViewCell

+ (CQPhoneNumberCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)array;

@property (weak, nonatomic) IBOutlet UIView *foregroundView;

@property(nonatomic,weak)id<CQPhoneNumberCellDelegate> delegate;
@end
