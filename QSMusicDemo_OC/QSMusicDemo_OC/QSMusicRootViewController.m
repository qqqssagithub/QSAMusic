//
//  ViewController.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicRootViewController.h"
#import "QSMusicXinDie.h"
#import "QSMusicGeDan.h"
#import "QSMusicBangDan.h"
#import "QSMusicGeShou.h"
#import "QSMusicDianTai.h"
#import <iCarousel/iCarousel.h>
#import "QSMusicPlayerDelegate.h"
#import "QSMusicRemoteEvent.h"
#import "QSMusicSearch.h"
#import "QSMusicSongDatas.h"

@interface QSMusicRootViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *xindie;
@property (weak, nonatomic) IBOutlet UIButton *gedan;
@property (weak, nonatomic) IBOutlet UIButton *bangdan;
@property (weak, nonatomic) IBOutlet UIButton *geshou;
@property (weak, nonatomic) IBOutlet UIButton *diantai;
@property (weak, nonatomic) IBOutlet UIButton *moveView;

@end

@implementation QSMusicRootViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加网络监控
    [self addNetworkReachability];
    //载入所有界面
    [self initView];
}

- (void)addNetworkReachability {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityStatusChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)networkReachabilityStatusChange {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (manager.networkReachabilityStatus == 2) {
        [CSWFlashingAlertView initWithMessage:@"当前为WiFi网络\n可以尽情畅游在音乐的海洋中"];
    }
    if (manager.networkReachabilityStatus == 1) {
        [CSWFlashingAlertView initWithMessage:@"当前为3G/4G网络\n加载新音乐会耗费手机流量"];
    }
    if (manager.networkReachabilityStatus == 0) {
        [CSWFlashingAlertView initWithMessage:@"网络断开连接，请检查网络连接"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //设置播放代理
    [QSMusicPlayerDelegate sharedQSMusicPlayerDelegate];
}

- (void)initView {
    [_xindie setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    _moveView.backgroundColor = [UIColor purpleColor];
    _bottomScrollView.contentSize = CGSizeMake(QSMUSICSCREEN_WIDTH * 5, QSMUSICSCREEN_HEIGHT - 64 - 33);
    
    UICollectionView *collectionView0 = [QSMusicXinDie sharedQSMusicXinDie].collectionView;
    [_bottomScrollView addSubview:collectionView0];
    
    UICollectionView *collectionView1 = [QSMusicGeDan sharedQSMusicGeDan].collectionView;
    [_bottomScrollView addSubview:collectionView1];
    
    UITableView *tableView = [QSMusicBangDan sharedQSMusicBangDan].tableView;
    [_bottomScrollView addSubview:tableView];
    
    UITableView *tableView0 = [QSMusicGeShou sharedQSMusicGeShou].tableView;
    [_bottomScrollView addSubview:tableView0];
    
    iCarousel *carousel = [QSMusicDianTai sharedQSMusicDianTai].carousel;
    [_bottomScrollView addSubview:carousel];
}

/**
 *  本地音乐
 *
 *  @param sender
 */
- (IBAction)localAction:(id)sender {
    NSArray *dataArr = [QSMusicSongDatas MR_findAll];
    UINib *nib = [UINib nibWithNibName:@"QSMusicSongListView" bundle:nil];
    QSMusicSongListView *view = [nib instantiateWithOwner:nil options:nil][0];
    view.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
    view.supView = QSMusicRootVC_rootBackView;
    [QSMusicRootVC_View addSubview:view];
    [view reloadDataWithTitle:@"本地收藏" data:dataArr indexStr:@"load"];
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = QSMUSICSCREEN_RECT;
        view.supView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }];
}

/**
 *  搜索
 *
 *  @param sender
 */
- (IBAction)searchAction:(id)sender {
    [[QSMusicSearch sharedQSMusicSearch] initView];
}

/**
 *  分类导航按钮
 *
 *  @param sender
 */
- (IBAction)classificationAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomScrollView.contentOffset = CGPointMake(0 * QSMUSICSCREEN_WIDTH, 0);
            }];
        }
            break;
        case 1:{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomScrollView.contentOffset = CGPointMake(1 * QSMUSICSCREEN_WIDTH, 0);
            }];
        }
            break;
        case 2:{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomScrollView.contentOffset = CGPointMake(2 * QSMUSICSCREEN_WIDTH, 0);
            }];
        }
            break;
        case 3:{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomScrollView.contentOffset = CGPointMake(3 * QSMUSICSCREEN_WIDTH, 0);
            }];
        }
            break;
        case 4:{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomScrollView.contentOffset = CGPointMake(4 * QSMUSICSCREEN_WIDTH, 0);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - scrollViewDelegate
/**
 *  滚动刷新moveView的位置
 *
 *  @param scrollView 底部scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //控制moveView的移动
    _moveView.center = CGPointMake((((QSMUSICSCREEN_WIDTH / 10) * 9) - (QSMUSICSCREEN_WIDTH / 10)) * (scrollView.contentOffset.x / (QSMUSICSCREEN_WIDTH * 4)) + (QSMUSICSCREEN_WIDTH / 10), _moveView.center.y);//这么长的公式, 实在不想解释了
    
    //更新分类button的颜色
    [_xindie setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_gedan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bangdan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_geshou setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_diantai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSInteger x;
    if (scrollView.contentOffset.x == QSMUSICSCREEN_WIDTH * 0) {
        x = 0;
    } else if (scrollView.contentOffset.x == QSMUSICSCREEN_WIDTH * 1) {
        x = 1;
    } else if (scrollView.contentOffset.x == QSMUSICSCREEN_WIDTH * 2) {
        x = 2;
    } else if (scrollView.contentOffset.x == QSMUSICSCREEN_WIDTH * 3) {
        x = 3;
    } else if (scrollView.contentOffset.x == QSMUSICSCREEN_WIDTH * 4) {
        x = 4;
    }
    switch (x) {
        case 0:
            [_xindie setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            break;
        case 1:
            [_gedan setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            break;
        case 2:
            [_bangdan setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            break;
        case 3:
            [_geshou setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            break;
        case 4:
            [_diantai setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 锁屏控制和耳机控制
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[QSMusicRemoteEvent sharedQSMusicRemoteEvent] responseEvent:event];
}

@end
