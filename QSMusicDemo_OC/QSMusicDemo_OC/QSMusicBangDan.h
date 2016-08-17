//
//  QSMusicXInDie.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicBangDan : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

+ (instancetype)sharedQSMusicBangDan;

@end
