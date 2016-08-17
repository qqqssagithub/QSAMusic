//
//  QSMusicPublicSongListTableViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/5.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

/**
 *  单曲列表
 *
 *  @return 
 */
#import "QSMusicPublicSongListTableViewCell.h"

@implementation QSMusicPublicSongListTableViewCell

- (void)updateWithData:(NSDictionary *)data {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:data[@"thumb"]]];
    
    if (![data[@"versions"] isEqualToString:@""]) {
        _title.text = [NSString stringWithFormat:@"%@(%@)", data[@"title"], data[@"versions"]];
    } else {
        _title.text = data[@"title"];
    }
    
    _name.text = data[@"artist"];
}

- (void)updateWithModel:(QSMusicSongDatas *)model {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:model.pic_radio]];
    if (![model.versions isEqualToString:@""]) {
        _title.text = [NSString stringWithFormat:@"%@(%@)", model.title, model.versions];
    } else {
        _title.text = model.title;
    }
    
    _name.text = model.author;
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
