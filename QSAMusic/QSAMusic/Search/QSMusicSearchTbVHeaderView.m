//
//  QSMusicSearchTbVHeaderView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/14.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearchTbVHeaderView.h"

@implementation QSMusicSearchTbVHeaderView

- (IBAction)buttonAction:(UIButton *)sender {
    if (_buttonBlock) {
        _buttonBlock(sender.tag);
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
