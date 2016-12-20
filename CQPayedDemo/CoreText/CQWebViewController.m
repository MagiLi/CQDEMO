//
//  WebViewController.m
//  Modal
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQWebViewController.h"

@interface CQWebViewController ()

@end

@implementation CQWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0f];
    [webView loadRequest:request];
    [webView setScalesPageToFit:YES];
//    webView.opaque = NO;
//    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [backBtn setTitle:@"🔙" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor lightGrayColor];
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
