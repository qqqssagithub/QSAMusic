//
//  QSMusicSearch.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/14.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearch.h"
#import "QSMusicSearchTbVHeaderView.h"
#import <iflyMSC/IFlyMSC.h>
#import "QSMusicIFlytekDataHelper.h"
//#import "QSMusicSearchResultView.h"

@interface QSMusicSearch () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, IFlyRecognizerViewDelegate>

@property (nonatomic) UITableView  *searchTableView;
@property (nonatomic) UISearchBar  *searchBar;
@property (nonatomic) NSDictionary *data;

@property (nonatomic) IFlyRecognizerView *iflyRecognizerView; //语音搜索界面
@property (nonatomic) BOOL isYuYinSearch;

@property (nonatomic) BOOL isNeedRecovery;

@end

@implementation QSMusicSearch

+ (instancetype)sharedQSMusicSearch {
    static QSMusicSearch *sharedQSMusicSearch = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicSearch = [[QSMusicSearch alloc] init];
        //初始化语音识别控件
        [sharedQSMusicSearch customYuYin];
    });
    return sharedQSMusicSearch;
}

- (void)initView {
    [QSAMusicKeyWindow addSubview:self.searchBar];
    [QSAMusicKeyWindow addSubview:self.searchTableView];
    [UIView animateWithDuration:0.2 animations:^{
        _searchBar.frame = CGRectMake(0, 20, ScreenWidth, 44);
        _searchTableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    }];
}

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(ScreenWidth, 20, ScreenWidth, 44)];
        UIBarButtonItem *spaceBtnItem0= [[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *yuyinBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"语音搜索" style:UIBarButtonItemStylePlain target:self action:@selector(openYuYin:)];
        UIBarButtonItem *spaceBtnItem1= [[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIToolbar * toolbar = [[ UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        toolbar.barStyle = UIBarStyleDefault;
        NSArray * array = [NSArray arrayWithObjects:spaceBtnItem0, yuyinBtnItem, spaceBtnItem1, nil];
        [toolbar setItems:array];
        _searchBar.inputAccessoryView = toolbar;
        
        _searchBar.returnKeyType = UIReturnKeyDone;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入搜索内容";
        [_searchBar becomeFirstResponder];
        _searchBar.showsCancelButton = YES;
        for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
            if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton *cancel =(UIButton *)view;
                [cancel setTitle:@"     " forState:UIControlStateNormal];
                UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth -50, 0, 50, 44)];
                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor colorWithRed:0.0 green:112 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
                [cancelButton addTarget:self action:@selector(removeSearchBarAndTalbelView) forControlEvents:UIControlEventTouchUpInside];
                [_searchBar addSubview:cancelButton];
            }
        }
        
        
    }
    return _searchBar;
}

- (UITableView *)searchTableView {
    if (_searchTableView == nil) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64)];
        _searchTableView.showsVerticalScrollIndicator = NO;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchTableView registerNib:[UINib nibWithNibName:@"SingerCell" bundle:nil] forCellReuseIdentifier:@"singerCell"];
        [_searchTableView registerNib:[UINib nibWithNibName:@"SingerDetailCell" bundle:nil] forCellReuseIdentifier:@"singerDetailCell"];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
    }
    return _searchTableView;
}

#pragma mark - 语音搜索
- (void)customYuYin {
    UIView *view = QSAMusicKeyWindow;
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
}

- (void)openYuYin:(id)sender {
    if ([PlayerController shared].isPlaying) {
        [[PlayerController shared] pause];
        _isNeedRecovery = YES;
    } else {
        _isNeedRecovery = NO;
    }
    [_searchBar resignFirstResponder];
    _searchBar.text = @"请说出搜索内容";
    //启动识别服务
    //[QSMusicRootVC_View bringSubviewToFront:_iflyRecognizerView];
    [_iflyRecognizerView start];
    _isYuYinSearch = YES;
    
    UITapGestureRecognizer *yuYintap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yuYintapGR:)];
    [_iflyRecognizerView addGestureRecognizer:yuYintap];
}

-(void)yuYintapGR:(UITapGestureRecognizer *)tapGR{
    if (_isYuYinSearch) {
        _searchBar.text = @"";
        [_iflyRecognizerView cancel];
        [_iflyRecognizerView removeFromSuperview];
        _isYuYinSearch = NO;
        if (_isNeedRecovery) {
            [[PlayerController shared] play];
        }
    }
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    if (_isYuYinSearch) {
        NSDictionary *dic = resultArray[0];
        NSMutableString *resultString = [[NSMutableString alloc] init];
        for (NSString *key in dic) {
            [resultString appendFormat:@"%@",key];
        }
        _searchBar.text = [QSMusicIFlytekDataHelper stringFromJson:resultString];
        _isYuYinSearch = NO;
        [self searchBar:_searchBar textDidChange:_searchBar.text];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_searchBar becomeFirstResponder];
        });
    }
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError:(IFlySpeechError *)error {
    //[_popUpView showText:@"识别结束"];
    if (_isNeedRecovery) {
        [[PlayerController shared] play];
    }
    if ([error errorCode] != 0) {
        [QSAKitAlertView showWithTitle:@"语音搜索出错" message:[error errorDesc] cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }
    NSLog(@"语音搜索结束，错误代码:%d", [error errorCode]);
}

#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        [NetworkEngine getSearchWithQuery:searchText page:0 size:3 responseClosure:^(NSDictionary * _Nonnull data) {
            _data = data;
            [_searchTableView reloadData];
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)removeSearchBarAndTalbelView{
    _data = nil;
    [_searchTableView reloadData];
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        _searchBar.frame = CGRectMake(ScreenWidth, 20, ScreenWidth, 44);
        _searchTableView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_searchBar removeFromSuperview];
        _searchBar = nil;
        [_searchTableView removeFromSuperview];
        _searchTableView = nil;
    });
}

