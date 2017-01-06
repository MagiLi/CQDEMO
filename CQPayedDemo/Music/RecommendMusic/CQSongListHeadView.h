//
//  CQSongListHeadView.h
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+CQBlur.h"
#import "CQSongModel.h"

@interface CQSongListHeadView : UIView
@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)CQAlbum *model;

@end
