//
//  QSMusicRemoteEvent.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/7.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicRemoteEvent.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayView.h"
#import "PlayButtonView.h"

// 滑动方向
typedef NS_ENUM(NSInteger, CameraMoveDirection) {
    kCameraMoveDirectionNone  = 0,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft,
};

@interface QSMusicRemoteEvent ()

@property (nonatomic) CameraMoveDirection direction; // 方向
@property (nonatomic) NSTimeInterval      curtime;
@property (nonatomic) NSInteger style;

@end

@implementation QSMusicRemoteEvent

+ (instancetype)sharedQSMusicRemoteEvent {
    static QSMusicRemoteEvent *sharedQSMusicRemoteEvent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicRemoteEvent = [[QSMusicRemoteEvent alloc] init];
        //开始接收远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    });
    return sharedQSMusicRemoteEvent;
}

- (void)addLockScreenViewWithTitle:(NSString *)title time:(NSString *)time author:(NSString *)author image:(UIImage *)image {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setObject:title forKey:MPMediaItemPropertyTitle];
        [dict setObject:author forKey:MPMediaItemPropertyArtist];
        [dict setObject:time forKey:MPMediaItemPropertyPlaybackDuration];
        MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artWork forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

- (void)responseEvent:(UIEvent *)event {
    //PlayButtonView *playButtonView = [PlayButtonView sharedPlayButtonViewWithHeight:[PlayView sharedPlayView].playBottomView.bounds.size.height];
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {//锁屏play
            [[PlayerController shared] playAndPause];
        } else if(event.subtype == UIEventSubtypeRemoteControlPause) {//锁屏pause
            [[PlayerController shared] playAndPause];
        } else if(event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {//耳机play和pause
            [[PlayerController shared] playAndPause];
        }else if(event.subtype == UIEventSubtypeRemoteControlNextTrack) {//耳机''锁屏共用
            [[PlayerController shared] playNextIndex];
        }else if(event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {//耳机''锁屏共用
            [[PlayerController shared] playPreviousIndex];
        }
    }
}


#pragma mark - 进度和音量调节
- (void)VolumeAndScheduleControl:(UIPanGestureRecognizer *)recognizer view:(UIView *)view style:(NSInteger)style{
    _style = style;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _direction	= kCameraMoveDirectionNone;								// 无方向
        _curtime = [PlayerController shared].playTime;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];         // 事实移动位置 增量
        _direction	= [self determineCameraDirectionIfNeeded:translation];
        if (_direction == 1 || _direction == 2) {
            MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            float currentVolume = musicPlayer.volume - (translation.y / view.bounds.size.height) * 0.05;
            if (currentVolume <= 0.0) {
                currentVolume = 0.0;
            } else if(currentVolume >= 1.0) {
                currentVolume = 1.0;
            }
            musicPlayer.volume = currentVolume;
        }  else if (_direction == 3) { //Right
            _curtime += 2.0;
            if (_curtime > [PlayerController shared].duration) {
                _curtime = [PlayerController shared].duration;
            }
            NSInteger second = _curtime;
            [self cycleModeWithTitle:[NSString stringWithFormat:@"快进>> %02ld:%02ld", second/60, second%60]];
        } else if (_direction == 4) { //Left
            _curtime -= 2.0;
            if (_curtime < 0.0) {
                _curtime = 0.0;
            }
            NSInteger second = _curtime;
            [self cycleModeWithTitle:[NSString stringWithFormat:@"%02ld:%02ld <<快退", second/60, second%60]];
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (_direction == 3 || _direction == 4) {
            [[PlayerController shared] playWithTime:_curtime];
        }
    }
}

// 获取方向
- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation {
    if (self.direction != kCameraMoveDirectionNone) {
        return self.direction;
    }
    if (fabs(translation.x) > 5.0) {
        BOOL gestureHorizontal = NO;
        if (translation.y == 0.0 )
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        if (gestureHorizontal) {
            if (translation.x > 0.0 )
                return kCameraMoveDirectionRight;
            else
                return kCameraMoveDirectionLeft;
        }
    } else if (fabs(translation.y) > 5.0) {
        BOOL gestureVertical = NO;
        if (translation.x == 0.0 )
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        if (gestureVertical) {
            if (translation.y > 0.0 ) {
                return kCameraMoveDirectionDown;
            } else {
                return kCameraMoveDirectionUp;
            }
        }
    }
    return self.direction;
}

- (void)cycleModeWithTitle:(NSString *)title {
    UIView *view;
    if (_style == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth /2 -70, ScreenHeight /2 -150, 140, 44)];
        view.backgroundColor = [UIColor redColor];
    } else {
        view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth /2 -70, ScreenHeight -117, 140, 44)];
        view.backgroundColor = [UIColor whiteColor];
    }
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [QSAMusicKeyWindow addSubview:view];
    UILabel *netLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 140, 20)];
    netLabel.text = title;
    netLabel.textAlignment = NSTextAlignmentCenter;
    netLabel.textColor = [UIColor blackColor];
    [view addSubview:netLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
}

@end
