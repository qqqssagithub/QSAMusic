//
//  QSMusicSearchResultViewRightTbVDelegate.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSMusicSearchResultView.h"

@interface QSMusicSearchResultViewRightTbVDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) QSMusicSearchResultView *supView;

+ (instancetype)sharedQSMusicSearchResultViewRightTbVDelegate;

- (void)tableview:(UITableView *)tableView reloadDataWithData:(NSDictionary *)dataDic;

@end
