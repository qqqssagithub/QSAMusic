//
//  ListTableViewDelegate.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/13.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "ListTableViewDelegate.h"
#import "PlayView.h"

@interface ListTableViewDelegate ()

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

- (void)reloadDataWithData:(NSArray *)dataArr {
    _songList = dataArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _songList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCellid"];
    cell.backgroundColor = [UIColor clearColor];
    if (![_songList[indexPath.row][@"versions"] isEqualToString:@""]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@) - %@", _songList[indexPath.row][@"title"], _songList[indexPath.row][@"versions"], _songList[indexPath.row][@"author"]];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", _songList[indexPath.row][@"title"], _songList[indexPath.row][@"author"]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedBlock) {
        _selectedBlock(indexPath.row);
    }
    [[QSAAudioPlayer shared] prepare];
    [[PlayView sharedPlayView].playButtonView.playButton setImage:[UIImage imageNamed:@"zantingduan3"] forState:UIControlStateNormal];
    NSDictionary *song = _songList[indexPath.row];
    [[MusicManager shared] getMusicWithSongId:song[@"song_id"]];
}

- (void)selectRow:(NSInteger)row {
    [self tableView:[PlayView sharedPlayView].listTbV didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

@end
