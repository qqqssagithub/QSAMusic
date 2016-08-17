//
//  QSMusciBangDanTableViewCell.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/2.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusciBangDanTableViewCell.h"

@implementation QSMusciBangDanTableViewCell

- (void)updateWithData:(NSDictionary *)data {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:data[@"pic_s192"]]];
    NSString *one0 = data[@"content"][0][@"title"];
    NSString *one1 = data[@"content"][0][@"author"];
    _first.text = [NSString stringWithFormat:@"%@ -- %@", one0, one1];
    NSString *two0 = data[@"content"][1][@"title"];
    NSString *two1 = data[@"content"][1][@"author"];
    _seconds.text = [NSString stringWithFormat:@"%@ -- %@", two0, two1];
    NSString *three0 = data[@"content"][2][@"title"];
    NSString *three1 = data[@"content"][2][@"author"];
    _third.text = [NSString stringWithFormat:@"%@ -- %@", three0, three1];
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
