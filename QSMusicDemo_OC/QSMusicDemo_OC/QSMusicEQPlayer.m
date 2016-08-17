//
//  QSMusicEQPlayer.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/17.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicEQPlayer.h"
#import "QSMusicEQSetView.h"
#import "PlayView.h"
#import "QSMusicRemoteEvent.h"

@interface QSMusicEQPlayer ()

@property (nonatomic) AEAudioFilePlayer    *player;
@property (nonatomic) AEParametricEqFilter *eq31HzFilter;
@property (nonatomic) AEParametricEqFilter *eq62HzFilter;
@property (nonatomic) AEParametricEqFilter *eq125HzFilter;
@property (nonatomic) AEParametricEqFilter *eq250HzFilter;
@property (nonatomic) AEParametricEqFilter *eq500HzFilter;
@property (nonatomic) AEParametricEqFilter *eq1kFilter;
@property (nonatomic) AEParametricEqFilter *eq2kFilter;
@property (nonatomic) AEParametricEqFilter *eq4kFilter;
@property (nonatomic) AEParametricEqFilter *eq8kFilter;
@property (nonatomic) AEParametricEqFilter *eq16kFilter;
@property (nonatomic) NSArray *eqFilters;

@property (nonatomic) NSInteger currentPlayIndex;

@end

@implementation QSMusicEQPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _audioController = [[AEAudioController alloc] initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:YES];
        [self creatEqFliters];
    }
    return self;
}

- (void)creatEqFliters {
    _eq31HzFilter  = [[AEParametricEqFilter alloc] init];
    _eq62HzFilter  = [[AEParametricEqFilter alloc] init];
    _eq125HzFilter = [[AEParametricEqFilter alloc] init];
    _eq250HzFilter = [[AEParametricEqFilter alloc] init];
    _eq500HzFilter = [[AEParametricEqFilter alloc] init];
    _eq1kFilter    = [[AEParametricEqFilter alloc] init];
    _eq2kFilter    = [[AEParametricEqFilter alloc] init];
    _eq4kFilter    = [[AEParametricEqFilter alloc] init];
    _eq8kFilter    = [[AEParametricEqFilter alloc] init];
    _eq16kFilter   = [[AEParametricEqFilter alloc] init];
    _eqFilters     = @[_eq31HzFilter, _eq62HzFilter, _eq125HzFilter, _eq250HzFilter, _eq500HzFilter, _eq1kFilter, _eq2kFilter, _eq4kFilter, _eq8kFilter, _eq16kFilter];
    for (AEParametricEqFilter *eqfile in _eqFilters) {
        [_audioController addFilter:eqfile];
    }
}

- (void)updateValueWithIndex:(NSInteger)index centerFrequency:(double)centerFrequency gain:(double)gain {
    AEParametricEqFilter *eqFilter = _eqFilters[index];
    eqFilter.centerFrequency = centerFrequency;
    eqFilter.gain = gain;
}

- (void)updateValueWithStyle:(NSArray *)style {
    NSArray *centerFrequencys = @[@"31", @"62", @"125", @"250", @"500", @"1000", @"2000", @"4000", @"8000", @"16000"];
    for (NSInteger i = 0; i < 9; i ++) {
        AEParametricEqFilter *eqFilter = _eqFilters[i];
        eqFilter.centerFrequency = [centerFrequencys[i] doubleValue];
        eqFilter.gain = [style[i] doubleValue];
    }
}

+ (instancetype)sheardQSMusicEQPlayer {
    static QSMusicEQPlayer *sheardQSMusicEQPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sheardQSMusicEQPlayer = [[QSMusicEQPlayer alloc] init];
    });
    return sheardQSMusicEQPlayer;
}

