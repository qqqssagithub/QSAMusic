//
//  QSMusicGeDanOtherCollectionViewCell.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/2.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicGeDanOtherCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

- (void)updateWithData:(NSDictionary *)data;

@end
