//
//  QSMusicPublicBigHeaderView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/8.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicPublicBigHeaderView.h"
#import "QSMusicPublicBigHeaderViewDelegate.h"

@implementation QSMusicPublicBigHeaderView

+ (instancetype)sharedQSMusicPublicBigHeaderView {
    static QSMusicPublicBigHeaderView *sharedQSMusicPublicBigHeaderView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicPublicBigHeaderView = [[QSMusicPublicBigHeaderView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT)];
        sharedQSMusicPublicBigHeaderView.backgroundColor = [UIColor whiteColor];
        sharedQSMusicPublicBigHeaderView.topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_WIDTH)];
        sharedQSMusicPublicBigHeaderView.topImgV.backgroundColor = [UIColor lightGrayColor];
        [sharedQSMusicPublicBigHeaderView addSubview:sharedQSMusicPublicBigHeaderView.topImgV];
        sharedQSMusicPublicBigHeaderView.topImgVOcclusionView = [[CSWBlurBackgroundView alloc] initWithFrame:sharedQSMusicPublicBigHeaderView.topImgV.frame color:blackColor];
        sharedQSMusicPublicBigHeaderView.topImgVOcclusionView.alpha = 0.0;
        [sharedQSMusicPublicBigHeaderView.topImgV addSubview:sharedQSMusicPublicBigHeaderView.topImgVOcclusionView];
        sharedQSMusicPublicBigHeaderView.bottomTableView = [QSMusicPublicBigHeaderViewDelegate sharedQSMusicPublicBigHeaderViewDelegate].tableView;
        sharedQSMusicPublicBigHeaderView.bottomTableView.backgroundColor = [UIColor clearColor];
        [sharedQSMusicPublicBigHeaderView addSubview:sharedQSMusicPublicBigHeaderView.bottomTableView];
        
        sharedQSMusicPublicBigHeaderView.tempHeaderView = [[CSWBlurBackgroundView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 70) color:blackColor];
        //sharedQSMusicPublicBigHeaderView.tempHeaderView.backgroundColor = [UIColor redColor];
        sharedQSMusicPublicBigHeaderView.tempHeaderLabel = [[UILabel alloc] init];
        sharedQSMusicPublicBigHeaderView.tempHeaderLabel.frame = CGRectMake(0, 0, QSMUSICSCREEN_WIDTH - 100, 30);
        sharedQSMusicPublicBigHeaderView.tempHeaderLabel.textAlignment = 1;
        sharedQSMusicPublicBigHeaderView.tempHeaderLabel.textColor = [UIColor whiteColor];
        [sharedQSMusicPublicBigHeaderView.tempHeaderView addEffectView:sharedQSMusicPublicBigHeaderView.tempHeaderLabel];
        sharedQSMusicPublicBigHeaderView.tempHeaderLabel.center = CGPointMake(sharedQSMusicPublicBigHeaderView.tempHeaderView.center.x, sharedQSMusicPublicBigHeaderView.tempHeaderView.center.y +5);
        [sharedQSMusicPublicBigHeaderView addSubview:sharedQSMusicPublicBigHeaderView.tempHeaderView];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"<<" forState:UIControlStateNormal];
        [button addTarget:sharedQSMusicPublicBigHeaderView action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(12, 25, 30, 30);
        [sharedQSMusicPublicBigHeaderView addSubview:button];
    });
    return sharedQSMusicPublicBigHeaderView;
}

- (void)back {
    if (_backBlock) {
        _backBlock();
    }
}

- (void)updateWithHeaderInfo:(NSDictionary *)headerInfo songList:(NSArray *)list {
    [_topImgV sd_setImageWithURL:[NSURL URLWithString:headerInfo[@"pic_radio"]]];
    [[QSMusicPublicBigHeaderViewDelegate sharedQSMusicPublicBigHeaderViewDelegate] updateWithHeaderInfo:headerInfo songList:list view:self];
}

- (void)updateWithData:(NSDictionary *)data {
    [_topImgV sd_setImageWithURL:[NSURL URLWithString:data[@"pic_w700"]]];
    NSDictionary *dic = @{@"info": data[@"desc"], @"buy_url": @"", @"title": data[@"title"], @"author": @""};
    NSArray *list = data[@"content"];
    [[QSMusicPublicBigHeaderViewDelegate sharedQSMusicPublicBigHeaderViewDelegate] updateWithHeaderInfo:dic songList:list view:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//
//}


@end
