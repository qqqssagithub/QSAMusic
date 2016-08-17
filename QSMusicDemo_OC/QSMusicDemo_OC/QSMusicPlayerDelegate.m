//
//  QSMusicPlayerDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/8.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicPlayerDelegate.h"
#import "QSMusicRemoteEvent.h"
#import "QSMusicSongDatas.h"
#import "QSMusicEQPlayer.h"

@interface QSMusicPlayerDelegate () <QSMusicPlayerDelegate>

@property (nonatomic) BOOL isOpen;                  //播放界面是否打开
@property (nonatomic) CGPoint tempPoint;            //记录播放点展开前的位置
@property (nonatomic) UIDynamicAnimator *animation; //物理动效

@property (nonatomic) UIView *tempPlayViewBackView;

@end

@implementation QSMusicPlayerDelegate 

+ (instancetype)sharedQSMusicPlayerDelegate {
    static QSMusicPlayerDelegate *sharedQSMusicPlayerDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicPlayerDelegate = [[QSMusicPlayerDelegate alloc] init];
        [QSMusicPlayer sharedInstance].delegate = sharedQSMusicPlayerDelegate;
        //添加播放控制点
        [QSMusicKeyWindow addSubview:sharedQSMusicPlayerDelegate.playPointView];
    });
    return sharedQSMusicPlayerDelegate;
}

#pragma mark - QSMusicEngineDelagate
// 准备就绪, 可以开始播放
- (void)player:(QSMusicPlayer * _Nonnull)player didBecomeAvailable:(AVPlayerItem * _Nonnull)playerItem {
    [self offlineJudgment];
    NSDictionary *song = player.currentSongDetailed;
    if ([_playStyle isEqualToString:@"EVA"]) {
        if (![song[@"versions"] isEqualToString:@""]) {
            [TingEVAPlayView sharedTingEVAPlayView].songName.text = [NSString stringWithFormat:@"%@(%@)", song[@"title"], song[@"versions"]];
        } else {
            [TingEVAPlayView sharedTingEVAPlayView].songName.text = song[@"title"];
        }
        [[TingEVAPlayView sharedTingEVAPlayView] sphereViewStart];
        [TingEVAPlayView sharedTingEVAPlayView].author.text = song[@"author"];
        [[TingEVAPlayView sharedTingEVAPlayView] changeButtonColorWithIndex:player.currentPlayIndex];
        [[LrcTableView sharedLrcTableView] initLrcWithLrcURL:song[@"lrclink"]];
    } else {
        if (![song[@"versions"] isEqualToString:@""]) {
            [PlayView sharedPlayView].songLabel.text = [NSString stringWithFormat:@"%@(%@)", song[@"title"], song[@"versions"]];
        } else {
            [PlayView sharedPlayView].songLabel.text = song[@"title"];
        }
        [PlayView sharedPlayView].author.text = song[@"author"];
        [[PlayView sharedPlayView] changeListSelectedWithIndex:player.currentPlayIndex];
        [PlayView sharedPlayView].starImgV.image = [UIImage imageNamed:@"bg"];
        [PlayView sharedPlayView].playViewBackImageView.image = nil;
        [[LrcTableView sharedLrcTableView] initLrcWithLrcURL:song[@"lrclink"]];
        [[PlayView sharedPlayView].playButtonView.playButton setImage:[UIImage imageNamed:@"zantingduan3"] forState:UIControlStateNormal];
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *URL = [NSURL URLWithString:song[@"pic_radio"]];
    if ([manager diskImageExistsForURL:URL]) {
        UIImage *image =  [[manager imageCache] imageFromDiskCacheForKey:URL.absoluteString];
        [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] addLockScreenViewWithTitle:song[@"title"] time:[NSString stringWithFormat:@"%lf", player.duration] author:song[@"author"] image:image];
        if (![_playStyle isEqualToString:@"EVA"]) {
            [PlayView sharedPlayView].starImgV.image = image;
            [PlayView sharedPlayView].playViewBackImageView.image = [image blurWithTintColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
        }
    } else {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:song[@"pic_radio"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] addLockScreenViewWithTitle:song[@"title"] time:[NSString stringWithFormat:@"%lf", player.duration] author:song[@"author"] image:image];
                });
                if (![_playStyle isEqualToString:@"EVA"]) {
                    [PlayView sharedPlayView].starImgV.image = image;
                    [PlayView sharedPlayView].playViewBackImageView.image = [image blurWithTintColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
                }
            }
        }];
    }
    [player enginePlay];
}

