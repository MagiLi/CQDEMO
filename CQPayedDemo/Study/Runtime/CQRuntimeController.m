//
//  CQRuntimeController.m
//  CQPayedDemo
//
//  Created by 李超群 on 2019/7/27.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQRuntimeController.h"
#import "CQRPerson.h"
#import <objc/message.h>

@interface CQRuntimeController ()

@end

@implementation CQRuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息转发机制";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CQRPerson *person = [[CQRPerson alloc] init];
    [person sendMessage:@"hello"];
    
    
//    objc_msgSend(person, @selector(sendMessage:), @"hello");
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
