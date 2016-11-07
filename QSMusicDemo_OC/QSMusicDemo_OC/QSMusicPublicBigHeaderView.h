//
//  QSMusicPublicBigHeaderView.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/8.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicPublicBigHeaderView : UIView

@property (nonatomic) UIImageView *topImgV;
@property (nonatomic) CSWBlurBackgroundView *topImgVOcclusionView;
@property (nonatomic) UITableView *bottomTableView;
@property (nonatomic) CSWBlurBackgroundView *tempHeaderView;
@property (nonatomic) UILabel *tempHeaderLabel;

@property (nonatomic) UIView *supView;

@property (nonatomic) void (^backBlock)(void);

+ (instancetype)sharedQSMusicPublicBigHeaderView;

- (void)updateWithHeaderInfo:(NSDictionary *)headerInfo songList:(NSArray *)list;

- (void)updateWithData:(NSDictionary *)data;

@end
