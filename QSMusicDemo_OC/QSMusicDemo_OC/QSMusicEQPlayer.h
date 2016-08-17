//
//  QSMusicEQPlayer.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/17.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicEQPlayer : NSObject

@property (nonatomic) AEAudioController *audioController;
@property (nonatomic) NSTimeInterval    duration;
@property (nonatomic) NSTimeInterval    currentTime;

+ (instancetype)sheardQSMusicEQPlayer;

- (void)platerWithIndex:(NSInteger)index;

- (void)updateValueWithIndex:(NSInteger)index centerFrequency:(double)centerFrequency gain:(double)gain;

- (void)updateValueWithStyle:(NSArray *)style;

- (void)playPrevious;

- (void)playNext;

- (void)playAtTime:(double)seconds;

- (void)play;

- (void)pause;

@end
