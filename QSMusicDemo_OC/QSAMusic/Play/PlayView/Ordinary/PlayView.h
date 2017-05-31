//
//  PlayView.h
//  TingDemo
//
//  Created by 007 on 16/6/12.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayButtonView.h"

@interface PlayView : UIView

@property (weak, nonatomic) IBOutlet UISlider *audioSlider;                  //播放进度条
@property (nonatomic) float audioSliderCurrentValue;                         //记录播放进度条当前的进度
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;           //缓存进度条
@property (weak, nonatomic) IBOutlet UILabel *currentTime;                   //显示当前时间的label
@property (weak, nonatomic) IBOutlet UILabel *totalTime;                     //显示总时间的label
@property (nonatomic) NSInteger totalSecond;
@property (weak, nonatomic) IBOutlet UIView *playBottomView;

@property (weak, nonatomic) IBOutlet UIImageView *playViewBackImageView;     //播放界面背景图片,做了模糊处理
@property (weak, nonatomic) IBOutlet UILabel *songLabel;                     //歌曲名
@property (weak, nonatomic) IBOutlet UILabel *author;                        //歌手名
@property (weak, nonatomic) IBOutlet UIImageView *starImgV;                  //歌曲图片

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) PlayButtonView  *playButtonView;                       //底部控制播放的按钮界面

@property (nonatomic, copy) void(^contractionBlock)();                       //隐藏完成后的回调

@property (weak, nonatomic) IBOutlet UIImageView *scImgV;
@property (weak, nonatomic) IBOutlet UIButton *scButton;
@property (nonatomic) BOOL isLoad;

@property (weak, nonatomic) IBOutlet UITableView *listTbV;

+ (instancetype)sharedPlayView;

/**
 *显示动画
 */
- (void)displayAnimation;

/**
 *隐藏动画
 */
- (void)hideAnimation;

- (void)updataListWithData:(NSArray *)dataArr;

@end
