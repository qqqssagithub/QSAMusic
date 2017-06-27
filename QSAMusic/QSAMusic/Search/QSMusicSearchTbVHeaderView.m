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
    switch (sender.tag) {
        case 0:
            [QSAKitAlertView showWithTitle:@"提示" message:@"功能完善中， 敬请期待" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            break;
        case 1:
            [QSAKitAlertView showWithTitle:@"提示" message:@"功能完善中， 敬请期待" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            break;
        case 2:
            [QSAKitAlertView showWithTitle:@"提示" message:@"功能完善中， 敬请期待" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            break;
        default:
            break;
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
