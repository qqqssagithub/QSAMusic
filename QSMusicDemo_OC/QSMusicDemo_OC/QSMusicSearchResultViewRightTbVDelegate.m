//
//  QSMusicSearchResultViewRightTbVDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearchResultViewRightTbVDelegate.h"
#import "QSMusicSearchRightTableViewCell.h"

@interface QSMusicSearchResultViewRightTbVDelegate ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSDictionary *dataDic;

@end

@implementation QSMusicSearchResultViewRightTbVDelegate

+ (instancetype)sharedQSMusicSearchResultViewRightTbVDelegate {
    static QSMusicSearchResultViewRightTbVDelegate *sharedQSMusicSearchResultViewRightTbVDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicSearchResultViewRightTbVDelegate = [[QSMusicSearchResultViewRightTbVDelegate alloc] init];
    });
    return sharedQSMusicSearchResultViewRightTbVDelegate;
}

- (void)tableview:(UITableView *)tableView reloadDataWithData:(NSDictionary *)dataDic {
    _tableView = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"QSMusicSearchRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchRightTableViewCellid"];
    tableView.delegate = self;
    tableView.dataSource = self;
    _dataDic = dataDic;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(_dataDic[@"album_list"])).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 4)];
    sectionView.backgroundColor = [UIColor purpleColor];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSMusicSearchRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchRightTableViewCellid"];
    NSDictionary *data = _dataDic[@"album_list"][indexPath.row];
    [cell updateWithData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [CSWProgressView showWithPrompt:@"专辑加载中"];
    [QSMusicPlayer requestSingleWithAlbumId:_dataDic[@"album_list"][indexPath.row][@"album_id"] response:^(NSDictionary * _Nonnull albumInfo, NSArray<NSDictionary *> * _Nonnull songList) {
        [CSWProgressView disappear];
        QSMusicPublicBigHeaderView *view = [QSMusicPublicBigHeaderView sharedQSMusicPublicBigHeaderView];
        __block typeof(view) blockView = view;
        view.bcakBlock = ^{
            [UIView animateWithDuration:0.3 animations:^{
                _supView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                blockView.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                [blockView.bottomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                [blockView removeFromSuperview];
            }];
        };
        [view updateWithHeaderInfo:albumInfo songList:songList];
        //[_rootViewController.view addSubview:view];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
        
        [UIView animateWithDuration:0.3 animations:^{
            _supView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            view.frame = QSMUSICSCREEN_RECT;
        }];
    }];
}

@end
