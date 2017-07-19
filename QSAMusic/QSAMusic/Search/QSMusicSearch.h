//
//  QSMusicSearch.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/14.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RootViewController;

@interface QSMusicSearch : NSObject

+ (instancetype)sharedQSMusicSearch;

- (void)initViewWithSuperVC:(RootViewController *)superVC;

@end
