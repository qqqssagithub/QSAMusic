//
//  LrcTableView.h
//  TingDemo
//
//  Created by 007 on 16/6/29.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcTableView : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSString    *lrc;

+ (instancetype)sharedLrcTableView;

- (void)initLrcWithLrcURL:(NSString *)lrcURL;
- (void)initLrcWithLrcStr:(NSString *)lrcStr;
- (void)updateLrcWithCurrentTime:(NSString *)currentTime;

@end
