//
//  CQCollectionViewController.m
//  CQPayedDemo
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQCollectionViewController.h"
#import "CQCollectionHController.h"
#import "CQCollectionViewAnimation.h"
#import "CQWaterfallFlowController.h"
#import "LPOrderProgressView.h"
#import "CQSeeMoreController.h"

@interface CQCollectionViewController ()
@property (nonatomic, strong) LPOrderProgressView *progressView;
@property(nonatomic,strong)NSArray *array;
@end

@implementation CQCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.item == 0) {
        CQCollectionHController *collHController = [[CQCollectionHController alloc] init];
        [self.navigationController pushViewController:collHController animated:YES];
    }
    else if (indexPath.item == 1) {
        CQCollectionViewAnimation *collHController = [[CQCollectionViewAnimation alloc] init];
        [self.navigationController pushViewController:collHController animated:YES];
    }
    else if (indexPath.item == 2) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQWaterfallFlowController" bundle:[NSBundle mainBundle]];
        CQWaterfallFlowController *waterfallVC = sb.instantiateInitialViewController;
        [self.navigationController pushViewController:waterfallVC animated:YES];
    }
    else if (indexPath.item == 3) {
        CQSeeMoreController *seeMoreController = [[CQSeeMoreController alloc] init];
        [self.navigationController pushViewController:seeMoreController animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.progressView setCurrentRoundIndex:3];
    return self.progressView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}
- (NSArray *)array {
    if (!_array) {
        _array = @[@"左右滑动",@"堆叠/圆",@"瀑布流",@"查看更多"];
    }
    return _array;
}
- (LPOrderProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[LPOrderProgressView alloc] initWithFrame:CGRectMake(0, 50, kScreen_W, 50.0) titlesArr:@[@"订单生产",@"支付完成",@"商家确认",@"服务完成",@"评价"] highlightColor:Theme_Color normalColor:[UIColor lightGrayColor] radius:12.0 roundIndex:0];
    }
    return _progressView;
}
@end
