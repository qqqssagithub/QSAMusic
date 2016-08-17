//
//  QSMusicRemoteEvent.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/7.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicRemoteEvent : NSObject

+ (instancetype)sharedQSMusicRemoteEvent;

/**
 *  添加锁屏界面
 *
 *  @param title  歌名
 *  @param time   总时间
 *  @param author 歌手
 *  @param image  图片
 */
- (void)addLockScreenViewWithTitle:(NSString *)title time:(NSString *)time author:(NSString *)author image:(UIImage *)image;

/**
 *  远程控制响应
 */
- (void)responseEvent:(UIEvent *)event;

/**
 *  进度和音量调节
 *
 *  @param recognizer 
 *  @param view
 */
- (void)VolumeAndScheduleControl:(UIPanGestureRecognizer *)recognizer view:(UIView *)view style:(NSInteger)style;

@end
