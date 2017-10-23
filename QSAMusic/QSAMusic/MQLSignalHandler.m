//
//  MQLSignalHandler.m
//  QSAMusic
//
//  Created by 陈少文 on 17/8/16.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import "MQLSignalHandler.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>

//当前处理的异常个数
volatile int32_t UncaughtExceptionCount = 0;
//最大能够处理的异常个数
volatile int32_t UncaughtExceptionMaximum = 10;

/**
 *  捕获信号后的回调函数
 *
 *  @param signo 信号变量
 */
void callbackHandlerOfCatchedSignal(int signo)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signo] forKey:@"signal"];
    //创建一个OC异常对象
    NSException *ex = [NSException exceptionWithName:@"SignalExceptionName" reason:[NSString stringWithFormat:@"Signal %d was raised.\n",signo] userInfo:userInfo];
    //处理异常消息
    [[MQLSignalHandler instance] performSelectorOnMainThread:@selector(handleExceptionTranslatedFromSignal:) withObject:ex waitUntilDone:YES];
}

void UncaughtExceptionHandler(NSException *exception) {
//    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
//    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
//    NSString *name = [exception name];//异常类型
//    
//    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    [[MQLSignalHandler instance] performSelectorOnMainThread:@selector(handleExceptionTranslatedFromSignal:) withObject:exception waitUntilDone:YES];
}

@interface MQLSignalHandler ()

@property BOOL isDismissed;

/**
 *  注册信号处理器
 */
- (void)registerSignalHandler;

@end

@implementation MQLSignalHandler

/**
 *  信号处理器单例获取
 *
 *  @return 信号处理器单例
 */
+ (instancetype)instance{
    
    static dispatch_once_t onceToken;
    static MQLSignalHandler *s_SignalHandler =  nil;
    
    dispatch_once(&onceToken, ^{
        if (s_SignalHandler == nil) {
            s_SignalHandler  =  [[MQLSignalHandler alloc] init];
        }
    });
    return s_SignalHandler;
}

- (void)start {
    [self setLogPath];
    [self registerSignalHandler];
}

- (void)setLogPath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"Log.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    _logPath = filePath;
}

/**
 *  注册信号处理器
 */
- (void)registerSignalHandler
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, callbackHandlerOfCatchedSignal);
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, callbackHandlerOfCatchedSignal);
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, callbackHandlerOfCatchedSignal);
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, callbackHandlerOfCatchedSignal);
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, callbackHandlerOfCatchedSignal);
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, callbackHandlerOfCatchedSignal);
}

//处理异常用到的方法
- (void)handleExceptionTranslatedFromSignal:(NSException *)exception
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isCrash"];
    
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    NSString *str;
    NSArray *callStackSymbols;
    NSString *reason;
    
    NSString *name = exception.name;
    
    if ([name isEqualToString:@"SignalExceptionName"]) {
        NSDictionary *userInfo = exception.userInfo;
        NSNumber *num = userInfo[@"signal"];
        int i = [num intValue];
        str = [NSString stringWithFormat:@"%d", i];
    } else {
        callStackSymbols = [exception callStackSymbols];//得到当前调用栈信息
        reason = [exception reason];//非常重要，就是崩溃的原因
        str = [NSString stringWithFormat:@"--------%@--------\n错误名称:%@\n错误原因:%@\n堆栈信息:%@\n\n\n", locationString, name, reason, callStackSymbols];
        
        NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:_logPath];
        [handle seekToEndOfFile];
        [handle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    }
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"程序出现问题啦" message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//    [alertView show];
    
    //当接收到异常处理消息时，让程序开始runloop，防止程序死亡
//    while (!_isDismissed) {
//        for (NSString *mode in (__bridge NSArray *)allModes)
//        {
//            CFRunLoopRunInMode((CFStringRef)mode, 0, true);
//        }
//    }
    
    //当点击弹出视图的Cancel按钮哦,isDimissed ＝ YES,上边的循环跳出
//    CFRelease(allModes);
    
    //拦截处理后，执行默认处理
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
//    if ([name isEqualToString:@"SignalExceptionName"]) {
//        NSDictionary *userInfo = exception.userInfo;
//        NSNumber *num = userInfo[@"signal"];
//        int i = [num intValue];
//        kill(getpid(), i);
//    } else {
//        [exception raise];
//    }
}

@end
