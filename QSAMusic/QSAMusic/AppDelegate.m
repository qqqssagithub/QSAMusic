//
//  AppDelegate.m
//  QSAMusic
//
//  Created by 陈少文 on 17/4/24.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "QSMusicRemoteEvent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [application beginReceivingRemoteControlEvents];
    
    //监听耳机的拨出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:session];
    //添加中断播放监听
    [self addInterruptKVO];
    
    [[QSAAudioPlayer shared] startEngine];
    
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] responseEvent:event];
}

//耳机插拔巨坑, 至于为什么如下所写, 花了半天才试出来的. 耳机拔出会造成engine被停止, engine停止后, internalPlayer又不能播放. 正在播放耳机拔出和暂停播放耳机播出又不一样, 总之就是坑
- (void)outputDeviceChanged:(NSNotification *)aNotification {
    if ([[aNotification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] isEqualToNumber:[NSNumber numberWithInt:2]]) {
        //耳机拨出
        [[PlayerController shared] headphonePullOut];
    } else if([[aNotification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] isEqualToNumber:[NSNumber numberWithInt:1]]){
        //耳机插入
        if ([QSAAudioPlayer shared].internalPlayer.isPlaying) {
            [[QSAAudioPlayer shared].internalPlayer pause];
            [[QSAAudioPlayer shared].engine pause];
            [[QSAAudioPlayer shared].engine startAndReturnError:nil];
            [[QSAAudioPlayer shared].internalPlayer play];
        }
    }
}

#pragma mark - 添加中断播放监听
- (void)addInterruptKVO{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
}

//中断播发后的回调, 播放被中断的情况有电话接入/打开其他多媒体app等
- (void)handleInterrupt:(NSNotification*)notification{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            if ([PlayerController shared].isPlaying) {
                [[PlayerController shared] pause];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
