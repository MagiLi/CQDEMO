
//
//  CQTextToVideoController.m
//  CQPayedDemo
//
//  Created by 李超群 on 2017/7/19.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQTextToVideoController.h"
#import <AVFoundation/AVSpeechSynthesis.h>

@interface CQTextToVideoController ()<AVSpeechSynthesizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation CQTextToVideoController
{
    AVSpeechSynthesizer *speechSyn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [[UIImage alloc] gradientCornersRadiusImageWithBounds:CGRectMake(0, 0, 100, 40) andColors:@[ThemeColor_Right, ThemeColor_Left]];
    [self.btn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (speechSyn.isSpeaking || speechSyn.isPaused) {
        [speechSyn stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        speechSyn = nil;
    }
}
- (IBAction)buttonClicked:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        if (speechSyn.isSpeaking) {
            [speechSyn pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
        }
    } else {
        sender.selected = YES;
        if (speechSyn.isPaused) {
            [speechSyn continueSpeaking];
        } else {
            //初始化对象
            
            speechSyn= [[AVSpeechSynthesizer alloc] init];
            speechSyn.delegate=self; //挂上代理
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"锦瑟无端五十弦，一弦一柱思华年。庄生晓梦迷蝴蝶，望帝春心托杜鹃。沧海月明珠有泪，蓝田日暖玉生烟。此情可待成追忆，只是当时已惘然。hello word"];//需要转换的文字
            utterance.rate=0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
            AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置发音，这是中文普通话
            utterance.voice= voice;
            [speechSyn speakUtterance:utterance];//开始
        }
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    self.btn.selected = NO;
    NSLog(@"---完成播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    
}
- (void)dealloc {
    CQLog(@"dealloc...");
}
@end
