//
//  RootViewController.m
//  QSAMusic
//
//  Created by 陈少文 on 17/4/25.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import "RootViewController.h"
#import "QSMusicRemoteEvent.h"
#import "QSMusicSearch.h"
//#import <iflyMSC/iflyMSC.h>
//#import "QSMusicIFlytekDataHelper.h"


@interface RootViewController () <UIScrollViewDelegate/*, IFlySpeechRecognizerDelegate*/>

@property (weak, nonatomic) IBOutlet UILabel      *titleLabel;

@property (weak, nonatomic) IBOutlet UIView       *rootBackView;

@property (weak, nonatomic) IBOutlet UIButton     *album;
@property (weak, nonatomic) IBOutlet UIButton     *song;
@property (weak, nonatomic) IBOutlet UIButton     *list;
@property (weak, nonatomic) IBOutlet UIButton     *singer;
@property (weak, nonatomic) IBOutlet UIButton     *radio;
@property (weak, nonatomic) IBOutlet UIView       *indexView;

@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

@property (nonatomic) AlbumView  *albumView;
@property (nonatomic) ListView   *listView;
@property (nonatomic) RadioView  *radioView;
@property (nonatomic) SingerView *singerView;
@property (nonatomic) SongView   *songView;

@property (nonatomic) NSMutableArray *appearViews;

//@property (nonatomic, strong) IFlySpeechUnderstander *iFlySpeechUnderstander;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self initView];
    
    PlayPointView *playPointView = [PlayPointView shared];
    playPointView.superVC = self;
    [QSAMusicKeyWindow addSubview:playPointView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        _rootBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        _rootBackView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }];
}

