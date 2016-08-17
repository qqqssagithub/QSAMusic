//
//  QSMusicPlayerDelegate.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/8.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicPlayerDelegate : NSObject 

@property (nonatomic) NSString *playStyle;   //风格。有Ordinary和EVA两种
@property (nonatomic) UIView *playPointView; //播放点(也就是界面上那个无处不在的圆点)

+ (instancetype)sharedQSMusicPlayerDelegate;

- (void)openPlayPoint;

- (void)downloadSong;

@end
