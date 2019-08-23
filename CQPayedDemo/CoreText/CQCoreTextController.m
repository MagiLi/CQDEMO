//
//  CQCoreTextController.m
//  CQPayedDemo
//
//  Created by mac on 16/12/19.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQCoreTextController.h"
#import "CQCTFrameParserConfig.h"
#import "CQWebViewController.h"
#import "CQDisplayView.h"
#import "CQBigImageView.h"
#import "CQCTFrameParser.h"

#import "CQEllipsisLabel.h"

static CGFloat margin = 10.0;

@interface CQCoreTextController ()
@property(nonatomic,strong)CQDisplayView *ctView;
@property(nonatomic,assign)CGRect imgFrame;
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,weak)UIScrollView *scrollView;
@end

@implementation CQCoreTextController

/*
 * 1.拿到属性字符串attributeString
 * 2.设置属性字符串的属性（包括delegate）⭐️⭐️⭐️⭐️⭐️
 * 3.根据属性字符串拿到CTFrame
 * 4.绘制
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H - 150.0)];
    scrollView.alwaysBounceVertical = YES;
//    scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CQDisplayView *ctView = [[CQDisplayView alloc] init];
    ctView.frame = CGRectMake(margin, margin, kScreen_W - margin*2.0, kScreen_H);
    ctView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:ctView];
    self.ctView = ctView;
    [CQCTFrameParserConfig sharedInstance].width = self.ctView.width;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TempData.plist" ofType:nil];
    CQCoreTextData *data = [CQCTFrameParser parseTemplateFile:path config:[CQCTFrameParserConfig sharedInstance]];
    // 传递数据给CTDisplayView
    self.ctView.data = data;
    // 设置CTDisplayView的高度，绘制内容
    self.ctView.height = data.height;
    
    scrollView.contentSize = CGSizeMake(0, data.height + margin*2.0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imagePressed:)
                                                 name:CQDisplayViewImagePressedNotification
                                               object:nil]; //点击图片的事件监听
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(linkPressed:)
                                                 name:CQDisplayViewLinkPressedNotification
                                               object:nil]; // 链接 监听
    
    [self addEllipsisLabel];

}
- (void)addEllipsisLabel {
    NSString *tex = @"在当代中国音乐文学史上，在当代中国音乐文学史上，在当代中在当代中国音乐文学史上，在当代中在当代中国音乐文学史上，在当代中在当代中国音乐文学史上，在当代中在当代中国音乐文学史上，在当代中";
    
    CGFloat height = [tex sizeWithConstrainedToWidth:kScreen_W - 15 * 2 fromFont:[UIFont systemFontOfSize:18] lineSpace:5].height;
    
    NSInteger num = [tex numberOfLinesWithConstrainedToWidth:kScreen_W - 15 * 2 fromFont:[UIFont systemFontOfSize:18] lineSpace:5];
    
    CGFloat labelheight = height / num;
    
    NSInteger row = num >= 2 ? 2 : num;
    
    CQEllipsisLabel *label = [[CQEllipsisLabel alloc] initWithFrame:CGRectMake(15, kScreen_H - 150.0, kScreen_W - 15 * 2, labelheight * row)];
    
    label.font = [UIFont systemFontOfSize:18];
    label.lineSpace = 5;
    label.numberOfLines = 2;
    label.text = tex;
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
}

#pragma mark -
#pragma mark - 展示图片
- (void)imagePressed:(NSNotification*)notification {
    CQCoreTextImageData *imageData = notification.userInfo[@"imageData"];
    CGFloat x = imageData.frame.origin.x + margin;
    CGFloat y = imageData.frame.origin.y+margin-self.scrollView.contentOffset.y;
    self.imgFrame = CGRectMake(x, y, imageData.frame.size.width, imageData.frame.size.height);
    
    CQBigImageView *bigImgView = [[CQBigImageView alloc] initWithFrame:self.imgFrame];
    bigImgView.imgStr = imageData.name;
    [[UIApplication sharedApplication].keyWindow addSubview:bigImgView];
    [bigImgView beginAnimation];
}

#pragma mark -
#pragma mark - 打开网页
- (void)linkPressed:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CQCoreTextLinkData *linkData = userInfo[@"linkData"];
    
    //    NSLog(@"linkData.url: %@", linkData.url);
    CQWebViewController *vc = [[CQWebViewController alloc] init];
    vc.urlString = linkData.url;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
