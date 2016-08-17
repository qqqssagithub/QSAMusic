//
//  QSMusicXInDie.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicBangDan.h"
#import "QSMusciBangDanTableViewCell.h"

@interface QSMusicBangDan ()

@property (nonatomic) NSArray *dataArr;
@property (nonatomic) NSArray *titleArr;

@end

@implementation QSMusicBangDan

+ (instancetype)sharedQSMusicBangDan {
    static QSMusicBangDan *sharedQSMusicBangDan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicBangDan = [[QSMusicBangDan alloc] init];
        sharedQSMusicBangDan.tableView = [[UITableView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH * 2, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 - 33)];
        sharedQSMusicBangDan.tableView.showsVerticalScrollIndicator = NO;
        sharedQSMusicBangDan.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [sharedQSMusicBangDan.tableView registerNib:[UINib nibWithNibName:@"QSMusciBangDanTableViewCell" bundle:nil] forCellReuseIdentifier:@"bangDanCellid"];
        sharedQSMusicBangDan.tableView.delegate = sharedQSMusicBangDan;
        sharedQSMusicBangDan.tableView.dataSource = sharedQSMusicBangDan;
        [sharedQSMusicBangDan requestData];
    });
    return sharedQSMusicBangDan;
}

- (void)requestData {
    _titleArr = @[@"新歌榜", @"热歌榜", @"欧美金曲", @"King榜", @"原创榜", @"华语金曲", @"金典老歌", @"网络歌曲", @"影视金曲", @"情歌对唱", @"Billboard", @"摇滚"];
    [QSMusicPlayer getRankingList:^(NSArray * _Nonnull dataArr) {
        _dataArr = dataArr;
        [_tableView reloadData];
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataArr.count - 1) {
        return 136;
    }
    return 106;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSMusciBangDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bangDanCellid"];
    NSDictionary *data = _dataArr[indexPath.row];
    [cell updateWithData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [CSWProgressView showWithPrompt:@"榜单加载中"];
    [QSMusicPlayer requestSingleWithType:[NSString stringWithFormat:@"%ld", [_dataArr[indexPath.row][@"type"] integerValue]] size:30 response:^(NSDictionary * _Nonnull data) {
        [CSWProgressView disappear];
        UINib *nib = [UINib nibWithNibName:@"QSMusicSongListView" bundle:nil];
        QSMusicSongListView *view = [nib instantiateWithOwner:nil options:nil][0];
        view.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
        view.supView = QSMusicRootVC_rootBackView;
        [QSMusicRootVC_View addSubview:view];
        [view reloadDataWithTitle:[NSString stringWithFormat:@"%@ TOP30", _titleArr[indexPath.row]] data:data[@"song_list"] indexStr:@"bangDan"];
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = QSMUSICSCREEN_RECT;
            view.supView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
    }];
}

@end
