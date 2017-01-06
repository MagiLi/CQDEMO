//
//  CQSongLayoutModel.h
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQBaseLayoutModel.h"
#import "CQSongModel.h"

@interface CQSongLayoutModel : CQBaseLayoutModel
@property(nonatomic,strong)CQSongModel *songModel;

- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)title isAsc:(BOOL)asc;
@end
