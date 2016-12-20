//
//  CQAppsData.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAppsDataManager.h"
#import "CQAppsModel.h"

@implementation CQAppsDataManager
+ (instancetype)sharedAppsDataManager {
    static CQAppsDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        //    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"AppDataList" ofType:@"plist"];
        //    NSArray *array = [NSArray arrayWithContentsOfFile:pathString];
        
        NSURL *pathUrl = [[NSBundle mainBundle]URLForResource:@"AppDataList" withExtension:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfURL:pathUrl];
        
        self.titleArray = [NSMutableArray array];
        [self.titleArray addObject:@"我的应用"];
        NSMutableArray *tempSections = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            NSArray *titleList = dict[@"list"];
            [self.titleArray addObject:dict[@"title"]];
            
            NSMutableArray *tempSection = [NSMutableArray array];
            for (NSString *title in titleList) {
                CQAppsModel *model = [[CQAppsModel alloc] init];
                model.buttonState = ServeButtonNormal;
                model.title = title;
                [tempSection addObject:model];
            }
            [tempSections addObject:tempSection];
        }
        
        NSMutableArray *sectionFirst = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            CQAppsModel *model = tempSections[0][i];
            model.buttonState = ServeButtonSelected;
            [sectionFirst addObject:model];
        }
        [tempSections insertObject:sectionFirst atIndex:0];
        self.dataArray = tempSections.mutableCopy;
    }
    return self;
}
@end
