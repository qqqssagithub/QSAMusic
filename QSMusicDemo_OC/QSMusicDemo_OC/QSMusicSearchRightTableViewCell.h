//
//  QSMusicSearchRightTableViewCell.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/13.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicSearchRightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel     *title;
@property (weak, nonatomic) IBOutlet UILabel     *publishtime;
@property (nonatomic)                NSString    *albumId;
@property (nonatomic) NSString *indexStr;

- (void)updateWithData:(NSDictionary *)data;

@end
