//
//  TingEVAPlayView.h
//  TingDemo
//
//  Created by 007 on 16/6/21.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBSphereView.h"

@interface TingEVAPlayView : UIView

@property (nonatomic, retain) DBSphereView *sphereView;
@property (nonatomic) NSArray *dataArr;
@property (nonatomic) NSString *songTitle;
@property (nonatomic) NSString *songAuthor;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSMutableArray *buttonArr;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *author;

@property (nonatomic) CAShapeLayer *cacheProgressShapeLayer; //加载进度
@property (nonatomic) CAShapeLayer *playProgressShapeLayer; //加载进度

@property (nonatomic, copy) void(^contractionBlock)();       //隐藏完成后的回调
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;

+ (instancetype)sharedTingEVAPlayView;

- (void)updateCacheProgress:(CGFloat)progress;
- (void)updatePlayProgress:(CGFloat)progress;
- (void)updateCurrentTime:(NSString *)timeStr;
- (void)sphereViewStop;
- (void)sphereViewStart;

- (void)changeButtonColorWithIndex:(NSInteger)index;

/**
 *显示动画
 */
- (void)displayAnimation;

/**
 *隐藏动画
 */
- (void)hideAnimation;

@end