// 准备就绪失败, 不可以播放
- (void)playerNotBecomeAvailable:(QSMusicPlayer *)player error:(NSString *)error {
    //[CSWProgressView disappear];
    //[self changeViewToZero:player];
    [self offlineJudgment];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [player playNextIndex];
    });
}

- (void)playerLoadFailed:(QSMusicPlayer *)player {
    //[self changeViewToZero:player];
    [self offlineJudgment];
    [CSWAlertView initWithTitle:@"提示" message:@"音乐加载失败，请检查网络链接" cancelButtonTitle:@"确定"];
}

- (void)offlineJudgment {
    QSMusicPlayer *player = [QSMusicPlayer sharedInstance];
    NSDictionary *song = player.currentSongDetailed;
    NSArray *dataArr = [QSMusicSongDatas MR_findAll];
    for (QSMusicSongDatas *oneModel in dataArr) {
        if ([oneModel.songid isEqualToString:song[@"songid"]]) {
            if ([_playStyle isEqualToString:@"EVA"]) {
                [TingEVAPlayView sharedTingEVAPlayView].offlineButton.enabled = NO;
            } else {
                [PlayView sharedPlayView].playButtonView.otherButton.enabled = NO;
            }
            return;
        }
    }
    
    if (![_playStyle isEqualToString:@"EVA"]) {
        [PlayView sharedPlayView].playButtonView.otherButton.enabled = YES;
        [PlayView sharedPlayView].audioSlider.value = 0.0;
    } else {
        [TingEVAPlayView sharedTingEVAPlayView].offlineButton.enabled = YES;
        [[TingEVAPlayView sharedTingEVAPlayView] updatePlayProgress:0.0];
    }
}

- (void)changeViewToZero:(QSMusicPlayer *)player {
    NSDictionary *song = player.currentSongDetailed;
    if (![_playStyle isEqualToString:@"EVA"]) {
        if (![song[@"versions"] isEqualToString:@""]) {
            [PlayView sharedPlayView].songLabel.text = [NSString stringWithFormat:@"%@(%@)", song[@"title"], song[@"versions"]];
        } else {
            [PlayView sharedPlayView].songLabel.text = song[@"title"];
        }
        [PlayView sharedPlayView].author.text = song[@"author"];
        [PlayView sharedPlayView].starImgV.image = [UIImage imageNamed:@"bg"];
        [PlayView sharedPlayView].playViewBackImageView.image = nil;
        [PlayView sharedPlayView].currentTime.text = @"00:00";
        [PlayView sharedPlayView].totalTime.text = @"00:00";
        [PlayView sharedPlayView].progressView.progress = 0.0;
        [PlayView sharedPlayView].audioSlider.value = 0.0;
    } else {
        if (![song[@"versions"] isEqualToString:@""]) {
            [TingEVAPlayView sharedTingEVAPlayView].songName.text = [NSString stringWithFormat:@"%@(%@)", song[@"title"], song[@"versions"]];
        } else {
            [TingEVAPlayView sharedTingEVAPlayView].songName.text = song[@"title"];
        }
        [TingEVAPlayView sharedTingEVAPlayView].author.text = song[@"author"];
        [[TingEVAPlayView sharedTingEVAPlayView] changeButtonColorWithIndex:player.currentPlayIndex];
        [[LrcTableView sharedLrcTableView] initLrcWithLrcURL:nil];
        [[TingEVAPlayView sharedTingEVAPlayView] updatePlayProgress:0.0];
        [[TingEVAPlayView sharedTingEVAPlayView] updateCacheProgress:0.0];
        [[TingEVAPlayView sharedTingEVAPlayView] updateCurrentTime:@"00:00"];
    }
    [CSWFlashingAlertView initWithMessage:@"此歌曲无法播放，自动播放下一首"];
}

