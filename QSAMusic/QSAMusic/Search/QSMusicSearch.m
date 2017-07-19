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
#import "RootViewController.h"
//#import "QSMusicSearchResultView.h"

@interface QSMusicSearch () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, IFlyRecognizerViewDelegate>

@property (nonatomic) UITableView  *searchTableView;
@property (nonatomic) UISearchBar  *searchBar;
@property (nonatomic) NSMutableArray *data;
@property (nonatomic) NSMutableArray *data_tmp;
@property (nonatomic) NSMutableArray *data_count;

@property (nonatomic) IFlyRecognizerView *iflyRecognizerView; //语音搜索界面
@property (nonatomic) BOOL isYuYinSearch;

@property (nonatomic) BOOL isNeedRecovery;

@property (nonatomic) RootViewController *superVC;

@property (nonatomic) NSInteger searchIndex;//0 歌手, 1 单曲, 2 专辑, 3 全部

@property (nonatomic) NSString *searchStr;
@property (nonatomic) NSInteger searchPage;

@property (nonatomic) NSString *bottomLabelStr;
@property (nonatomic) UILabel *bottomLabel;

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

- (void)initViewWithSuperVC:(RootViewController *)superVC {
    _data = [NSMutableArray array];
    _data_count = [NSMutableArray array];
    _superVC = superVC;
    [_superVC.rootBackView addSubview:self.searchBar];
    [_superVC.rootBackView addSubview:self.searchTableView];
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
        //_searchTableView.showsVerticalScrollIndicator = NO;
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
    _searchPage = 1;
    _searchIndex = 3;
    _searchTableView.tableFooterView = nil;
    _searchStr = searchText;
    [_data removeAllObjects];
    [_data_count removeAllObjects];
    if (searchText.length > 0) {
        [NetworkEngine getSearchWithQuery:searchText page:_searchPage size:3 responseBlock:^(NSDictionary * _Nonnull data) {
            NSInteger artist_total = [data[@"artist_info"][@"total"] integerValue];
            NSInteger song_total = [data[@"song_info"][@"total"] integerValue];
            NSInteger album_total = [data[@"album_info"][@"total"] integerValue];
            if (artist_total != 0) {
                NSMutableArray *artist_arr = [NSMutableArray arrayWithArray:data[@"artist_info"][@"artist_list"]];
                [_data addObject:artist_arr];
                [_data_count addObject:@(artist_total)];
            }
            if (song_total != 0) {
                NSMutableArray *song_arr = [NSMutableArray arrayWithArray:data[@"song_info"][@"song_list"]];
                [_data addObject:song_arr];
                [_data_count addObject:@(song_total)];
            }
            if (album_total != 0) {
                NSMutableArray *album_arr = [NSMutableArray arrayWithArray:data[@"album_info"][@"album_list"]];
                [_data addObject:album_arr];
                [_data_count addObject:@(album_total)];
            }
            _data_tmp = [_data copy];
            [_searchTableView reloadData];
        }];
    } else if (searchText.length == 0) {
        [_searchTableView reloadData];
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
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray *)_data[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UINib *nib = [UINib nibWithNibName:@"QSMusicSearchTbVHeaderView" bundle:nil];
    QSMusicSearchTbVHeaderView *view = [nib instantiateWithOwner:nil options:nil][0];
    view.frame = CGRectMake(0, 0, tableView.bounds.size.width, 44);
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    view.moreButton.tag = section;
    
    NSDictionary *data = _data[section][0];
    if (data.count == 9) {
        view.title.text = @"歌手/乐队";
    } else if (data.count == 35) {
        view.title.text = @"单曲";
    } else if (data.count == 11) {
        view.title.text = @"专辑";
    }
    
    NSInteger num = [_data_count[_searchIndex == 3 ? section : _searchIndex] integerValue];
    view.num.text = [NSString stringWithFormat:@"%ld", num];
    if (num <= 3) {
        view.moreButton.hidden = YES;
        view.moreTF.hidden = YES;
    } else {
        view.moreButton.hidden = NO;
        view.moreTF.hidden = NO;
    }
    if (_searchIndex != 3) {
        [view.moreButton setTitle:@"返回" forState:UIControlStateNormal];
    }
    WeakObject(view);
    [view setButtonBlock:^(NSInteger tag) {
        if (![wealObject.moreButton.titleLabel.text isEqualToString:@"返回"]) {
            _searchIndex = tag;
            [wealObject.moreButton setTitle:@"返回" forState:UIControlStateNormal];
            [self removeOther];
        } else {
            [wealObject.moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
            [self addOther];
        }
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = _data[indexPath.section][indexPath.row];
    if (data.count == 9) {
        SingerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singerCell"];
        [cell updateWithData:data];
        return cell;
    }
    if (data.count == 35) {
        NSString *pic = data[@"pic_small"];
        NSString *title = [self string:data[@"title"] removeExcess:@[@"<em>", @"</em>"]];
        NSString *album_title = data[@"album_title"];
        if ([album_title isEqualToString:@""]) {
            album_title = @"未知";
        }
        data = @{@"pic": pic, @"title": title, @"other": [NSString stringWithFormat:@"专辑: %@", album_title]};
    } else if (data.count == 11) {
        NSString *pic = data[@"pic_small"];
        NSString *title = [self string:data[@"title"] removeExcess:@[@"<em>", @"</em>"]];
        NSString *publishtime = data[@"publishtime"];
        if ([publishtime isEqualToString:@"0000-00-00"]) {
            publishtime = @"年份未知";
        }
        data = @{@"pic": pic, @"title": title, @"other": [NSString stringWithFormat:@"发布日期: %@", publishtime]};
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
    NSDictionary *data = _data[indexPath.section][indexPath.row];
    if (data.count == 9) {
        NSString *name = data[@"name"];
        if (name == nil) {
            name = data[@"author"];
        }
        name = [self string:name removeExcess:@[@"<em>", @"</em>"]];
        [NetworkEngine getSearchWithQuery:name page:1 size:25 responseBlock:^(NSDictionary * _Nonnull result) {
            SingerDetail *singer = [[SingerDetail alloc] init];
            singer.navigationName = name;
            singer.result = result;
            [_superVC.navigationController pushViewController:singer animated:YES];
        }];
    } else if (data.count == 35) {
        NSArray *list = _data[indexPath.section];
        [[PlayerController shared] playWithPlayList:list index:indexPath.row];
    } else if (data.count == 11) {
        [NetworkEngine getAlbumDetailWithAlbumId:data[@"album_id"] responseBlock:^(NSDictionary * _Nonnull albumInfo, NSArray<NSDictionary *> * _Nonnull songList) {
            AlbumDetails *aDetails = [[AlbumDetails alloc] init];
            aDetails.albumInfo = albumInfo;
            aDetails.songList = songList;
            [_superVC.navigationController pushViewController:aDetails animated:YES];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
    if (_searchIndex != 3) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - (ScreenHeight - 64 - 33) - 30) {
            if (![_bottomLabel.text isEqualToString:@"没有更多了"] && ![_bottomLabelStr isEqualToString:@""]) {
                _bottomLabelStr = @"";
                [self addData];
            }
        }
    }
}

#pragma mark - 查看更多
- (void)removeOther {
    for (NSInteger i = _data.count - 1; i >= 0; i--) {
        if (i != _searchIndex) {
            [_data removeObjectAtIndex:i];
            [_searchTableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    _bottomLabel.textAlignment = 1;
    _bottomLabel.font = [UIFont systemFontOfSize:12.0];
    _searchTableView.tableFooterView = _bottomLabel;
    [self addData];
}

- (void)addData {
    [NetworkEngine getSearchWithQuery:_searchStr page:_searchPage size:25 responseBlock:^(NSDictionary * _Nonnull data) {
        _searchPage++;
        _bottomLabelStr = @"加载完成";
        NSArray *arr;
        if (_searchIndex == 0) {
            arr = data[@"artist_info"][@"artist_list"];
        }
        if (_searchIndex == 1) {
            arr = data[@"song_info"][@"song_list"];
        }
        if (_searchIndex == 2) {
            arr = data[@"album_info"][@"album_list"];
        }
        if (arr.count < 25) {
            _bottomLabelStr = @"没有更多了";
        }
        _bottomLabel.text = _bottomLabelStr;
        if ([_bottomLabelStr isEqualToString:@"没有更多了"]) {
            _bottomLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
            _bottomLabel.textColor = [UIColor lightGrayColor];
        } else {
            _bottomLabel.backgroundColor = [UIColor clearColor];
            _bottomLabel.textColor = [UIColor clearColor];
        }
        for (NSInteger j = _searchPage == 1 ? 3 : 0; j < arr.count; j++) {
            [_data[0] addObject:arr[j]];
        }
        [_searchTableView reloadData];
    }];
}

- (void)addOther {
    _searchPage = 1;
    _searchIndex = 3;
    _searchTableView.tableFooterView = nil;
    [_searchTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    NSMutableArray *arr = _data[0];
    for (NSInteger i = arr.count - 1; i >= 3; i--) {
        [arr removeObjectAtIndex:i];
    }
    [_searchTableView reloadData];
    for (NSInteger j = 0; j < _data_tmp.count; j++) {
        if (j != _searchIndex) {
            if (j < _searchIndex) {
                [_data insertObject:_data_tmp[j] atIndex:j];
            } else {
                [_data addObject:_data_tmp[j]];
            }
            [_searchTableView insertSections:[NSIndexSet indexSetWithIndex:j] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
}

@end
