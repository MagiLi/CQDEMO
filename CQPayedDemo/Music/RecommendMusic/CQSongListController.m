//
//  CQSongListController.m
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQSongListController.h"
#import "CQSongListHeadView.h"
#import "CQSongCell.h"
#import "CQCenterView.h"

@interface CQSongListController ()

@property(nonatomic,strong)CQSongListHeadView *headerView;
@property(nonatomic,assign)CGFloat headerH;
@property(nonatomic,strong)CQSongLayoutModel *layoutModel;


@end

@implementation CQSongListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerH = 200;
    self.headerView = [[CQSongListHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, self.headerH)];
    self.tableView.tableHeaderView = self.headerView;
    __weak typeof(self) weakSelf = self;
    [self.layoutModel getMoreDataCompletionHandle:^(NSError *error) {
        self.headerView.model = self.layoutModel.songModel.album;
        NSURL *url = [NSURL URLWithString:self.layoutModel.songModel.album.coverLarge];
        [weakSelf.headerView.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UMS_qzone_icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [weakSelf.headerView.imageView setBlurImage:image];// 方式一
            weakSelf.headerView.imageView.image = [UIImage cq_blurredImageWithImage:image andBlurAmount:2.0];//方式二
        }];
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.layoutModel.songModel.tracks.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CQSongCell cellWithTableView:tableView withIndexPath:indexPath withModel:self.layoutModel];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CQSongCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CQTracks_List *model = self.layoutModel.songModel.tracks.list[indexPath.row];
    [[CQPlayerManager sharedInstance].imageCovers addObject:cell.iconView.image];
    [[CQPlayerManager sharedInstance] addSong:model];
    if ([CQPlayerManager sharedInstance].isPlaying) {
        
    } else {
        [[CQPlayerManager sharedInstance] playWithData:model];
        CQCenterView *centerView = [self.navigationController.view.subviews lastObject];
        centerView.coverUrl = model.coverSmall;
        if ([[CQAnimationManager sharedInsatnce] existRotationAnimation:centerView.btnLayer]) {
            [[CQAnimationManager sharedInsatnce] resumeRotationAnimation:centerView.btnLayer];
        } else {
            [[CQAnimationManager sharedInsatnce] startRotationAnimation:centerView.btnLayer duration:10.0];
        }
        centerView.selected = YES;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        CGFloat scale = (fabs(scrollView.contentOffset.y ) + self.headerH) / self.headerH;
        
        CATransform3D transformScale3D = CATransform3DMakeScale(scale, scale, 1.0);
        CATransform3D transformTranslate3D = CATransform3DMakeTranslation(0, (scrollView.contentOffset.y)/2, 0);
        self.headerView.imageView.layer.transform = CATransform3DConcat(transformScale3D, transformTranslate3D);
        
        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
        scrollIndicatorInsets.top = fabs(scrollView.contentOffset.y) + self.headerH;
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    } else {
        self.headerView.imageView.layer.transform = CATransform3DIdentity;
        
        if (scrollView.scrollIndicatorInsets.top != self.headerH) {
            UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
            scrollIndicatorInsets.top = self.headerH;
            scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
        }
    }
}

- (CQSongLayoutModel *)layoutModel {
    if (!_layoutModel) {
        _layoutModel = [[CQSongLayoutModel alloc] initWithAlbumId:self.albumId title:self.oTitle isAsc:YES];
    }
    return _layoutModel;
}

@end
