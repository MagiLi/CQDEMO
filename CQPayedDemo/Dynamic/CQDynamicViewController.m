//
//  CQDynamicViewController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQDynamicViewController.h"
#import "CQDynamicMenueView.h"

@interface CQDynamicViewController ()<UICollisionBehaviorDelegate>

@property(nonatomic,strong)UIDynamicAnimator *animator;


@property(nonatomic,strong)UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) CQDynamicMenueView *menueView;

@end

@implementation CQDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.menueView];
}

- (CQDynamicMenueView *)menueView {

    if (!_menueView) {
        UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
        UIImage *image2 = [UIImage imageNamed:@"icon-email"];
        UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
    
        NSArray *images = @[image1, image2, image3];
        _menueView = [[CQDynamicMenueView alloc] initWithStartPoint:CGPointMake(160, 300) startImage:[UIImage imageNamed:@"start"] submenuImages:images];
    }
    return _menueView;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //获取一个触摸点
//    UITouch *touch=[touches anyObject];
//    CGPoint point=[touch locationInView:touch.view];
//    
//    //1.创建捕捉行为
//    //需要传入两个参数：一个物理仿真元素，一个捕捉点
//    UISnapBehavior *snap=[[UISnapBehavior alloc]initWithItem:self.square1 snapToPoint:point];
//    //设置防震系数（0~1，数值越大，震动的幅度越小）
//    snap.damping=arc4random_uniform(10)/10.0;
//    //2.执行捕捉行为
//    //注意：这个控件只能用在一个仿真行为上，如果要拥有持续的仿真行为，那么需要把之前的所有仿真行为删除
//    //删除之前的所有仿真行为
//    [self.animator removeAllBehaviors];
//    [self.animator addBehavior:snap];
//
//}

@end
