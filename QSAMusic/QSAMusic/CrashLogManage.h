//
//  CrashLogManage.h
//  QSAMusic
//
//  Created by 陈少文 on 17/8/15.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashLogManage : NSObject

@property (nonatomic) NSString *logFilePath;

+ (instancetype)shareInstance;

CrashLogManage *InstanceZFJUncaughtExceptionHandler(void);

@end
