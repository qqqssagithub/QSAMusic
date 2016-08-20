//
//  QSMusicGeShou.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicGeShou.h"
#import "QSMusicGeShouSectionOneTableViewCell.h"
#import "QSMusicGeShouSectionOtherTableViewCell.h"
#import "QSMusicGeShouCollectionViewCell.h"
#import "QSMusicSearchResultView.h"

@interface QSMusicGeShou ()

@property (nonatomic) NSArray *dataArr;
@property (nonatomic) NSArray *tableDataArr;

@end

@implementation QSMusicGeShou

+ (instancetype)sharedQSMusicGeShou {
    static QSMusicGeShou *sharedQSMusicGeShou = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicGeShou = [[QSMusicGeShou alloc] init];
        sharedQSMusicGeShou.tableView = [[UITableView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH * 3, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 - 33)];
        sharedQSMusicGeShou.tableView.showsVerticalScrollIndicator = NO;
        sharedQSMusicGeShou.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [sharedQSMusicGeShou.tableView registerNib:[UINib nibWithNibName:@"QSMusicGeShouSectionOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"geShouOneCellid"];
        [sharedQSMusicGeShou.tableView registerNib:[UINib nibWithNibName:@"QSMusicGeShouSectionOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"geShouOtherCellid"];
        sharedQSMusicGeShou.tableView.delegate = sharedQSMusicGeShou;
        sharedQSMusicGeShou.tableView.dataSource = sharedQSMusicGeShou;
        [sharedQSMusicGeShou initTableDataArr];
       [sharedQSMusicGeShou requestData];
    });
    return sharedQSMusicGeShou;
}

- (void)initTableDataArr {
    _tableDataArr = @[@[], @[@"华语男歌手", @"华语女歌手", @"华语乐队组合"], @[@"欧美男歌手手", @"欧美女歌手", @"欧美乐队组合"], @[@"韩国男歌手", @"韩国女歌手", @"韩国乐队组合"], @[@"日本男歌手", @"日本女歌手", @"日本乐队组合"]];
}

- (void)requestData {
    [QSMusicPlayer getHotSinger:^(NSArray * _Nonnull dataArr) {
        if (dataArr.count == 0) {
            [CSWAlertView initWithTitle:@"提示" message:@"刷新失败，请检查网络" cancelButtonTitle:@"确定"];
            UINib *nib = [UINib nibWithNibName:@"QSMusicNetFailedView" bundle:nil];
            QSMusicNetFailedView *view = [nib instantiateWithOwner:nil options:nil][0];
            view.frame = CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33);
            [_tableView addSubview:view];
            view.reload = ^{
                [self requestData];
            };
        } else {
            _dataArr = dataArr;
            [_tableView reloadData];
        }
    }];
}

#pragma mark - tableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return ((NSArray *)_tableDataArr[section]).count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 4)];
    sectionView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 182;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QSMusicGeShouSectionOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"geShouOneCellid"];
        [cell.collectionView registerNib:[UINib nibWithNibName:@"QSMusicGeShouCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"geShouCollCellid"];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        [cell.collectionView reloadData];
        return cell;
    }
    QSMusicGeShouSectionOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"geShouOtherCellid"];
    cell.label.text = _tableDataArr[indexPath.section][indexPath.row];
    if (indexPath.section == 4 && indexPath.row == 2) {
        cell.line.alpha = 0.0;
    } else {
        cell.line.alpha = 1.0;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        [self requestListWithSection:indexPath.section row:indexPath.row];
    }
}

- (void)requestListWithSection:(NSInteger)section row:(NSInteger)row {
    NSString *sexid = [NSString stringWithFormat:@"%ld", row + 1];
    NSArray *area =  @[@"", @"0", @"3", @"7", @"60"];
    [CSWProgressView showWithPrompt:@"加载中"];
    [QSMusicPlayer getSingerListWithLimit:100 areaid:area[section] sexid:sexid responseClosure:^(NSArray * _Nonnull dataArr) {
        [CSWProgressView disappear];
        NSString *title = [NSString stringWithFormat:@"%@ - TOP100", _tableDataArr[section][row]];
        UINib *nib = [UINib nibWithNibName:@"QSMusicSongListView" bundle:nil];
        QSMusicSongListView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
        view.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
        view.supView = QSMusicRootVC_rootBackView;
        [QSMusicRootVC_View addSubview:view];
        [view reloadDataWithTitle:title data:dataArr indexStr:@"geShou"];
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = QSMUSICSCREEN_RECT;
            view.supView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
    }];
}

#pragma mark - collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSMusicGeShouCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"geShouCollCellid" forIndexPath:indexPath];
    NSDictionary *data = _dataArr[indexPath.row];
    [cell updateWithData:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [CSWProgressView showWithPrompt:@"加载中"];
    [QSMusicPlayer getSearchDataWithKeyword:_dataArr[indexPath.row][@"name"] pageSize:10 responseClosure:^(NSDictionary * _Nonnull data) {
        [CSWProgressView disappear];
        UINib *nib = [UINib nibWithNibName:@"QSMusicSearchResultView" bundle:nil];
        QSMusicSearchResultView *view = [[nib instantiateWithOwner:nil options:nil] firstObject];
        view.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
        [view reloadDataWithData:data];
        __block typeof(view) blockView = view;
        UIView *rootBackView = QSMusicRootVC_rootBackView;
        view.backBlock = ^{
            [UIView animateWithDuration:0.3 animations:^{
                blockView.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
                rootBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                [blockView removeFromSuperview];
            }];
        };
        [QSMusicRootVC_View addSubview:view];
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = QSMUSICSCREEN_RECT;
            rootBackView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
    }];
}

@end
