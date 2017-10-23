//
//  MQLSignalHandler.h
//  QSAMusic
//
//  Created by 陈少文 on 17/8/16.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/signal.h>

@interface MQLSignalHandler : NSObject

@property (nonatomic) NSString *logPath;

/**
 *  信号处理器单例获取
 *
 *  @return 信号处理器单例
 */
+ (instancetype)instance;

- (void)start;

/**
 *  处理异常用到的方法
 *
 *  @param exception 自己封装的异常对象
 */
- (void)handleExceptionTranslatedFromSignal:(NSException *)exception;

@end
