//
//  CQMajorController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/29.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQRecommendController.h"
#import "CQTableViewCell.h"
#import "CQSongListController.h"

@interface CQRecommendController ()
@property(nonatomic,strong)CQContentLayoutModel *layoutModel;

@end

@implementation CQRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CQTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    __weak typeof(self) weakSelf = self;
    [self.layoutModel getMoreDataCompletionHandle:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.layoutModel.section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.layoutModel rowForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [CQTableViewCell cellWithTableView:tableView withModel:self.layoutModel withIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.layoutModel mainTitleForSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CQCategoryCotents_L_List *model = self.layoutModel.model.categoryContents.list[indexPath.section].list[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQSongListController" bundle:[NSBundle mainBundle]];
    CQSongListController *listVC = sb.instantiateInitialViewController;
    listVC.albumId = model.albumId;
    listVC.oTitle = model.title;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}
- (CQContentLayoutModel *)layoutModel {
    if (!_layoutModel) {
        _layoutModel = [[CQContentLayoutModel alloc] initWithCategoryID:2 contentType:@"album"];
    }
    return _layoutModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
