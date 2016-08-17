//
//  QSMusicPublicBigHeaderViewDelegate.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/8.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicPublicBigHeaderViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

+ (instancetype)sharedQSMusicPublicBigHeaderViewDelegate;

- (void)updateWithHeaderInfo:(NSDictionary *)headerInfo songList:(NSArray *)list view:(QSMusicPublicBigHeaderView *)view;

@end
