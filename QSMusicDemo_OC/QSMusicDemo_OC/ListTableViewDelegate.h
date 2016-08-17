//
//  ListTableViewDelegate.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/13.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListTableViewDelegate : NSObject

+ (instancetype)sharedListTableViewDelegate;

- (void)reloadDataWithData:(NSArray *)dataArr tableView:(UITableView *)tableView;

@end