#pragma mark - TabelView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *oneArr = @[@"artist_info", @"song_info", @"album_info"];
    NSArray *twoArr = @[@"artist_list", @"song_list", @"album_list"];
    return ((NSArray *)_data[oneArr[section]][twoArr[section]]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *oneArr = @[@"artist_info", @"song_info", @"album_info"];
    NSArray *twoArr = @[@"artist_list", @"song_list", @"album_list"];
    if (((NSArray *)_data[oneArr[section]][twoArr[section]]).count == 0) {
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UINib *nib = [UINib nibWithNibName:@"QSMusicSearchTbVHeaderView" bundle:nil];
    QSMusicSearchTbVHeaderView *view = [nib instantiateWithOwner:nil options:nil][0];
    view.frame = CGRectMake(0, 0, tableView.bounds.size.width, 44);
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    view.moreButton.tag = section;
    NSArray *titleArr = @[@"歌手/乐队", @"单曲", @"专辑"];
    NSArray *numArr = @[@"artist_info", @"song_info", @"album_info"];
    view.num.text = [NSString stringWithFormat:@"%ld", [_data[numArr[section]][@"total"] integerValue]];
    view.title.text = titleArr[section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SingerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singerCell"];
        NSDictionary *data = _data[@"artist_info"][@"artist_list"][indexPath.row];
        [cell updateWithData:data];
        return cell;
    }
    NSDictionary *data;
    if (indexPath.section == 1) {
        NSDictionary *tempData = _data[@"song_info"][@"song_list"][indexPath.row];
        NSString *pic = tempData[@"pic_small"];
        NSString *title = [self string:tempData[@"title"] removeExcess:@[@"<em>", @"</em>"]];
        NSString *other = tempData[@"album_title"];
        data = @{@"pic": pic, @"title": title, @"other": [NSString stringWithFormat:@"专辑: %@", other]};
    } else {
        NSDictionary *tempData = _data[@"album_info"][@"album_list"][indexPath.row];
        NSString *pic = tempData[@"pic_small"];
        NSString *title = [self string:tempData[@"title"] removeExcess:@[@"<em>", @"</em>"]];
        NSString *other = tempData[@"publishtime"];
        data = @{@"pic": pic, @"title": title, @"other": [NSString stringWithFormat:@"专辑: %@", other]};
    }
    SingerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singerDetailCell"];
    [cell updateWithData:data];
    return cell;
}

- (NSString *)string:(NSString *)str removeExcess:(NSArray *)excess {
    for (NSString *e in excess) {
        str = [str stringByReplacingOccurrencesOfString:e withString:@""];
    }
    return str;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        NSArray *dataArr = _data[@"song_info"][@"song_list"];
//
//        [QSMusicPlayerDelegate sharedQSMusicPlayerDelegate].playStyle = @"Ordinary";
//        [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] openPlayPoint];
//        [PlayView sharedPlayView].isLoad = NO;
//        [[PlayView sharedPlayView] updataListWithData:dataArr];
//        [PlayView sharedPlayView].currentIndex = indexPath.row;
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [QSMusicPlayer createPlayListWithPlayList:dataArr listid:dataArr[0][@"author"]];
//            [QSMusicPlayer playAtIndex:indexPath.row];
//        });
//    } else if (indexPath.section == 1) {
//        [CSWProgressView showWithPrompt:@"加载中"];
//        QSMusicSongListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        [QSMusicPlayer getSearchDataWithKeyword:cell.title.text pageSize:10 responseClosure:^(NSDictionary * _Nonnull data) {
//            [CSWProgressView disappear];
//            UINib *nib = [UINib nibWithNibName:@"QSMusicSearchResultView" bundle:nil];
//            QSMusicSearchResultView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
//            view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
//            [view reloadDataWithData:data];
//            __block typeof(view) blockView = view;
//            UIView *rootBackView = QSMusicRootVC_rootBackView;
//            view.backBlock = ^{
//                [UIView animateWithDuration:0.3 animations:^{
//                    blockView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
//                    rootBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                } completion:^(BOOL finished) {
//                    [blockView removeFromSuperview];
//                }];
//            };
//            [QSMusicRootVC_View addSubview:view];
//            [UIView animateWithDuration:0.3 animations:^{
//                view.frame = QSMUSICSCREEN_RECT;
//                rootBackView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//            }];
//        }];
//    } else {
//        [CSWProgressView showWithPrompt:@"专辑加载中"];
//        QSMusicSearchRightTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        [QSMusicPlayer requestSingleWithAlbumId:cell.albumId response:^(NSDictionary * _Nonnull albumInfo, NSArray<NSDictionary *> * _Nonnull songList) {
//            [CSWProgressView disappear];
//            QSMusicPublicBigHeaderView *view = [QSMusicPublicBigHeaderView sharedQSMusicPublicBigHeaderView];
//            __block typeof(view) blockView = view;
//            UIView *rootBackView = QSMusicRootVC_rootBackView;
//            view.backBlock = ^{
//                [UIView animateWithDuration:0.3 animations:^{
//                    rootBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                    blockView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
//                } completion:^(BOOL finished) {
//                    [blockView.bottomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                    [blockView removeFromSuperview];
//                }];
//            };
//            [view updateWithHeaderInfo:albumInfo songList:songList];
//            //[_rootViewController.view addSubview:view];
//            
//            [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                rootBackView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//                view.frame = QSMUSICSCREEN_RECT;
//            }];
//        }];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

@end
