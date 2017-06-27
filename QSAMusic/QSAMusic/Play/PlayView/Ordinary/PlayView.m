//
//  PlayView.m
//  TingDemo
//
//  Created by 007 on 16/6/12.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import "PlayView.h"
#import "ListTableViewDelegate.h"
#import "QSMusicRemoteEvent.h"
#import "QSMusicEQSetView.h"
#import "LrcTableView.h"

// 滑动方向
typedef NS_ENUM(NSInteger, CameraMoveDirection) {
    kCameraMoveDirectionNone  = 0,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft,
};

@interface PlayView () <CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *hideButton;                   //退出播放界面按钮
@property (weak, nonatomic) IBOutlet UIButton *hiddenTableButton;            //切换列表按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (nonatomic) CameraMoveDirection		direction;			         // 方向
@property (nonatomic) NSTimeInterval            curtime;

@property (nonatomic) BOOL isLrc;
@property (weak, nonatomic) IBOutlet UIButton *lrcButton;
@property (nonatomic) BOOL isList;
@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (nonatomic) QSAKitBlurView *blurBackgroundView;

@end

@implementation PlayView

+ (instancetype)sharedPlayView {
    static PlayView *sharedPlayView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:@"PlayView" bundle:nil];
        sharedPlayView = [[nib instantiateWithOwner:nil options:nil] firstObject];
        sharedPlayView.frame = ScreenRect;
        sharedPlayView.alpha = 0.0;
        [sharedPlayView customSubView];
        [sharedPlayView.hideButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayView.hiddenTableButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayView.lrcButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayView.listButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayView addPanGesture];
        [sharedPlayView.listTbV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCellid"];
        sharedPlayView.listTbV.delegate = [ListTableViewDelegate sharedListTableViewDelegate];
        sharedPlayView.listTbV.dataSource = [ListTableViewDelegate sharedListTableViewDelegate];
    });
    return sharedPlayView;
}

- (void)customSubView {
    if (_playButtonView == nil) {
        _playButtonView = [PlayButtonView sharedPlayButtonViewWithHeight:self.playBottomView.bounds.size.height];
        _playButtonView.alpha = 1.0;
        [self addSubview:_playButtonView];
    }
}

- (void)displayAnimation {
    _hideButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.delegate = self;
        opacityAnimation.fromValue = @(0.0);
        opacityAnimation.toValue = @(1.0);
        opacityAnimation.duration = 0.3;
        [self.layer removeAllAnimations];
        [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            _playButtonView.frame = CGRectMake(0, ScreenHeight - self.playBottomView.bounds.size.height, ScreenWidth, self.playBottomView.bounds.size.height);
        }];
        self.superview.userInteractionEnabled = YES;
    }];
}

- (void)hideAnimation {
    _hideButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _playButtonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.playBottomView.bounds.size.height);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            //opacityAnimation.delegate = self;
            opacityAnimation.fromValue = @(1.0);
            opacityAnimation.toValue = @(0.0);
            opacityAnimation.duration = 0.4;
            [self.layer removeAllAnimations];
            [self.layer addAnimation:opacityAnimation forKey:@"opacity"];
        } completion:^(BOOL finished) {
            self.alpha = 0.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.contractionBlock) {
                    self.contractionBlock();
                }
            });
        }];
    }];
}

- (IBAction)hiddenAction:(UIButton *)sender {
    [self hideAnimation];
}

- (void)updataListWithData:(NSArray *)dataArr {
    ListTableViewDelegate *delegate = [ListTableViewDelegate sharedListTableViewDelegate];
    delegate.songList = dataArr;
    [delegate setSelectedBlock:^(NSInteger row) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:row inSection:0];
        [_listTbV selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }];
    [_listTbV reloadData];
}

#pragma mark - 词、图、列表切换
- (IBAction)hiddenTableAction:(id)sender {
    NSInteger tag = ((UIButton *)sender).tag;
    switch (tag) {
        case 0:
            [self listAction];
            break;
        case 1:
            [self lrcAction];
            break;
        default:
            break;
    }
}

- (void)listAction {
    _isList = !_isList;
    if (_isList) {
        [_listButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_listButton setTitle:@"图" forState:UIControlStateNormal];
        _listTbV.alpha = 1.0;
        _starImgV.alpha = 0.0;
        if (_isLrc) {
            [_blurBackgroundView removeFromSuperview];
            [_lrcButton setTitle:@"词" forState:UIControlStateNormal];
            _isLrc = !_isLrc;
        }
    } else {
        [_listButton setBackgroundImage:[UIImage imageNamed:@"ci1.png"] forState:UIControlStateNormal];
        [_listButton setTitle:@"" forState:UIControlStateNormal];
        _listTbV.alpha = 0.0;
        _starImgV.alpha = 1.0;
    }
}

- (void)lrcAction {
    _isLrc = !_isLrc;
    if (_isLrc) {
        if (_isList) {
            _listTbV.alpha = 0.0;
            [_listButton setBackgroundImage:[UIImage imageNamed:@"ci1.png"] forState:UIControlStateNormal];
            [_listButton setTitle:@"" forState:UIControlStateNormal];
            _isList = !_isList;
        }
        [_lrcButton setTitle:@"图" forState:UIControlStateNormal];
        _blurBackgroundView = [[QSAKitBlurView alloc] initWithFrame:_starImgV.frame type:Blur_whiteColor];
        [self addSubview:_blurBackgroundView];
        [_blurBackgroundView contentViewAddSubview:[LrcTableView sharedLrcTableView].tableView];
        _starImgV.alpha = 0.0;
    } else {
        [_lrcButton setTitle:@"词" forState:UIControlStateNormal];
        [_blurBackgroundView removeFromSuperview];
        _starImgV.alpha = 1.0;
    }
}

#pragma mark - 进度、音量调节
- (IBAction)onProgressChanged:(UISlider *)sender {
    if (!sender.isTracking && sender.isTouchInside) {
        [[PlayerController shared] playWithOffset:sender.value];
    }
}

- (void)addPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(panAction:)];
    [_starImgV addGestureRecognizer:pan];
    _starImgV.userInteractionEnabled = YES;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] VolumeAndScheduleControl:recognizer view:self style:1];
}

#pragma mark - 收藏
- (IBAction)scAction:(id)sender {
    
}

#pragma mark
- (void)drawRect:(CGRect)rect {
    if (ScreenWidth == 375) {
        _topHeight.constant = 58.0;
    } else if (ScreenWidth == 414) {
        _topHeight.constant = 75.0;
    } else {
        _topHeight.constant = 38.0;
    }
}

@end
