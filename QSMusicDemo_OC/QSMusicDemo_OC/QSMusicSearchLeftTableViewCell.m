//
//  QSMusicSearchLeftTableViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/13.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearchLeftTableViewCell.h"

@implementation QSMusicSearchLeftTableViewCell

- (void)updateWithData:(NSDictionary *)data {
    if (![data[@"versions"] isEqualToString:@""]) {
        _title.text = [NSString stringWithFormat:@"%@(%@)", data[@"title"], data[@"versions"] ];
    } else {
        _title.text = data[@"title"];
    }
    
    if ([_indexStr isEqualToString:@"searchLeftTableView"]) {
        _album_title.text = [NSString stringWithFormat:@"《%@》", data[@"album_title"]];
    } else {
        _album_title.text = data[@"author"];
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
