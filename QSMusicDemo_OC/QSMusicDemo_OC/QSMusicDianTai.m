//
//  QSMusicDianTai.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicDianTai.h"
#import "FXImageView.h"

@interface QSMusicDianTai ()

@property (nonatomic, copy) NSArray *radioNames;
@property (nonatomic, copy) NSArray *radioPics;
@property (nonatomic, copy) NSArray *chArr;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic) NSMutableArray *jingdianlaoge;
@property (nonatomic) NSMutableArray *rege;
@property (nonatomic) NSMutableArray *chengmingqu;
@property (nonatomic) NSMutableArray *oumei;
@property (nonatomic) NSMutableArray *wangluo;
@property (nonatomic) NSMutableArray *suibiantingting;
@property (nonatomic) NSMutableArray *dianyingyuansheng;

@property (nonatomic) NSMutableArray *songList;

@end

@implementation QSMusicDianTai

+ (instancetype)sharedQSMusicDianTai {
    static QSMusicDianTai *sharedQSMusicDianTai = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicDianTai = [[QSMusicDianTai alloc] init];
        sharedQSMusicDianTai.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH * 4, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 - 33)];
        sharedQSMusicDianTai.radioPics = @[@"jd.jpg", @"jg.jpg", @"cmq.jpg", @"om.jpg", @"wl.jpg", @"sbtt.jpg", @"dy.jpg"];
        sharedQSMusicDianTai.radioNames = @[@"经典老歌", @"劲爆热歌", @"成名金曲", @"流行欧美", @"网络歌曲", @"随便听听", @"电影原声"];
        sharedQSMusicDianTai.chArr = @[@"public_shiguang_jingdianlaoge", @"public_tuijian_rege", @"public_tuijian_chengmingqu", @"public_yuzhong_oumei", @"public_tuijian_wangluo", @"public_tuijian_suibiantingting", @"public_fengge_dianyingyuansheng"];
        sharedQSMusicDianTai.tags = @[@(3000), @(3001), @(3002), @(3003), @(3004), @(3005), @(3006)];
        sharedQSMusicDianTai.carousel.delegate = sharedQSMusicDianTai;
        sharedQSMusicDianTai.carousel.dataSource = sharedQSMusicDianTai;
        sharedQSMusicDianTai.carousel.type = iCarouselTypeRotary;
        sharedQSMusicDianTai.carousel.vertical = YES;
        sharedQSMusicDianTai.carousel.pagingEnabled = YES;
    });
    return sharedQSMusicDianTai;
}

#pragma mark - iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return 7;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        FXImageView *imagV = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH * 0.6, QSMUSICSCREEN_WIDTH * 0.6)];
        imagV.image = [UIImage imageNamed:_radioPics[index]];
        //倒影
//        imagV.reflectionScale = 0.4f;
//        imagV.reflectionAlpha = 1.0f;
//        imagV.reflectionGap = 5.0f;//倒影距离原物体的距离
        
        //投影
        imagV.shadowOffset = CGSizeMake(8.0f, 8.0f);
        imagV.shadowBlur = 10.0f;
        view = imagV;
        //((UIImageView *)view).image = [UIImage imageNamed:_arr[index]];
        //view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = 1;
        label.font = [label.font fontWithSize:12];
        label.tag = 1;
        [view addSubview:label];
    } else {
        label = (UILabel *)[view viewWithTag:1];
    }
    label.text = _radioNames[index];
    
    return view;
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    [QSMusicPlayerDelegate sharedQSMusicPlayerDelegate].playStyle = @"EVA";
    [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] openPlayPoint];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QSMusicPlayer getChannelListWithChannelName:_chArr[index] responseClosure:^(NSArray * _Nonnull dataArr) {
            if (dataArr.count == 0) {
                [CSWAlertView initWithTitle:@"提示" message:@"音乐加载失败，请检查网络链接" cancelButtonTitle:@"确定"];
            } else {
                TingEVAPlayView *player = [TingEVAPlayView sharedTingEVAPlayView];
                player.dataArr = dataArr;
                player.currentIndex = index;
                NSDate *currentDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
                NSString *dateString = [dateFormatter stringFromDate:currentDate];
                [QSMusicPlayer createPlayListWithPlayList:dataArr listid:[NSString stringWithFormat:@"%@-%@", _radioNames[index], dateString]];
                [QSMusicPlayer playAtIndex:index];
            }
        }];
    });
}

@end
