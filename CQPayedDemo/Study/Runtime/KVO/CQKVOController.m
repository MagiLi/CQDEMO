//
//  CQKVOController.m
//  CQPayedDemo
//
//  Created by 李超群 on 2019/8/7.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQKVOController.h"
#import "CQKVOCustomized.h"

@interface CQKVOController ()
@property(nonatomic,strong)CQKVOCustomized *kvoC;
@end

@implementation CQKVOController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义KVO";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CQKVOCustomized *kvoC = [[CQKVOCustomized alloc] init];
    kvoC.name = @"CQKVOCustomized";
    self.kvoC = kvoC;
    
    // CQKVOCustomized, 0x1043c24c8
    CQLog(@"%@, %p", object_getClass(kvoC), [kvoC methodForSelector:@selector(setName:)]);
    
//    [kvoC addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    [kvoC cq_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    self.kvoC.name = @"CQKVOCustomized_changed";
    
    // NSKVONotifying_CQKVOCustomized, 0x1a96a9454
    CQLog(@"%@, %p", object_getClass(kvoC), [kvoC methodForSelector:@selector(setName:)]);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    CQLog(@"%@", change);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
