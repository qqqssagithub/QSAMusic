//
//  QSMusicIFlytekDataHelper.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/14.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicIFlytekDataHelper : NSObject

/**
 *  解析命令词返回的结果
 *
 *  @param params 命令词
 *
 *  @return 结果
 */
+ (NSString *)stringFromAsr:(NSString*)params;

/**
 *  解析JSON数据
 *
 *  @param params JSON数据
 *
 *  @return 结果
 */
+ (NSString *)stringFromJson:(NSString*)params;//


/**
 *  解析语法识别返回的结果
 *
 *  @param params 语法词
 *
 *  @return 结果
 */
+ (NSString *)stringFromABNFJson:(NSString*)params;

@end
