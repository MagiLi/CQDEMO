//
//  CQPhoneNumController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQPhoneNumController.h"
#import "CQPhoneHeaderView.h"
#import "CQPhoneNumberCell.h"
#import "CQLoadPhoneNumber.h"
#import "CQContactSorted.h"

@interface CQPhoneNumController () <CQPhoneNumberCellDelegate>

@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *arrrSection;
@property(nonatomic,strong)NSMutableArray *arrrSectionIndex;
@property(nonatomic,assign)BOOL moved;


@end

@implementation CQPhoneNumController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    self.array = [[CQLoadPhoneNumber sharedInstance] loadUserPhoneNumber];
    self.arrrSection = [CQContactSorted getSectionDataWithArray:self.array];
    self.arrrSectionIndex = [CQContactSorted getFirstAlphabetWithArray:self.arrrSection];
}
#pragma mark -
#pragma mark - CQPhoneNumberCellDelegate
- (void)cellWillBeginPanGesture {
    [self reductionCells];
}

- (void)cellEndPanGesture:(BOOL)moved {
    self.moved = moved;
}

#pragma mark -
#pragma mark - reductionCells
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    [self reductionCells];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self reductionCells];
}
// 还原cell
- (void)reductionCells {
    if (!self.moved) return;
    for (CQPhoneNumberCell *cell in [[self.tableView subviews][0] subviews]) {
        if (cell.foregroundView.x < 0) {
            [UIView animateWithDuration:0.2 animations:^{
                cell.foregroundView.x = 0;
            }];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrrSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrrSection[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CQPhoneNumberCell *cell = [CQPhoneNumberCell cellWithTableView:tableView withIndexPath:indexPath withArray:self.arrrSection];
    cell.delegate = self;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [CQPhoneHeaderView headerViewWithTableView:tableView withSection:section withArray:self.arrrSectionIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.arrrSectionIndex;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
