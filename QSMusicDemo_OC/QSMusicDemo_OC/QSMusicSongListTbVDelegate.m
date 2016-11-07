//
//  QSMusicSongListTbVDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSongListTbVDelegate.h"
#import "QSMusicPublicSongListTableViewCell.h"
#import "QSMusicSongListTableViewCell.h"
#import "QSMusicSearchResultView.h"
#import "QSMusicSearchLeftTableViewCell.h"
#import "QSMusicSongDatas.h"

@interface QSMusicSongListTbVDelegate ()

@property (nonatomic) NSArray *dataArr;

@property (nonatomic) UIView *tempHeaderView;
@property (nonatomic) UITableView *superTableView;

@property (nonatomic) UIView *headerView;
@property (nonatomic) UIImageView *headerImageView;

@property (nonatomic) NSString *title;

@end

@implementation QSMusicSongListTbVDelegate

+ (instancetype)sharedQSMusicSongListTbVDelegate {
    static QSMusicSongListTbVDelegate *sharedQSMusicSongListTbVDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicSongListTbVDelegate = [[QSMusicSongListTbVDelegate alloc] init];
    });
    return sharedQSMusicSongListTbVDelegate;
}

- (void)reloadDataWithTitle:(NSString *)title data:(NSArray *)dataArr tableView:(UITableView *)tableView {
    _title = title;
    _dataArr = dataArr;
    _superTableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"QSMusicPublicSongListTableViewCell" bundle:nil] forCellReuseIdentifier:@"publicSongListCellid"];
    [tableView registerNib:[UINib nibWithNibName:@"QSMusicSongListTableViewCell" bundle:nil] forCellReuseIdentifier:@"songListCellid"];
    [tableView registerNib:[UINib nibWithNibName:@"QSMusicSearchLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchLeftTableViewCellid"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self costomHeaderViewWithTitle:title];
    [_superTableView reloadData];
}

- (void)costomHeaderViewWithTitle:(NSString *)title {
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 70)];
    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 70)];
    _headerImageView.image = [UIImage imageNamed:@"back2.jpg"];
    [_headerView addSubview:_headerImageView];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"<<" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(12, 25, 30, 30);
    [_headerView addSubview:button];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = title;
    headerLabel.frame = CGRectMake(0, 32, QSMUSICSCREEN_WIDTH, 30);
    //self.headerLabel.center = CGPointMake(self.headerView.center.x, self.headerView.center.y + 10);
    headerLabel.textAlignment = 1;
    headerLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:headerLabel];
    
    _superTableView.tableHeaderView = _headerView;
    _superTableView.tableHeaderView.backgroundColor = [UIColor redColor];
    
    _tempHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, -70, QSMUSICSCREEN_WIDTH, 70)];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 70)];
    imgV.image = [UIImage imageNamed:@"back2.jpg"];
    [_tempHeaderView addSubview:imgV];
    
    UIButton *button0 = [[UIButton alloc] init];
    [button0 setTitle:@"<<" forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button0.frame = CGRectMake(12, 25, 30, 30);
    [_tempHeaderView addSubview:button0];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.frame = CGRectMake(0, 32, QSMUSICSCREEN_WIDTH, 30);
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    [_tempHeaderView addSubview:label];
    _tempHeaderView.alpha = 0.0;
    //[QSMusicKeyWindow addSubview:_tempHeaderView];
    [_superTableView.superview addSubview:_tempHeaderView];
}

- (void)back {
    if (_backBlock) {
        _backBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_indexStr isEqualToString:@"bangDan"]) {
        return 44.0;
    }
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_indexStr isEqualToString:@"geShou"]) {
        QSMusicSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songListCellid"];
        NSDictionary *data = _dataArr[indexPath.row];
        cell.imgV.layer.cornerRadius = 20;
        cell.imgV.layer.masksToBounds = YES;
        cell.indexStr = @"geShou";
        [cell updateWithData:data];
        return cell;
    }
    if ([_indexStr isEqualToString:@"bangDan"]) {
        QSMusicSearchLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchLeftTableViewCellid"];
        NSDictionary *data = _dataArr[indexPath.row];
        cell.indexStr = @"bangDan";
        [cell updateWithData:data];
        return cell;
    }
    if ([_indexStr isEqualToString:@"load"]) {
        QSMusicPublicSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publicSongListCellid"];
        QSMusicSongDatas *oneModel = _dataArr[indexPath.row];
        [cell updateWithModel:oneModel];
        return cell;
    }
    QSMusicPublicSongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publicSongListCellid"];
    NSDictionary *data = _dataArr[indexPath.row];
    [cell updateWithData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_indexStr isEqualToString:@"geShou"]) {
        [CSWProgressView showWithPrompt:@"加载中"];
        [QSMusicPlayer getSearchDataWithKeyword:_dataArr[indexPath.row][@"name"] pageSize:10 responseClosure:^(NSDictionary * _Nonnull data) {
            [CSWProgressView disappear];
            UINib *nib = [UINib nibWithNibName:@"QSMusicSearchResultView" bundle:nil];
            QSMusicSearchResultView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
            view.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
            [view reloadDataWithData:data];
            __block typeof(view) blockView = view;
            view.backBlock = ^{
                [UIView animateWithDuration:0.3 animations:^{
                    blockView.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
                    _supView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    [blockView removeFromSuperview];
                }];
            };
            [QSMusicRootVC_View addSubview:view];
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = QSMUSICSCREEN_RECT;
                _supView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }];
        }];
    } else {
        
        [QSMusicPlayerDelegate sharedQSMusicPlayerDelegate].playStyle = @"EVA";
        [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] openPlayPoint];
        
        TingEVAPlayView *player = [TingEVAPlayView sharedTingEVAPlayView];
        player.dataArr = _dataArr;
        player.currentIndex = indexPath.row;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QSMusicPlayer createPlayListWithPlayList:_dataArr listid:_title];
            [QSMusicPlayer playAtIndex:indexPath.row];
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = _superTableView.contentOffset.y;
    if (yOffset < 0) {
        CGFloat factor = -yOffset + 70;
        CGRect f = CGRectMake(-(QSMUSICSCREEN_WIDTH * factor / 70 - QSMUSICSCREEN_WIDTH) / 2, yOffset, QSMUSICSCREEN_WIDTH * factor / 70, factor);
        _headerImageView.frame = f;
        
        _tempHeaderView.alpha = 0.0;
        _tempHeaderView.frame = CGRectMake(0, -70, QSMUSICSCREEN_WIDTH, 70);
    }else {
        CGRect f = _headerView.frame;
        f.origin.y = 0;
        _headerView.frame = f;
        _headerImageView.frame = CGRectMake(0, f.origin.y, QSMUSICSCREEN_WIDTH, 70);
    }
    if (yOffset > 70) {
        self.tempHeaderView.alpha = 1.0;
        [UIView animateWithDuration:0.2 animations:^{
            _tempHeaderView.frame = CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 70);
        }];
    }
}

@end
