//
//  CQSongLayoutModel.m
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQSongLayoutModel.h"

@interface CQSongLayoutModel ()
@property (nonatomic,assign) NSInteger albumId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign,getter=isAsc) BOOL asc;
@end

@implementation CQSongLayoutModel
- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)title isAsc:(BOOL)asc {
    if (self = [super init]) {
        _albumId = albumId;
        _title = title;
        _asc = asc;
    }
    return self;
}

#pragma mark -
#pragma mark - 获取数据
- (void)getMoreDataCompletionHandle:(void (^)(NSError *))completed {
    __weak typeof(self) weakSelf = self;
    [CQDownloadData getSongDataWithBlock:^(NSArray *array, NSError *error) {
        weakSelf.songModel = [array firstObject];
        if (completed) {
            completed(error);
        }
    } andAlbumId:self.albumId andTitle:self.title andAsc:self.asc];

}

@end
