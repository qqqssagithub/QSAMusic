//
//  ListTableViewDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/13.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "ListTableViewDelegate.h"
#import "QSMusicEQPlayer.h"

@interface ListTableViewDelegate () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *dataArr;
//@property (nonatomic)

@end

@implementation ListTableViewDelegate

+ (instancetype)sharedListTableViewDelegate {
    static ListTableViewDelegate *sharedListTableViewDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedListTableViewDelegate = [[ListTableViewDelegate alloc] init];
    });
    return sharedListTableViewDelegate;
}

- (void)reloadDataWithData:(NSArray *)dataArr tableView:(UITableView *)tableView {
    _dataArr = dataArr;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCellid"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCellid"];
    cell.backgroundColor = [UIColor clearColor];
    if ([PlayView sharedPlayView].isLoad == YES) {
        QSMusicSongDatas *model = _dataArr[indexPath.row];
        if (![model.versions isEqualToString:@""]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@) - %@", model.title, model.versions, model.author];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", model.title, model.author];
        }
    } else {
        if (![_dataArr[indexPath.row][@"versions"] isEqualToString:@""]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@) - %@", _dataArr[indexPath.row][@"title"], _dataArr[indexPath.row][@"versions"], _dataArr[indexPath.row][@"author"]];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", _dataArr[indexPath.row][@"title"], _dataArr[indexPath.row][@"author"]];
        }
    }
    cell.textLabel.font = QSMusicFont_14;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([PlayView sharedPlayView].isLoad == YES) {
        QSMusicEQPlayer *eqPlayer = [QSMusicEQPlayer sheardQSMusicEQPlayer];
        [eqPlayer platerWithIndex:indexPath.row];
    } else {
        [QSMusicPlayer playAtIndex:indexPath.row];
    }
}

@end
