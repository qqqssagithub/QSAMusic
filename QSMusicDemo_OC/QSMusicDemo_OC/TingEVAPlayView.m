//
//  TingEVAPlayView.m
//  TingDemo
//
//  Created by 007 on 16/6/21.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import "TingEVAPlayView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QSMusicRemoteEvent.h"

// 滑动方向
typedef NS_ENUM(NSInteger, CameraMoveDirection) {
    kCameraMoveDirectionNone  = 0,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft,
};

@interface TingEVAPlayView ()

@property (nonatomic) UIImageView *progressAndVolumeView;
@property (nonatomic) BOOL isExpand;
@property (nonatomic) CameraMoveDirection		direction;			         // 方向
@property (nonatomic) NSTimeInterval            curtime;
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIView *mediumScreen;
@property (weak, nonatomic) IBOutlet UIView *largeScreen0;
@property (weak, nonatomic) IBOutlet UIView *largeScreen1;
@property (weak, nonatomic) IBOutlet UIButton *lrcButton;
@property (nonatomic) UIImageView *lrcView;
@property (nonatomic) BOOL isLrc;
@property (nonatomic) CGPoint tempPoint;

@end

@implementation TingEVAPlayView

+ (instancetype)sharedTingEVAPlayView {
    static TingEVAPlayView *sharedTingEVAPlayView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:@"TingEVAPlayView" bundle:nil];
        sharedTingEVAPlayView = [[nib instantiateWithOwner:nil options:nil] firstObject];
        sharedTingEVAPlayView.frame = QSMUSICSCREEN_RECT;
        sharedTingEVAPlayView.alpha = 0.0;
        [sharedTingEVAPlayView.hideButton setShowsTouchWhenHighlighted:YES];
    });
    return sharedTingEVAPlayView;
}

#pragma mark - 显示动画
- (void)displayAnimation {
    _hideButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.4 animations:^{
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //opacityAnimation.delegate = self;
        opacityAnimation.fromValue = @(0.0);
        opacityAnimation.toValue = @(1.0);
        opacityAnimation.duration = 0.4;
        [self.layer removeAllAnimations];
        [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        self.superview.userInteractionEnabled = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSphereView];
            [self bringSubviewToFront:_lrcView];
        });
        
    }];
}

- (void)addSphereView {
    [self addSubview:self.sphereView];
    if (!QSMusicPlayer.isPlaying) {
        [_sphereView timerStop];
        _sphereView.isLoop = NO;
    }
    _hideButton.userInteractionEnabled = NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showPrompt3"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CSWAlertView initWithTitle:nil message:@"可以滚动中间的圆球挑选自己喜欢的歌曲" cancelButtonTitle:@"确定"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showPrompt3"];
            _hideButton.userInteractionEnabled = YES;
        });
    } else {
        _hideButton.userInteractionEnabled = YES;
    }
}

- (DBSphereView *)sphereView{
    _sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    _sphereView.center = _bg.center;
    _buttonArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        NSDictionary* dict = [_dataArr objectAtIndex:i];
        [btn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        //NSLog(@"title:%@", dict[@"title"]);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == _currentIndex) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        btn.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.frame = CGRectMake(0, 0, 30, 30);
        btn.titleLabel.numberOfLines = 2;
        //[btn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2]];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArr addObject:btn];
        [_sphereView addSubview:btn];
    }
    [_sphereView setCloudTags:_buttonArr];
    _sphereView.backgroundColor = [UIColor clearColor];
    return _sphereView;
}

- (void)sphereViewStop {
    [_sphereView timerStop];
}

- (void)sphereViewStart {
    [_sphereView timerStart];
}

- (void)buttonPressed:(UIButton *)btn{
    UIButton *button = _buttonArr[_currentIndex];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QSMusicPlayer playAtIndex:btn.tag];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _currentIndex = btn.tag;
}

#pragma mark - 隐藏动画
- (IBAction)hideAction:(id)sender {
    [self hideAnimation];
}

- (void)hideAnimation {
    _hideButton.userInteractionEnabled = NO;
    [_sphereView removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:^{
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //opacityAnimation.delegate = self;
        opacityAnimation.fromValue = @(1.0);
        opacityAnimation.toValue = @(0.0);
        opacityAnimation.duration = 0.4;
        [self.layer removeAllAnimations];
        [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.contractionBlock) {
                self.contractionBlock();
            }
        });
    }];
}

