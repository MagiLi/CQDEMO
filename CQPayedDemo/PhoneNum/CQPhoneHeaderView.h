//
//  CQPhoneHeaderView.h
//  CQPayedDemo
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQPhoneHeaderView : UITableViewHeaderFooterView

+ (CQPhoneHeaderView *)headerViewWithTableView:(UITableView *)tableView withSection:(NSInteger)section withArray:(NSMutableArray *)array;

@end
