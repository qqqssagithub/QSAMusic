//
//  QSMusicSearchRightTableViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/13.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearchRightTableViewCell.h"

@implementation QSMusicSearchRightTableViewCell

- (void)updateWithData:(NSDictionary *)data {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:data[@"pic_small"]]];
    NSString *title = data[@"title"];
    NSRange rang = [title rangeOfString:@"</em>"];
    if (rang.location != NSNotFound) {
        title = [NSString stringWithFormat:@"%@ - %@",  [title substringWithRange:NSMakeRange(4, rang.location - 4)], [title substringFromIndex:rang.location + rang.length]];
    }
    _title.text = title;
    if ([_indexStr isEqualToString:@"search"]) {
        NSString *title = data[@"author"];
        NSRange rang = [title rangeOfString:@"</em>"];
        if (rang.location != NSNotFound) {
            title = [NSString stringWithFormat:@"%@ - %@",  [title substringWithRange:NSMakeRange(4, rang.location - 4)], [title substringFromIndex:rang.location + rang.length]];
        }
        _publishtime.text = [NSString stringWithFormat:@"%@ (%@)", title, data[@"publishtime"]];
    } else {
        _publishtime.text = data[@"publishtime"];
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
