//
//  QSMusciBangDanTableViewCell.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/2.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusciBangDanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *first;
@property (weak, nonatomic) IBOutlet UILabel *seconds;
@property (weak, nonatomic) IBOutlet UILabel *third;

- (void)updateWithData:(NSDictionary *)data;

@end
