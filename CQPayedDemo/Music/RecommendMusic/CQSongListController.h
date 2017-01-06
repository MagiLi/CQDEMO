//
//  CQSongListController.h
//  CQPayedDemo
//
//  Created by mac on 17/1/5.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQSongListController : UITableViewController

@property (nonatomic,assign) NSInteger albumId;
@property (nonatomic,strong) NSString *oTitle;
@property(nonatomic,strong)UIImage *image;

@end
