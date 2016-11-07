//
//  QSMusicSearchResultViewLeftTbVDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearchResultViewLeftTbVDelegate.h"
#import "QSMusicSearchLeftTableViewCell.h"

@interface QSMusicSearchResultViewLeftTbVDelegate ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSDictionary *dataDic;

@end

@implementation QSMusicSearchResultViewLeftTbVDelegate

+ (instancetype)sharedQSMusicSearchResultViewLeftTbVDelegate {
    static QSMusicSearchResultViewLeftTbVDelegate *sharedQSMusicSearchResultViewLeftTbVDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicSearchResultViewLeftTbVDelegate = [[QSMusicSearchResultViewLeftTbVDelegate alloc] init];
    });
    return sharedQSMusicSearchResultViewLeftTbVDelegate;
}

- (void)tableview:(UITableView *)tableView reloadDataWithData:(NSDictionary *)dataDic {
    _tableView = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"QSMusicSearchLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchLeftTableViewCellid"];
    tableView.delegate = self;
    tableView.dataSource = self;
    _dataDic = dataDic;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(_dataDic[@"song_list"])).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
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
    QSMusicSearchLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchLeftTableViewCellid"];
    NSDictionary *data = _dataDic[@"song_list"][indexPath.row];
    cell.indexStr = @"searchLeftTableView";
    [cell updateWithData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataArr = _dataDic[@"song_list"];
    
    [QSMusicPlayerDelegate sharedQSMusicPlayerDelegate].playStyle = @"Ordinary";
    [[QSMusicPlayerDelegate sharedQSMusicPlayerDelegate] openPlayPoint];
    [PlayView sharedPlayView].isLoad = NO;
    [[PlayView sharedPlayView] updataListWithData:dataArr];
    [PlayView sharedPlayView].currentIndex = indexPath.row;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QSMusicPlayer createPlayListWithPlayList:dataArr listid:dataArr[0][@"author"]];
        [QSMusicPlayer playAtIndex:indexPath.row];
    });
}

@end
