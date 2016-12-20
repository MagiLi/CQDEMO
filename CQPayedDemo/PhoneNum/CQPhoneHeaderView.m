//
//  CQPhoneHeaderView.m
//  CQPayedDemo
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPhoneHeaderView.h"

@interface CQPhoneHeaderView ()

@property(nonatomic,weak)UILabel *labIndex;

@end

@implementation CQPhoneHeaderView

+ (CQPhoneHeaderView *)headerViewWithTableView:(UITableView *)tableView withSection:(NSInteger)section withArray:(NSMutableArray *)array {
    CQPhoneHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"phoneHeaderView"];
    if (!headerView) {
        headerView = [[CQPhoneHeaderView alloc] initWithReuseIdentifier:@"phoneHeaderView"];
    }
    headerView.labIndex.text = array[section];
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        lab.textColor = [UIColor colorWithRed:237/255.0 green:170/255.0 blue:20/255.0 alpha:1.0];
        [self addSubview:lab];
        self.labIndex = lab;
    }
    return self;
}

@end