// 缓存进度0.0~1.0
- (void)player:(QSMusicPlayer * _Nonnull)player updateCacheProgress:(double)progress {
    //NSLog(@"进度%lf", progress);
    if (![_playStyle isEqualToString:@"EVA"]) {
        [PlayView sharedPlayView].progressView.progress = progress;
    } else {
        [[TingEVAPlayView sharedTingEVAPlayView] updateCacheProgress:progress];
    }
}

// 播放时间和进度
- (void)player:(QSMusicPlayer * _Nonnull)player updatePlayTime:(NSInteger)time {
    if (![_playStyle isEqualToString:@"EVA"]) {
        [PlayView sharedPlayView].currentTime.text = [NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60];
        NSInteger total = player.duration;
        [PlayView sharedPlayView].totalTime.text = [NSString stringWithFormat:@"%02ld:%02ld", total/60, total%60];
        UISlider *oneSlider = [PlayView sharedPlayView].audioSlider;
        if(!oneSlider.tracking) {
            if (fabs(time / player.duration - oneSlider.value) > 0.1 && oneSlider.value <= 0.99) {
                return;
            }
            oneSlider.value = time / player.duration;
        }
    } else {
        NSInteger duration = player.duration;
        NSInteger time0 = duration - time;
        if (time == 0) {
            [[TingEVAPlayView sharedTingEVAPlayView] updatePlayProgress:0.0];
        } else {
            [[TingEVAPlayView sharedTingEVAPlayView] updatePlayProgress:(CGFloat)(time / (CGFloat)duration)];
        }
        [[TingEVAPlayView sharedTingEVAPlayView] updateCurrentTime:[NSString stringWithFormat:@"%02ld:%02ld", time0/60, time0%60]];
    }
    
    if (![LrcTableView sharedLrcTableView].tableView.tracking) {
        [[LrcTableView sharedLrcTableView] updateLrcWithCurrentTime:[NSString stringWithFormat:@"%02ld:%02ld", time/60, time%60]];
    }
}

// 播放结束
- (void)playerWillPlayEnd:(QSMusicPlayer * _Nonnull)player {
    NSLog(@"播放结束");
}

#pragma mark - 添加播放控制点
- (UIView *)playPointView {
    if (_playPointView == nil) {
        _playPointView = [[UIView alloc] initWithFrame:CGRectMake(15, QSMUSICSCREEN_HEIGHT - 114, 50, 50)]; //
        _playPointView.backgroundColor = [UIColor lightGrayColor];
        _playPointView.layer.cornerRadius = 25;
        [self addAnimationAndGesture];
        _tempPoint = _playPointView.center;
        _isOpen = NO;
    }
    return _playPointView;
}

- (void)openPlayPoint {
    [self tapGR:nil];
}

- (void)addAnimationAndGesture {
    //物理动效
    _animation = [[UIDynamicAnimator alloc] initWithReferenceView:QSMusicKeyWindow];
    UITapGestureRecognizer * tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [_playPointView addGestureRecognizer:tapGR];
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"playPointTempIsShow"]) {
    //        UIPanGestureRecognizer * panGR=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    //        [self.playPointView addGestureRecognizer:panGR];
    //    }
    UIPanGestureRecognizer * panGR=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [_playPointView addGestureRecognizer:panGR];
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR {
    _playPointView.userInteractionEnabled = NO;
    [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
    [self openPlayPointView];
}

- (void)openPlayPointView {
    _isOpen = !_isOpen;
    if (_isOpen) {
        _tempPoint = _playPointView.center;
        [UIView animateWithDuration:0.3 animations:^{
            _playPointView.center = QSMusicKeyWindow.center;
        } completion:^(BOOL finished) {
            [self performTransactionAnimation];
        }];
    } else {
        _playPointView.alpha = 1.0;
        [_tempPlayViewBackView removeFromSuperview];
        [self performTransactionAnimation];
    }
}

-(void)performTransactionAnimation {
    [self.playPointView pop_removeAllAnimations];
    POPSpringAnimation *boundsAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    boundsAnim.springBounciness = 0;
    boundsAnim.springSpeed = 10;
    [_playPointView.layer pop_addAnimation:boundsAnim forKey:@"AnimateBounds"];
    
    if (_isOpen) {
        _playPointView.layer.cornerRadius = 0;
        boundsAnim.toValue = [NSValue valueWithCGRect:QSMUSICSCREEN_RECT];//动画完成后的fram
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(openPlayView) userInfo:nil repeats:NO];
    } else {
        self.playPointView.layer.cornerRadius = 25;
        boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(movePlayPointView) userInfo:nil repeats:NO];
    }
}

