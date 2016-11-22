//
//  QSMusicPublicBigHeaderViewDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/8.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicPublicBigHeaderViewDelegate.h"

@interface QSMusicPublicBigHeaderViewDelegate ()

@property (nonatomic) UILabel *infoLabel;

@property (nonatomic) NSDictionary *headerInfo;
@property (nonatomic) NSArray *dataArr;
@property (nonatomic) QSMusicPublicBigHeaderView *superView;

@end

@implementation QSMusicPublicBigHeaderViewDelegate

+ (instancetype)sharedQSMusicPublicBigHeaderViewDelegate {
    static QSMusicPublicBigHeaderViewDelegate *sharedQSMusicPublicBigHeaderViewDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicPublicBigHeaderViewDelegate = [[QSMusicPublicBigHeaderViewDelegate alloc] init];
        sharedQSMusicPublicBigHeaderViewDelegate.tableView = [[UITableView alloc] initWithFrame:QSMUSICSCREEN_RECT];
        sharedQSMusicPublicBigHeaderViewDelegate.tableView.showsVerticalScrollIndicator = NO;
        sharedQSMusicPublicBigHeaderViewDelegate.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[sharedQSMusicPublicBigHeaderViewDelegate.tableView registerNib:[UINib nibWithNibName:@"QSMusciBangDanTableViewCell" bundle:nil] forCellReuseIdentifier:@"bangDanCellid"];
        [sharedQSMusicPublicBigHeaderViewDelegate.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        sharedQSMusicPublicBigHeaderViewDelegate.tableView.delegate = sharedQSMusicPublicBigHeaderViewDelegate;
        sharedQSMusicPublicBigHeaderViewDelegate.tableView.dataSource = sharedQSMusicPublicBigHeaderViewDelegate;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 250)];
        headerView.backgroundColor = [UIColor clearColor];
        sharedQSMusicPublicBigHeaderViewDelegate.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, -15, QSMUSICSCREEN_WIDTH -24, 250 +10)];
        sharedQSMusicPublicBigHeaderViewDelegate.infoLabel.font = QSMusicFont_10;
        sharedQSMusicPublicBigHeaderViewDelegate.infoLabel.alpha = 0.0;
        sharedQSMusicPublicBigHeaderViewDelegate.infoLabel.textColor = [UIColor whiteColor];
        sharedQSMusicPublicBigHeaderViewDelegate.infoLabel.numberOfLines = 0;
        [headerView addSubview:sharedQSMusicPublicBigHeaderViewDelegate.infoLabel];
        sharedQSMusicPublicBigHeaderViewDelegate.tableView.tableHeaderView = headerView;
    });
    return sharedQSMusicPublicBigHeaderViewDelegate;
}

- (void)updateWithHeaderInfo:(NSDictionary *)headerInfo songList:(NSArray *)list view:(QSMusicPublicBigHeaderView *)view {
    _superView = view;
    _infoLabel.text = headerInfo[@"info"];
    _headerInfo = headerInfo;
    _superView.tempHeaderLabel.text = _headerInfo[@"title"];
    _dataArr = list;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArr.count < 10) {
        return 10;
    }
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, QSMUSICSCREEN_WIDTH, 30)];
    label.font = QSMusicFont_14;
    label.textColor = [UIColor whiteColor];
    if (![_headerInfo[@"buy_url"] isEqualToString:@""]) {
        view.backgroundColor = [UIColor orangeColor];
        label.text = [NSString stringWithFormat:@"%@ -- %@ ,  专辑热卖中", _headerInfo[@"title"], _headerInfo[@"author"]];
    } else {
        if ([_headerInfo[@"author"] isEqualToString:@""]) {
            label.text = _headerInfo[@"title"];
        } else {
            label.text = [NSString stringWithFormat:@"%@ -- %@ ,  共%ld首", _headerInfo[@"title"], _headerInfo[@"author"], _dataArr.count];
        }
        view.backgroundColor = [UIColor lightGrayColor];
    }
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = QSMusicFont_14;
    if (indexPath.row < _dataArr.count) {
        NSDictionary *song = _dataArr[indexPath.row];
        if ([_headerInfo[@"author"] isEqualToString:@""]) {
            if (![song[@"versions"] isEqualToString:@""]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@(%@) - %@", song[@"title"], song[@"versions"], song[@"author"]];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", song[@"title"], song[@"author"]];
            }
        } else {
            if (![song[@"versions"] isEqualToString:@""]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", song[@"title"], song[@"versions"]];
            } else {
                cell.textLabel.text = song[@"title"];
            }
        }
        cell.userInteractionEnabled = YES;
    } else {
        cell.textLabel.text = @"";
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![_headerInfo[@"buy_url"] isEqualToString:@""]) {
        [CSWAlertView initWithTitle:[NSString stringWithFormat:@"《%@》", _headerInfo[@"title"]] message:@"专辑热卖中，无法试听\n请支持正版" cancelButtonTitle:@"支持歌手"];
        return;
    }
    
    [QSMusicPlayerDelegate sharedQSMusicPlayerDelegate].playStyle = @"Ordinary";
    [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] openPlayPoint];
    //[PlayView sharedPlayView].isLoad = NO;
    [[PlayView sharedPlayView] updataListWithData:_dataArr];
    [PlayView sharedPlayView].currentIndex = indexPath.row;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QSMusicPlayer createPlayListWithPlayList:_dataArr listid:_headerInfo[@"title"]];
        [QSMusicPlayer playAtIndex:indexPath.row];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset;
    if (QSMUSICSCREEN_WIDTH > 320)
        offset = 250 - QSMUSICSCREEN_WIDTH + 100;
    else
        offset = 250 - QSMUSICSCREEN_WIDTH;
    
    if (scrollView.contentOffset.y <= offset) {
        _superView.topImgV.frame = CGRectMake(0, -scrollView.contentOffset.y + offset, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_WIDTH);
        [UIView animateWithDuration:0.3 animations:^{
            _infoLabel.alpha = 1.0;
            _superView.topImgVOcclusionView.alpha = 1.0;
        }];
    } else {
        _superView.topImgV.frame = CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_WIDTH);
        [UIView animateWithDuration:0.3 animations:^{
            _infoLabel.alpha = 0.0;
            _superView.topImgVOcclusionView.alpha = 0.0;
        }];
        _superView.tempHeaderView.alpha = 1.0;
        _superView.tempHeaderLabel.alpha = 1.0;
    }
    if (scrollView.contentOffset.y <= - 5) {
        _superView.tempHeaderView.alpha = 0.0;
        _superView.tempHeaderLabel.alpha = 0.0;
    }
    
//    if (scrollView.contentOffset.y >= 140) {
//        
//        
//    } else {
//            _superView.tempHeaderView.alpha = 0.0;
//            _superView.tempHeaderLabel.alpha = 0.0;
//    }
}

@end
