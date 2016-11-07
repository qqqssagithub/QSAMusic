//
//  LrcTableView.m
//  TingDemo
//
//  Created by 007 on 16/6/29.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import "LrcTableView.h"
#import "LrcTableViewCell.h"

@interface LrcTableView ()

@property (nonatomic) NSMutableArray *timeArray;
@property (nonatomic) NSMutableArray *lrcArray;


@end

@implementation LrcTableView

+ (instancetype)sharedLrcTableView {
    static LrcTableView *sharedLrcTableView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLrcTableView = [[LrcTableView alloc] init];
        sharedLrcTableView.lrcArray = [NSMutableArray new];
        sharedLrcTableView.timeArray = [NSMutableArray new];
        sharedLrcTableView.tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 12, QSMUSICSCREEN_WIDTH - 80 -16, QSMUSICSCREEN_WIDTH - 24)];//CGRectMake(8, 8, 240 -16, 320 -16)
        sharedLrcTableView.tableView.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH - 80 -16, (QSMUSICSCREEN_WIDTH -24) / 2)];//CGRectMake(0, 0, 240 -16, (320 -16) / 2)
        view.backgroundColor = [UIColor clearColor];
        sharedLrcTableView.tableView.tableHeaderView = view;
        sharedLrcTableView.tableView.tableFooterView = view;
        sharedLrcTableView.tableView.showsVerticalScrollIndicator = NO;
        sharedLrcTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [sharedLrcTableView.tableView registerNib:[UINib nibWithNibName:@"LrcTableViewCell" bundle:nil] forCellReuseIdentifier:@"lrc"];
        sharedLrcTableView.tableView.delegate = sharedLrcTableView;
        sharedLrcTableView.tableView.dataSource = sharedLrcTableView;
        sharedLrcTableView.tableView.backgroundColor = [UIColor clearColor];
    });
    return sharedLrcTableView;
}

- (void)initLrcWithLrcURL:(NSString *)lrcURL{
    NSString *url = [lrcURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _lrc = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    [self initLrcWithLrc:_lrc];
}

- (void)initLrcWithLrcStr:(NSString *)lrcStr{
    _lrc = lrcStr;
    [self initLrcWithLrc:_lrc];
}

- (void)initLrcWithLrc:(NSString *)lrc {
    [_timeArray removeAllObjects];
    [_lrcArray removeAllObjects];
    NSInteger index = 0;
    NSArray *arr = [_lrc componentsSeparatedByString:@"\n"];
    for (NSString *str in arr) {
        if ([str hasPrefix:@"[00:0"]) {
            break;
        }
        index++;
    }
    if (arr.count != 0) {
        for (NSInteger i = index; i < arr.count - 1; i++) {
            NSString *tempTimeItem = arr[i];
            if (tempTimeItem.length >= 10) {
                NSString *timeItem = [arr[i] substringWithRange:NSMakeRange(1, 5)];
                [_timeArray addObject:timeItem];
                NSString *lrcItem = [arr[i] substringFromIndex:10];
                [_lrcArray addObject:lrcItem];
            }
        }
    }
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)updateLrcWithCurrentTime:(NSString *)currentTime {
    for (NSInteger index = 0; index < _timeArray.count; index++) {
        if ([currentTime isEqualToString:_timeArray[index]]) {
            LrcTableViewCell *cell = (LrcTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            LrcTableViewCell *beforeCell = (LrcTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index - 1 inSection:0]];
            if ([PlayView sharedPlayView].isLoad) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            } else {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            //beforeCell.lrcLabel.textColor = [UIColor whiteColor];
            [beforeCell.lrcLabel setFont:[UIFont systemFontOfSize:14.0]];
            //cell.lrcLabel.textColor = [UIColor redColor];
            [cell.lrcLabel setFont:[UIFont systemFontOfSize:20.0]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_lrcArray.count == 0) {
        return 1;
    } 
    return _lrcArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LrcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lrc" forIndexPath:indexPath];
    cell.lrcLabel.textColor = [UIColor whiteColor];
    if (_lrcArray.count == 0) {
        cell.lrcLabel.text = @"暂时没有歌词!";
        cell.lrcLabel.textColor = [UIColor redColor];
    } else {
        cell.lrcLabel.text = self.lrcArray[indexPath.row];
    }
    cell.lrcLabel.lineBreakMode = NSLineBreakByClipping;
    [cell.lrcLabel setFont:[UIFont systemFontOfSize:14.0]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_timeArray.count != 0) {
        NSString *timeStr = _timeArray[indexPath.row];
        NSString *minute = [timeStr substringWithRange:NSMakeRange(0, 2)];
        NSString *second = [timeStr substringWithRange:NSMakeRange(3, 2)];
        NSTimeInterval curtime = [minute integerValue] *60 + [second integerValue];
        [QSMusicPlayer playAtTime:curtime];
    }
}

@end
