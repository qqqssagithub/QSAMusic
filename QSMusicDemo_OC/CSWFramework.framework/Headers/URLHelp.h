//
//  URLHelp.h
//  CSWFramework
//
//  Created by 007 on 16/7/11.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLHelp : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *url_songData;
@property (nonatomic) NSString *song_url;
@property (nonatomic) NSString *song_url_x;

+ (instancetype)sharedURLHelp;

@end
