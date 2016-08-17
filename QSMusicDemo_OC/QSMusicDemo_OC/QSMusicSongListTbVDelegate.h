//
//  QSMusicSongListTbVDelegate.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSMusicSongListView.h"

@interface QSMusicSongListTbVDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSString *indexStr;
@property (nonatomic) QSMusicSongListView *supView;
@property (nonatomic) void(^backBlock)(void);

+ (instancetype)sharedQSMusicSongListTbVDelegate;

- (void)reloadDataWithTitle:(NSString *)title data:(NSArray *)dataArr tableView:(UITableView *)tableView;

@end
