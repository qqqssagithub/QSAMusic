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
        NSString *title = data[@"author"];
        NSRange rang = [title rangeOfString:@"</em>"];
        if (rang.location != NSNotFound) {
            title = [NSString stringWithFormat:@"%@",  [title substringWithRange:NSMakeRange(4, rang.location - 4)]];
        }
        _title.text = title;
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