- (void)openPlayView {
    _tempPlayViewBackView = [[UIView alloc] initWithFrame:QSMUSICSCREEN_RECT];
    _tempPlayViewBackView.backgroundColor = [UIColor lightGrayColor];
    [QSMusicRootVC_View addSubview:_tempPlayViewBackView];
    _playPointView.alpha = 0.0;
    if ([_playStyle isEqualToString:@"EVA"]) {
        TingEVAPlayView *player = [TingEVAPlayView sharedTingEVAPlayView];
        __block typeof(player) blockplayer;
        player.contractionBlock = ^{
            [self removePlayView:blockplayer];
        };
        [QSMusicRootVC_View addSubview:player];
        [player displayAnimation];
    } else {
        PlayView *playView = [PlayView sharedPlayView];
        __block typeof(playView) blockplayer;
        playView.contractionBlock = ^{
            [self removePlayView:blockplayer];
        };
        [QSMusicRootVC_View addSubview:playView];
        [playView displayAnimation];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;
    });
}

- (void)removePlayView:(UIView *)playView {
    [playView removeFromSuperview];
    [self tapGR:nil];
}

- (void)movePlayPointView {
    [UIView animateWithDuration:0.3 animations:^{
        _playPointView.center = _tempPoint;
    } completion:^(BOOL finished) {
        _playPointView.userInteractionEnabled = YES;
        [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;
    }];
}

- (void)panGR:(UIPanGestureRecognizer *)panGes{
    if (panGes.state == UIGestureRecognizerStateBegan) {
        [_animation removeAllBehaviors];
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [panGes translationInView:QSMusicKeyWindow];
        CGPoint center = _playPointView.center;
        center.x += offset.x;
        center.y += offset.y;
        _playPointView.center = center;
        [panGes setTranslation:CGPointZero inView:QSMusicKeyWindow];
    }
}

- (void)downloadSong {
    QSMusicPlayer *player = [QSMusicPlayer sharedInstance];
    NSDictionary *song = player.currentSongDetailed;
    NSArray *dataArr = [QSMusicSongDatas MR_findAll];
    //NSLog(@"id:%@", song[@"songid"]);
    //NSLog(@"dataArr:%@", dataArr);
    for (QSMusicSongDatas *oneModel in dataArr) {
        if ([oneModel.songid isEqualToString:song[@"songid"]]) {
            [CSWFlashingAlertView initWithMessage:@"此歌曲已经离线下载到本地"];
            return;
        }
    }
    NSURL *url=[NSURL URLWithString:song[@"song_file_link"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //NSLog(@"缓存的位置 %@", targetPath);
        //下载后的文件路径
        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //下载后的文件名
        return [downloadURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", song[@"songid"]]];
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        QSMusicSongDatas *model = [QSMusicSongDatas MR_createEntity];
        model.songid = song[@"songid"];
        model.title = song[@"title"];
        model.versions = song[@"versions"];
        model.author = song[@"author"];
        model.lrclink = [LrcTableView sharedLrcTableView].lrc;
        model.pic_radio = song[@"pic_radio"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [CSWFlashingAlertView initWithMessage:@"离线完成"];
    }];
    [downloadTask resume];
}

@end