#pragma mark - 初始化View
- (void)initView {
    [_album setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    _indexView.backgroundColor = [UIColor purpleColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth * 5, ScreenHeight - 64 - 33);
    
    _appearViews = [NSMutableArray array];
    
    [_bottomScrollView addSubview:self.albumView];
    
    _listView = nil;
    _radioView = nil;
    _singerView = nil;
    _songView = nil;
}

- (AlbumView *)albumView {
    if (_albumView == nil) {
        _albumView = [AlbumView shared];
        _albumView.superVC = self;
        [_appearViews addObject:_albumView];
    }
    return _albumView;
}

- (ListView *)listView {
    if (_listView == nil) {
        _listView = [ListView shared];
        _listView.superVC = self;
        [_appearViews addObject:_listView];
    }
    return _listView;
}

- (RadioView *)radioView {
    if (_radioView == nil) {
        _radioView = [RadioView shared];
        _radioView.superVC = self;
        [_appearViews addObject:_radioView];
    }
    return _radioView;
}

- (SingerView *)singerView {
    if (_singerView == nil) {
        _singerView = [SingerView shared];
        _singerView.superVC = self;
        [_appearViews addObject:_singerView];
    }
    return _singerView;
}

- (SongView *)songView {
    if (_songView == nil) {
        _songView = [SongView shared];
        _songView.superVC = self;
        [_appearViews addObject:_songView];
    }
    return _songView;
}

#pragma mark - btns action
- (IBAction)btnsAction:(UIButton *)sender {
    switch (sender.tag) {
        case 5: { //mine
//            //获得语义理解单例
//            _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
//            [_iFlySpeechUnderstander setParameter:@"3.0" forKey:@"nlp_version"];
//            //设置委托
//            _iFlySpeechUnderstander.delegate = self;
//            //启动语义理解服务
//            [_iFlySpeechUnderstander startListening];
            [QSAKitAlertView showWithTitle:@"提示" message:@"功能完善中， 敬请期待" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
            break;
        case 6: { //search
            [[QSMusicSearch sharedQSMusicSearch] initView];
        }
            break;
        default:
            _bottomScrollView.contentOffset = CGPointMake(sender.tag * ScreenWidth, 0);
            break;
    }
}

#pragma mark - scrollViewDelegate
/**
 *  滚动刷新Views
 *
 *  @param scrollView ...
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    //控制moveView的移动
    _indexView.center = CGPointMake((((ScreenWidth / 10) * 9) - (ScreenWidth / 10)) * (x / (ScreenWidth * 4)) + (ScreenWidth / 10), _indexView.center.y);//这么长的公式, 实在不想解释了
    
    //更新分类button的颜色
    [_album setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_song setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_list setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_singer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //移动过程中的处理, 添加新的view
    if (x > 0 && x < ScreenWidth * 1) {
        [_bottomScrollView addSubview:self.albumView];
        [_bottomScrollView addSubview:self.songView];
    } else if (x > ScreenWidth * 1 && x < ScreenWidth * 2) {
        [_bottomScrollView addSubview:self.songView];
        [_bottomScrollView addSubview:self.listView];
    } else if (x > ScreenWidth * 2 && x < ScreenWidth * 3) {
        [_bottomScrollView addSubview:self.listView];
        [_bottomScrollView addSubview:self.singerView];
    } else if (x > ScreenWidth * 3 && x < ScreenWidth * 4) {
        [_bottomScrollView addSubview:self.singerView];
        [_bottomScrollView addSubview:self.radioView];
    }
    
    //移动结束后的处理, 删除不显示的view
    if (x == ScreenWidth * 0) {
        [_album setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_bottomScrollView addSubview:self.albumView];
        [self removePreviousView:_albumView];
    } else if (x == ScreenWidth * 1) {
        [_song setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_bottomScrollView addSubview:self.songView];
        [self removePreviousView:_songView];
    } else if (x == ScreenWidth * 2) {
        [_list setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_bottomScrollView addSubview:self.listView];
        [self removePreviousView:_listView];
    } else if (x == ScreenWidth * 3) {
        [_singer setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_bottomScrollView addSubview:self.singerView];
        [self removePreviousView:_singerView];
    } else if (x == ScreenWidth * 4) {
        [_radio setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_bottomScrollView addSubview:self.radioView];
        [self removePreviousView:_radioView];
    }
}


/**
 删除多余的View节省内存

 @param appearView 现在界面上展现的View(非删除View)
 */
- (void)removePreviousView:(QSAKitBaseView *)appearView {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (QSAKitBaseView *oneView in _appearViews) {
        if (oneView != appearView) {
            [oneView removeFromSuperview];
            if (oneView == _albumView) {
                _albumView = nil;
            } else if (oneView == _songView) {
                _songView = nil;
            } else if (oneView == _listView) {
                _listView = nil;
            } else if (oneView == _singerView) {
                _singerView = nil;
            } else if (oneView == _radioView) {
                _radioView = nil;
            }
        } else {
            [tempArr addObject:oneView];
        }
    }
    _appearViews = tempArr;
}

//#pragma mark - 讯飞
////结果返回代理
//- (void)onResults:(NSArray *)results isLast:(BOOL) isLast {
//    NSDictionary *dic = results[0];
//    NSLog(@"-----------:%@", dic);
//    NSMutableString *resultString = [[NSMutableString alloc] init];
//    for (NSString *key in dic) {
//        [resultString appendFormat:@"%@",key];
//    }
//    
//    //NSMutableString *tempStr = [[NSMutableString alloc] init];
//    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
//                                [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//    
//    
//    
//    NSLog(@"结果返回代理:\nrc:%@\ntext:%@", resultDic[@"rc"], resultDic[@"text"]);
//}
//
////会话结束回调
//- (void)onError:(IFlySpeechError*)error {
//    NSLog(@"会话结束回调: %@", error);
//}
//
////录音开始回调
//- (void)onBeginOfSpeech {
//    NSLog(@"录音开始回调");
//}
//
////录音结束回调
//- (void)onEndOfSpeech {
//    NSLog(@"录音结束回调");
//}
//
////会话取消回调
//- (void)onCancel {
//    NSLog(@"会话取消回调");
//}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
