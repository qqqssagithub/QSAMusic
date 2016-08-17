//
//  QSMusicGeDanTopCollectionViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/2.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicGeDanTopCollectionViewCell.h"

@implementation QSMusicGeDanTopCollectionViewCell

- (void)updateWithData:(NSDictionary *)data {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:data[@"pic_300"]]];
    _title.text = data[@"title"];
    _num.text = data[@"listenum"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
