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

- (IBAction)back:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)setDB:(UISlider *)sender {
    if (!sender.isTracking) {
        switch (sender.tag) {
            case 31: {
                [self updateValueWithIndex:0 centerFrequency:31 gain:sender.value];
                break;
            }
            case 62: {
                [self updateValueWithIndex:1 centerFrequency:62 gain:sender.value];
                break;
            }
            case 125: {
                [self updateValueWithIndex:2 centerFrequency:125 gain:sender.value];
                break;
            }
            case 250: {
                [self updateValueWithIndex:3 centerFrequency:250 gain:sender.value];
                break;
            }
            case 500: {
                [self updateValueWithIndex:4 centerFrequency:500 gain:sender.value];
                break;
            }
            case 1000: {
                [self updateValueWithIndex:5 centerFrequency:1000 gain:sender.value];
                break;
            }
            case 2000: {
                [self updateValueWithIndex:6 centerFrequency:2000 gain:sender.value];
                break;
            }
            case 4000: {
                [self updateValueWithIndex:7 centerFrequency:4000 gain:sender.value];
                break;
            }
            case 8000: {
                [self updateValueWithIndex:8 centerFrequency:8000 gain:sender.value];
                break;
            }
            case 16000: {
                [self updateValueWithIndex:9 centerFrequency:16000 gain:sender.value];
                break;
            }
            default:
                break;
        }
    }
}

- (void)updateValueWithIndex:(NSInteger)index centerFrequency:(double)centerFrequency gain:(double)gain {
    for (NSInteger i = 0; i < 9; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    UIButton *btn0 = (UIButton *)[self viewWithTag:100];
    [btn0 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    if (_setDBBlock) {
        _setDBBlock(index, centerFrequency, gain);
    }
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
    
    NSArray *centerFrequencys = @[@"31", @"62", @"125", @"250", @"500", @"1000", @"2000", @"4000", @"8000", @"16000"];
    for (NSInteger i = 0; i < 9; i ++) {
        UISlider *slider = (UISlider *)[self viewWithTag:[centerFrequencys[i] integerValue]];
        slider.value = [gain[index][i] floatValue];
    }
    if ((_setDBWithStyleBlock)) {
        _setDBWithStyleBlock(gain[index]);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
