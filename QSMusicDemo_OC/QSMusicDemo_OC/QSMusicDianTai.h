//
//  QSMusicDianTai.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "iCarousel.h"

#import <iCarousel/iCarousel.h>

@interface QSMusicDianTai : NSObject

@property (nonatomic) iCarousel *carousel;

+ (instancetype)sharedQSMusicDianTai;

@end
