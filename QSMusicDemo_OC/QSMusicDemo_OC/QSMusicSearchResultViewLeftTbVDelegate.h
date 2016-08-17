//
//  QSMusicSearchResultViewLeftTbVDelegate.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicSearchResultViewLeftTbVDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

+ (instancetype)sharedQSMusicSearchResultViewLeftTbVDelegate;

- (void)tableview:(UITableView *)tableView reloadDataWithData:(NSDictionary *)dataDic;

@end