#pragma mark - 歌词
- (IBAction)lrcButtonAction:(id)sender {
    _isLrc = !_isLrc;
    [_lrcView pop_removeAllAnimations];
    POPSpringAnimation *frameAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnim.springBounciness = 0;
    frameAnim.springSpeed = 10;
    [_lrcView pop_addAnimation:frameAnim forKey:@"AnimateFrame"];
    if (_isLrc) {//展开
        frameAnim.toValue = [NSValue valueWithCGRect:CGRectMake(_tempPoint.x -120, _tempPoint.y +19, QSMUSICSCREEN_WIDTH - 80, QSMUSICSCREEN_WIDTH)];//动画完成后的fram
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _lrcView.backgroundColor = [UIColor clearColor];
            UIImage *tempImage = [CSWScreenShot screenShotWithRect:_lrcView.frame];
            UIImage *blurImage = [tempImage blurWithRadius:8.0 tintColor:[UIColor whiteColor]];
            _lrcView.image = blurImage;
            [_lrcView addSubview:[LrcTableView sharedLrcTableView].tableView];
            [LrcTableView sharedLrcTableView].tableView.frame = CGRectMake(8, 8, 240 -16, 320 -16);
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showPrompt0"]) {
                [CSWAlertView initWithTitle:nil message:@"在歌词界面可以上下滑动浏览歌词\n点击某一行即会播放此行\n再次点击歌词按钮\n歌词界面消失" cancelButtonTitle:@"确定"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showPrompt0"];
            }
        });
    } else {//收缩
        [[LrcTableView sharedLrcTableView].tableView removeFromSuperview];
        frameAnim.toValue = [NSValue valueWithCGRect:CGRectMake(_tempPoint.x -10, _tempPoint.y +19, 20, 2)];
        _lrcView.backgroundColor = [UIColor redColor];
        _lrcView.image = nil;
    }
}

#pragma mark - 控制器按钮
- (IBAction)buttonAction:(UIButton *)btn {
    switch (btn.tag) {
        case 201: { //循环
            [self cycleModeWithTitle:[QSMusicPlayer changePlayMode]];
        }            break;
        case 202: { //shang
            [QSMusicPlayer playPreviousIndex];
        }
            break;
        case 203:
            if (_sphereView.isLoop) {
                [QSMusicPlayer pause];
                [_sphereView timerStop];
            } else {
                [QSMusicPlayer play];
                [_sphereView timerStart];
            }
            break;
        case 204: { //xia
            [QSMusicPlayer playNextIndex];
        }
            break;
        case 205: { //离线
            _offlineButton.enabled = NO;
            [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] downloadSong];
        }
            break;
            
        default:
            break;
    }
}

- (void)cycleModeWithTitle:(NSString *)title {
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH /2 -70, QSMUSICSCREEN_HEIGHT /2 -150, 140, 44)];
    redView.layer.cornerRadius = 5;
    redView.layer.masksToBounds = YES;
    redView.backgroundColor = [UIColor redColor];
    [self addSubview:redView];
    UILabel *netLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 140, 20)];
    netLabel.text = title;
    netLabel.textAlignment = NSTextAlignmentCenter;
    netLabel.textColor = [UIColor blackColor];
    [redView addSubview:netLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [redView removeFromSuperview];
    });
}

- (void)changeButtonColorWithIndex:(NSInteger)index {
    UIButton *button = _buttonArr[_currentIndex];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *button0 = _buttonArr[index];
    [button0 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _currentIndex = index;
}

#pragma mark - 界面进度更新
- (void)updateCacheProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1.0];
    _cacheProgressShapeLayer.strokeEnd = progress;
    [CATransaction commit];
}

- (void)updatePlayProgress:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1.0];
    _cacheProgressShapeLayer.strokeStart = progress;
    _playProgressShapeLayer.strokeStart = progress;
    [CATransaction commit];
}

- (void)updateCurrentTime:(NSString *)timeStr {
    _currentTimeLabel.text = timeStr;
}

#pragma mark - 初始化界面
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (QSMUSICSCREEN_WIDTH > 320 && QSMUSICSCREEN_WIDTH < 414) {
        _largeScreen0.alpha = 0.0;
        _largeScreen1.alpha = 0.0;
    } else if (QSMUSICSCREEN_WIDTH <= 320) {
        _mediumScreen.alpha = 0.0;
        _largeScreen0.alpha = 0.0;
        _largeScreen1.alpha = 0.0;
    }
    [self sendSubviewToBack:_bg];
    [self addProgressBar];
    _cacheProgressShapeLayer.strokeEnd = 0.0;
    _progressAndVolumeView = [[UIImageView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH -70, QSMUSICSCREEN_HEIGHT -68, 20, 2)];
    _progressAndVolumeView.backgroundColor = [UIColor redColor];
    [self addSubview:_progressAndVolumeView];
    [self addPanGesture];
    UIImageView *topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 2 -20, 40, 40)];
    topImgV.image = [UIImage imageNamed:@"2_3.png"];
    [_progressAndVolumeView addSubview:topImgV];
    UILabel *top = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 20, 12)];
    top.text = @"进度";
    top.textColor = [UIColor redColor];
    [top setFont:[UIFont systemFontOfSize:9.0]];
    [topImgV addSubview:top];
    UIImageView *bottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH -70 -10, QSMUSICSCREEN_HEIGHT -68 -18, 40, 40)];
    bottomImgV.image = [UIImage imageNamed:@"2_2.png"];
    [self addSubview:bottomImgV];
    UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(10, 21, 20, 12)];
    bottom.text = @"音量";
    bottom.textColor = [UIColor redColor];
    [bottom setFont:[UIFont systemFontOfSize:9.0]];
    [bottomImgV addSubview:bottom];
    
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    UITapGestureRecognizer *tapGR0=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    [_progressAndVolumeView addGestureRecognizer:tapGR0];
    [bottomImgV addGestureRecognizer:tapGR];
    _progressAndVolumeView.userInteractionEnabled = YES;
    bottomImgV.userInteractionEnabled = YES;

    _tempPoint = _lrcButton.center;
    _lrcView = [[UIImageView alloc] initWithFrame:CGRectMake(_tempPoint.x -10, _tempPoint.y +19, 20, 2)];
    _lrcView.backgroundColor = [UIColor redColor];
    [self addSubview:_lrcView];
    _lrcView.userInteractionEnabled = YES;
}

