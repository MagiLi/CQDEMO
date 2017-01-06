//
//  CQSongModel.h
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQBaseModel.h"
@class CQAlbum, CQTracks, CQTracks_List;
@interface CQSongModel : CQBaseModel
@property (nonatomic, strong) CQTracks *tracks;
@property (nonatomic, strong) CQAlbum *album;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger ret;
@end

@interface CQAlbum : CQBaseModel
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, assign) NSInteger serialState;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *coverWebLarge;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger shares;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) BOOL hasNew;
@property (nonatomic, assign) long long createdAt;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) long long updatedAt;
@property (nonatomic, copy) NSString *coverSmall;
@property (nonatomic, copy) NSString *coverLarge;
@property (nonatomic, copy) NSString *coverOrigin;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *introRich;
@property (nonatomic, assign) NSInteger zoneId;
@property (nonatomic, assign) NSInteger tracks;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) NSInteger serializeStatus;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger playTimes;
@end

@interface CQTracks : CQBaseModel
@property (nonatomic, assign) NSInteger maxPageId;
@property (nonatomic, strong) NSArray<CQTracks_List *> *list;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalCount;
@end

@interface CQTracks_List : CQBaseModel
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger userSource;
@property (nonatomic, assign) NSInteger processState;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, copy) NSString *coverMiddle;
@property (nonatomic, assign) NSInteger shares;
@property (nonatomic, copy) NSString *playPathAacv224;
@property (nonatomic, assign) long long createdAt;
@property (nonatomic, copy) NSString *smallLogo;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSString *albumImage;
@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, copy) NSString *downloadAacUrl;
@property (nonatomic, copy) NSString *playUrl64;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, copy) NSString *playPathAacv164;
@property (nonatomic, copy) NSString *playUrl32;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *coverSmall;
@property (nonatomic, copy) NSString *coverLarge;
@property (nonatomic, assign) NSInteger playtimes;
@property (nonatomic, assign) NSInteger downloadSize;
@property (nonatomic, assign) NSInteger downloadAacSize;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, assign) NSInteger comments;
@property (nonatomic, assign) NSInteger trackId;
@property (nonatomic, assign) NSInteger opType;
@property (nonatomic, assign) BOOL isPublic;
@end

