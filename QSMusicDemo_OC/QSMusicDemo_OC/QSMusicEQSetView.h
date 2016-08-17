//
//  QSMusicEQSetView.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/17.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicEQSetView : UIView

@property (nonatomic) void(^setDBBlock)(NSInteger index, double centerFrequency, double gain);
@property (nonatomic) void(^setDBWithStyleBlock)(NSArray *style);

@end
