//
//  QSMusicSongListTableViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

/**
 *  歌手列表
 *
 *  @return 
 */
#import "QSMusicSongListTableViewCell.h"

@implementation QSMusicSongListTableViewCell

- (void)updateWithData:(NSDictionary *)data {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:data[@"avatar_middle"]]];
    if ([_indexStr isEqualToString:@"search"]) {
        _title.text = data[@"author"];
    } else {
        _title.text = data[@"name"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
