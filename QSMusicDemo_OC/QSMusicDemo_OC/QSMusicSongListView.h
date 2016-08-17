//
//  QSMusicSongListView.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicSongListView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIView *supView;

- (void)reloadDataWithTitle:(NSString *)title data:(NSArray *)dataArr indexStr:(NSString *)indexStr;

- (void)back;

@end
