//
//  QSMusicSongListView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSongListView.h"
#import "QSMusicSongListTbVDelegate.h"

@implementation QSMusicSongListView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    
//}

- (void)reloadDataWithTitle:(NSString *)title data:(NSArray *)dataArr indexStr:(NSString *)indexStr {
    QSMusicSongListTbVDelegate *delegate = [QSMusicSongListTbVDelegate sharedQSMusicSongListTbVDelegate];
    delegate.indexStr = indexStr;
    delegate.supView = self;
    [delegate reloadDataWithTitle:title data:dataArr tableView:_tableView];
    delegate.backBlock = ^{
        [self back];
    };
}

- (void)back {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
        _supView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
