//
//  ViewController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQMainController.h"
#import "CQDynamicViewController.h"
#import "CQAppsController.h"
#import "CQPhoneNumController.h"
#import "CQCoreTextController.h"
#import "CQPlayerController.h"
#import "CQMusicBarController.h"

@interface CQMainController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *array;

@end

@implementation CQMainController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = self.array[indexPath.section][indexPath.row];
    
    if ([string isEqualToString:@"支付宝"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQAppsController" bundle:[NSBundle mainBundle]];
        CQAppsController *appsVC = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:appsVC animated:YES];
    } else if ([string isEqualToString:@"Dynamic"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQDynamicViewController" bundle:[NSBundle mainBundle]];
        CQDynamicViewController *dynamicVC = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:dynamicVC animated:YES];
    } else if ([string isEqualToString:@"手机通讯录"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQPhoneNumController" bundle:[NSBundle mainBundle]];
        CQPhoneNumController *phoneNumVC = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:phoneNumVC animated:YES];
    } else if ([string isEqualToString:@"CoreText"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQCoreTextController" bundle:[NSBundle mainBundle]];
        CQCoreTextController *coreTextVC = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:coreTextVC animated:YES];
    } else if ([string isEqualToString:@"Player"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQPlayerController" bundle:[NSBundle mainBundle]];
        CQPlayerController *playerVC = [sb instantiateInitialViewController];
        [self presentViewController:playerVC animated:YES completion:nil];
//        [self.navigationController pushViewController:playerVC animated:YES];
    } else if ([string isEqualToString:@"音乐🎵"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CQMusicBarController" bundle:[NSBundle mainBundle]];
        CQMusicBarController *barVC = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:barVC animated:YES];

    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.array[indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.imageView.image = [UIImage imageNamed:@"UMS_qq_icon"];
    cell.textLabel.text = arr[indexPath.row];
    cell.detailTextLabel.text = @"详情。。。";
    return cell;
}

- (NSArray *)array {
    if (!_array) {
        _array = @[@[@"支付宝"],@[@"Dynamic"],@[@"手机通讯录"],@[@"CoreText"],@[@"Player", @"音乐🎵"]];
    }
    return _array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
