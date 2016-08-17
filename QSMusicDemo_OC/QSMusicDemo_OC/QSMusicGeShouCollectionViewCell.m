//
//  QSMusicGeShouCollectionViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/2.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicGeShouCollectionViewCell.h"

@implementation QSMusicGeShouCollectionViewCell

- (void)updateWithData:(NSDictionary *)data {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:data[@"avatar_big"]]];
    _name.text = data[@"name"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