- (void)addProgressBar {
    CGFloat diameter = 230.0;
    
    _playProgressShapeLayer = [CAShapeLayer layer];
    CGRect rect = {1, 1, diameter - 2, diameter - 2};
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    _playProgressShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _playProgressShapeLayer.lineWidth = 3;
    _playProgressShapeLayer.fillColor =  [UIColor clearColor].CGColor;
    _playProgressShapeLayer.lineCap = kCALineCapRound;
    _playProgressShapeLayer.path = path.CGPath;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    [view.layer addSublayer:_playProgressShapeLayer];
    view.center = _bg.center;
    [self addSubview:view];
    view.transform = CGAffineTransformMakeRotation(-M_PI_2 *3);
    
    
    _cacheProgressShapeLayer = [CAShapeLayer layer];
    _cacheProgressShapeLayer.strokeColor = [UIColor grayColor].CGColor;
    _cacheProgressShapeLayer.lineWidth = 3;
    _cacheProgressShapeLayer.fillColor =  [UIColor clearColor].CGColor;
    _cacheProgressShapeLayer.lineCap = kCALineCapRound;
    _cacheProgressShapeLayer.path = path.CGPath;
    UIView *cacheProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    [cacheProgressView.layer addSublayer:_cacheProgressShapeLayer];
    cacheProgressView.center = view.center;
    [self addSubview:cacheProgressView];
    cacheProgressView.transform = CGAffineTransformMakeRotation(-M_PI_2 *3);
}

#pragma mark - 展开进度、音量调节界面
-(void)tapGR:(UITapGestureRecognizer *)tapGR {
    [self bringSubviewToFront:_progressAndVolumeView];
    _progressAndVolumeView.userInteractionEnabled = NO;
    _isExpand = !_isExpand;
    [self performTransactionAnimation];
}

-(void)performTransactionAnimation {
    [_progressAndVolumeView pop_removeAllAnimations];
    POPSpringAnimation *frameAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    frameAnim.springBounciness = 0;
    frameAnim.springSpeed = 10;
    [_progressAndVolumeView pop_addAnimation:frameAnim forKey:@"AnimateFrame"];
    if (_isExpand) {//展开
        frameAnim.toValue = [NSValue valueWithCGRect:CGRectMake(QSMUSICSCREEN_WIDTH -50 -(QSMUSICSCREEN_WIDTH -120), QSMUSICSCREEN_HEIGHT -66 -(QSMUSICSCREEN_HEIGHT -288), QSMUSICSCREEN_WIDTH -120, QSMUSICSCREEN_HEIGHT -288)];//动画完成后的fram
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _progressAndVolumeView.backgroundColor = [UIColor clearColor];
            UIImage *tempImage = [CSWScreenShot screenShotWithRect:_progressAndVolumeView.frame];
            _progressAndVolumeView.image = [tempImage blurWithRadius:8.0 tintColor:[UIColor whiteColor]];
            _progressAndVolumeView.userInteractionEnabled = YES;
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showPrompt1"]) {
                [CSWAlertView initWithTitle:nil message:@"在出现的进度/音量界面上\n左右/上下滑动\n分别调节进度/音量\n直接点击界面则消失" cancelButtonTitle:@"确定"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showPrompt1"];
            }
        });
    } else {//收缩
        frameAnim.toValue = [NSValue valueWithCGRect:CGRectMake(QSMUSICSCREEN_WIDTH -70, QSMUSICSCREEN_HEIGHT -68, 20, 2)];
        _progressAndVolumeView.backgroundColor = [UIColor redColor];
        _progressAndVolumeView.image = nil;
    }
}

- (void)addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(panAction:)];
    [_progressAndVolumeView addGestureRecognizer:pan];
    _progressAndVolumeView.userInteractionEnabled = YES;
}

#pragma mark 进度、音量调节
- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] VolumeAndScheduleControl:recognizer view:self style:0];
}

@end
