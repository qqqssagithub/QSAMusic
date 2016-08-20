//
//  QSMusicNetFailedView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/20.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicNetFailedView.h"

@implementation QSMusicNetFailedView

- (IBAction)reloda:(id)sender {
    [self removeFromSuperview];
    if (_reload) {
        _reload();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