- (void)platerWithIndex:(NSInteger)index {
    _currentPlayIndex = index;
    
    NSArray *dataArr = [QSMusicSongDatas MR_findAll];
    QSMusicSongDatas *model = dataArr[index];
    NSURL *songURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Documents/%@.mp3", NSHomeDirectory(), model.songid]];
    
    
    _player = [AEAudioFilePlayer audioFilePlayerWithURL:songURL error:nil];
    __weak typeof(self) weakself = self;
    _player.runCallbackBlock = ^(AEAudioFilePlayer *player) {
        [weakself updatePLayTime:(long)(player.currentTime)];
        //NSLog(@"当前时间:%ld", (long)(player.currentTime));
    };
    __block typeof(index) blockindex = index;
    _player.completionBlock = ^{//播放结束回调
        [weakself playNext];
    };
    
    [_audioController removeChannels:_audioController.channels];
    [_audioController addChannels:@[_player]];
    if (QSMusicPlayer.isPlaying) {
        [QSMusicPlayer pause];
    }
    [self initPlerViewWithIndex:index];
    [_audioController start:nil];
}

- (void)initPlerViewWithIndex:(NSInteger)index {
    _currentTime = _player.currentTime;
    _duration = _player.duration;
    NSArray *dataArr = [QSMusicSongDatas MR_findAll];
    QSMusicSongDatas *model = dataArr[index];
    if (![model.versions isEqualToString:@""]) {
        [PlayView sharedPlayView].songLabel.text = [NSString stringWithFormat:@"%@(%@)", model.title, model.versions];
    } else {
        [PlayView sharedPlayView].songLabel.text = model.title;
    }
    [PlayView sharedPlayView].author.text = model.author;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *URL = [NSURL URLWithString:model.pic_radio];
    if ([manager diskImageExistsForURL:URL]) {
        UIImage *image =  [[manager imageCache] imageFromDiskCacheForKey:URL.absoluteString];
        [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] addLockScreenViewWithTitle:model.title time:[NSString stringWithFormat:@"%lf", _player.duration] author:model.author image:image];
            [PlayView sharedPlayView].starImgV.image = image;
            [PlayView sharedPlayView].playViewBackImageView.image = [image blurWithTintColor:[UIColor colorWithWhite:0.0 alpha:1.0]];

    } else {
        [PlayView sharedPlayView].starImgV.image = [UIImage imageNamed:@"bg"];
        [PlayView sharedPlayView].playViewBackImageView.image = nil;
        [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] addLockScreenViewWithTitle:model.title time:[NSString stringWithFormat:@"%lf", _player.duration] author:model.author image:[PlayView sharedPlayView].starImgV.image];
    }
    [PlayView sharedPlayView].currentTime.text = @"00:00";
    [PlayView sharedPlayView].totalTime.text = @"00:00";
    [PlayView sharedPlayView].progressView.progress = 1.0;
    [PlayView sharedPlayView].audioSlider.value = 0.0;
    [[PlayView sharedPlayView] changeListSelectedWithIndex:index];
    [[LrcTableView sharedLrcTableView] initLrcWithLrcStr:model.lrclink];
    [[PlayView sharedPlayView].playButtonView.playButton setImage:[UIImage imageNamed:@"zantingduan3"] forState:UIControlStateNormal];
}

- (void)updatePLayTime:(long)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [PlayView sharedPlayView].currentTime.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
        NSInteger total = (NSInteger)_player.duration;
        [PlayView sharedPlayView].totalTime.text = [NSString stringWithFormat:@"%02ld:%02ld", total/60, total%60];
        UISlider *oneSlider = [PlayView sharedPlayView].audioSlider;
        if(!oneSlider.tracking) {
            if (fabs(time / _player.duration - oneSlider.value) > 0.1) {
                return;
            }
            oneSlider.value = time / _player.duration;
        }
        if (![LrcTableView sharedLrcTableView].tableView.tracking) {
            [[LrcTableView sharedLrcTableView] updateLrcWithCurrentTime:[NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60]];
        }
    });
}

- (void)playPrevious {
    NSInteger index = _currentPlayIndex - 1;
    [self platerWithIndex:index];
}

- (void)playNext {
    NSInteger index = _currentPlayIndex + 1;
    [self platerWithIndex:index];
}

- (void)playAtTime:(double)seconds {
    [_player playAtTime:123];
}

- (void)play {
    [_audioController start:nil];
}

- (void)pause {
    [_audioController stop];
}

@end
