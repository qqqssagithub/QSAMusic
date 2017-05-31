//
//  QSMusicEQSetView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/17.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicEQSetView.h"

@interface QSMusicEQSetView ()

@property (weak, nonatomic) IBOutlet UISlider *eq31;
@property (weak, nonatomic) IBOutlet UISlider *eq62;
@property (weak, nonatomic) IBOutlet UISlider *eq125;
@property (weak, nonatomic) IBOutlet UISlider *eq250;
@property (weak, nonatomic) IBOutlet UISlider *eq500;
@property (weak, nonatomic) IBOutlet UISlider *eq1k;
@property (weak, nonatomic) IBOutlet UISlider *eq2k;
@property (weak, nonatomic) IBOutlet UISlider *eq4k;
@property (weak, nonatomic) IBOutlet UISlider *eq8k;
@property (weak, nonatomic) IBOutlet UISlider *eq16k;

@property (weak, nonatomic) IBOutlet UIButton *custom;
@property (weak, nonatomic) IBOutlet UIButton *pop;
@property (weak, nonatomic) IBOutlet UIButton *heavyBass;
@property (weak, nonatomic) IBOutlet UIButton *voice;
@property (weak, nonatomic) IBOutlet UIButton *rock;
@property (weak, nonatomic) IBOutlet UIButton *classical;
@property (weak, nonatomic) IBOutlet UIButton *jazz;
@property (weak, nonatomic) IBOutlet UIButton *dance;
@property (weak, nonatomic) IBOutlet UIButton *electronics;


@end

@implementation QSMusicEQSetView

+ (instancetype)shared {
    static QSMusicEQSetView *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINib *nib = [UINib nibWithNibName:@"QSMusicEQSetView" bundle:nil];
        shared = [[nib instantiateWithOwner:nil options:nil] firstObject];
        shared.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    });
    return shared;
}

- (void)show {
    [QSAMusicKeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}

- (IBAction)back:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)setDB:(UISlider *)sender {
    if (!sender.isTracking) {
        [self updateValueWithIndex:sender.tag - 30 gain:sender.value];
    }
}

- (void)updateValueWithIndex:(NSInteger)index gain:(float)gain {
    for (NSInteger i = 0; i < 9; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    UIButton *btn0 = (UIButton *)[self viewWithTag:100];
    [btn0 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [[QSAAudioPlayer shared] updateEQWithBandIndex:index gain:gain];
}

- (IBAction)styleAction:(UIButton *)sender {
    for (NSInteger i = 0; i < 9; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    UIButton *btn0 = (UIButton *)[self viewWithTag:sender.tag];
    [btn0 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self setStyleWithIndex:sender.tag - 100];
}

- (void)setStyleWithIndex:(NSInteger)index {
    NSArray *gain0 = @[@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0"];
    NSArray *gain1 = @[@"0", @"0", @"0", @"0", @"0", @"1", @"2", @"2", @"2", @"1"];
    NSArray *gain2 = @[@"6", @"9", @"10", @"10", @"10", @"3", @"0", @"-1", @"-5", @"-3"];
    NSArray *gain3 = @[@"-3", @"-5", @"-6", @"-6", @"-6", @"3", @"6", @"5", @"-4", @"-3"];
    NSArray *gain4 = @[@"3", @"4", @"5", @"5", @"5", @"-3", @"-6", @"-5", @"+4", @"+3"];
    NSArray *gain5 = @[@"0", @"0", @"1", @"1", @"1", @"2", @"2", @"2", @"-1", @"-1"];
    NSArray *gain6 = @[@"0", @"0", @"0", @"0", @"0", @"3", @"5", @"5", @"3", @"1"];
    NSArray *gain7 = @[@"3", @"4", @"5", @"5", @"5", @"6", @"6", @"5", @"-5", @"-4"];
    NSArray *gain8 = @[@"-6", @"-9", @"-10", @"-10", @"-10", @"-1", @"2", @"3", @"10", @"6"];
    NSArray *gain = @[gain0, gain1, gain2, gain3, gain4, gain5, gain6, gain7, gain8];

    for (NSInteger i = 0; i < 10; i ++) {
        UISlider *slider = (UISlider *)[self viewWithTag:i + 30];
        slider.value = [gain[index][i] floatValue];
    }
    [[QSAAudioPlayer shared] updateEQWithGains:gain[index]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
