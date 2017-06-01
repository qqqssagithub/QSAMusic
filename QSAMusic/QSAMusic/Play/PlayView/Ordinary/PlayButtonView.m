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
#import "QSMusicEQSetView.h"

@implementation PlayButtonView

+ (instancetype)sharedPlayButtonViewWithHeight:(CGFloat)height {
    static PlayButtonView *sharedPlayButtonView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:@"PlayButtonView" bundle:nil];
        sharedPlayButtonView = [[nib instantiateWithOwner:nil options:nil] firstObject];
        //sharePlayButtonView.cycleMode = CirculationModeIsCycle;
        sharedPlayButtonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, height);
        [sharedPlayButtonView.cycleButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.previousButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.playButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.nextButton setShowsTouchWhenHighlighted:YES];
        [sharedPlayButtonView.otherButton setShowsTouchWhenHighlighted:YES];
        sharedPlayButtonView.currentLoop = 0;
    });
    return sharedPlayButtonView;
}

- (void)loopButton:(UIButton *)btn {
    [self buttonAction:btn];
}

//全部按钮的响应方法
- (IBAction)buttonAction:(UIButton *)oneButton {
    switch (oneButton.tag) {
        case 201:
            [self cycleModeWithTitle:[[PlayerController shared] changePlayMode]];
            break;
        case 202:
            [[PlayerController shared] playPreviousIndex];
            break;
        case 203:
            [[PlayerController shared] playAndPause];
            break;
        case 204:
            [[PlayerController shared] playNextIndex];
            break;
        case 205: {
            [[QSMusicEQSetView shared] show];
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
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth /2 -50, ScreenHeight - 22 - self.bounds.size.height, 100, 44)];
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

@end
