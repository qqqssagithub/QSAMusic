//
//  PlayButtonView.m
//  MyMusicTest
//
//  Created by qqqssa on 15/12/8.
//  Copyright © 2015年 陈少文. All rights reserved.
//

#import "PlayButtonView.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayView.h"

@implementation PlayButtonView

+ (instancetype)sharedPlayButtonViewWithHeight:(CGFloat)height {
    static PlayButtonView *sharedPlayButtonView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:@"PlayButtonView" bundle:nil];
        sharedPlayButtonView = [[nib instantiateWithOwner:nil options:nil] firstObject];
        //sharePlayButtonView.cycleMode = CirculationModeIsCycle;
        sharedPlayButtonView.frame = CGRectMake(0, QSMUSICSCREEN_HEIGHT, QSMUSICSCREEN_WIDTH, height);
        [sharedPlayButtonView.cycleButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.previousButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.playButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.nextButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.otherButton setShowsTouchWhenHighlighted:YES];
        sharedPlayButtonView.currentLoop = 0;
        //监听耳机的拨出
        [[NSNotificationCenter defaultCenter] addObserver:sharedPlayButtonView selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
        //添加中断播放监听
        [sharedPlayButtonView addInterruptKVO];
    });
    return sharedPlayButtonView;
}

- (void)initView {
    
}

- (void)outputDeviceChanged:(NSNotification *)aNotification {
    if ([[aNotification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] isEqualToNumber:[NSNumber numberWithInt:2]]) {
        //NSLog(@"耳机拨出");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_playButton setImage:[UIImage imageNamed:@"bf"] forState:UIControlStateNormal];
            [[TingEVAPlayView sharedTingEVAPlayView] sphereViewStop];
        });
    } else if([[aNotification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] isEqualToNumber:[NSNumber numberWithInt:1]]){
        // NSLog(@"耳机插入");
        //[_playButton setImage:[UIImage imageNamed:@"zantingduan3"] forState:UIControlStateNormal];
    }
}

#pragma mark - 添加中断播放监听
- (void)addInterruptKVO{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
}

//中断播发后的回调
- (void)handleInterrupt:(NSNotification*)notification{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            //NSLog(@"播放被中断");
            [_playButton setImage:[UIImage imageNamed:@"bf"] forState:UIControlStateNormal];
            [[TingEVAPlayView sharedTingEVAPlayView] sphereViewStop];
        } else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
            //NSLog(@"中断结束");
            if (QSMusicPlayer.isPlaying) {
                [_playButton setImage:[UIImage imageNamed:@"zantingduan3"] forState:UIControlStateNormal];
                [QSMusicPlayer play];
            }
            
        }
    }
}

- (void)loopButton:(UIButton *)btn {
    [self buttonAction:btn];
}

//全部按钮的响应方法
- (IBAction)buttonAction:(UIButton *)oneButton {
    PlayView *view = [PlayView sharedPlayView];
    switch (oneButton.tag) {
        case 201:
            if (view.isLoad) {
                [CSWFlashingAlertView initWithMessage:@"本地播放，暂时为列表循环"];
            } else {
                [self cycleModeWithTitle:[QSMusicPlayer changePlayMode]];
            }
            break;
        case 202:
            [QSMusicPlayer playPreviousIndex];
            break;
        case 203:
            [self isPlay];
            break;
        case 204:
            [QSMusicPlayer playNextIndex];
            break;
        case 205: {
            _otherButton.enabled = NO;
            [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] downloadSong];
        }
            break;
        default:
            break;
    }
}

- (void)cycleModeWithTitle:(NSString *)title {
    if ([title isEqualToString:@"单曲循环"]) {
        [_cycleButton setBackgroundImage:[UIImage imageNamed:@"danqu1"] forState:UIControlStateNormal];
    } else if ([title isEqualToString:@"随机播放"]) {
        [_cycleButton setBackgroundImage:[UIImage imageNamed:@"suiji1"] forState:UIControlStateNormal];
    } else if ([title isEqualToString:@"列表循环"]) {
        [_cycleButton setBackgroundImage:[UIImage imageNamed:@"xunhuan1"] forState:UIControlStateNormal];
    }
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH /2 -50, QSMUSICSCREEN_HEIGHT - 22 - self.bounds.size.height, 100, 44)];
    whiteView.layer.cornerRadius = 5;
    whiteView.layer.masksToBounds = YES;
    whiteView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    [[UIApplication sharedApplication].keyWindow addSubview:whiteView];
    UILabel *netLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 100, 20)];
    netLabel.text = title;
    netLabel.textAlignment = NSTextAlignmentCenter;
    netLabel.textColor = [UIColor blackColor];
    [whiteView addSubview:netLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [whiteView removeFromSuperview];
    });
}

- (void)isPlay {
    if ([QSMusicPlayer isPlaying]) {
        [QSMusicPlayer pause];
        [_playButton setImage:[UIImage imageNamed:@"bf"] forState:UIControlStateNormal];
    } else {
        [QSMusicPlayer play];
        [_playButton setImage:[UIImage imageNamed:@"zantingduan3"] forState:UIControlStateNormal];
    }
}

@end
