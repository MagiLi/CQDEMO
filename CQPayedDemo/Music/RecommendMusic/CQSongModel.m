//
//  CQSongModel.m
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQSongModel.h"

@implementation CQSongModel
@end

@implementation CQTracks
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CQTracks_List class]};
}
@end

@implementation CQAlbum
@end

@implementation CQTracks_List
@end
