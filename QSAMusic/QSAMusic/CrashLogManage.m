//
//  CrashLogManage.m
//  QSAMusic
//
//  Created by 陈少文 on 17/8/15.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import "CrashLogManage.h"

@interface CrashLogManage ()

@end

@implementation CrashLogManage

+ (instancetype)shareInstance {
    static CrashLogManage *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
        [_manager uiConfig];
    });
    return _manager;
}

- (void)uiConfig{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"Log.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    self.logFilePath = filePath;
}

CrashLogManage *InstanceZFJUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    return [CrashLogManage shareInstance];
}

void HandleException(NSException *exception) {
    //    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    //    //如果太多不用处理
    //    if (exceptionCount > UncaughtExceptionMaximum) {
    //        return;
    //    }
    //
    //    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    //    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    //    NSString *name = [exception name];//异常类型
    //
    //    NSString *str = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    //
    //    NSLog(@"%@", str);
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:@"UncaughtExceptionHandlerAddressesKey"];
    [[CrashLogManage shareInstance] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo] waitUntilDone:YES];
}

void SignalHandler (int signal){
    //    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    //    if (exceptionCount > UncaughtExceptionMaximum) {
    //        return;
    //    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:@"UncaughtExceptionHandlerSignalKey"];
    //NSArray *callStack = [ZFJUncaughtExceptionHandler backtrace];
    [userInfo setObject:@"123" forKey:@"UncaughtExceptionHandlerAddressesKey"];
    [[CrashLogManage shareInstance] performSelectorOnMainThread:@selector(handleException:) withObject: [NSException exceptionWithName:@"UncaughtExceptionHandlerSignalExceptionName" reason: [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal] userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:@"UncaughtExceptionHandlerSignalKey"]] waitUntilDone:YES];
}

- (void)handleException:(NSException *)exception{
    //保存日志 可以发送日志到自己的服务器上
    [self validateAndSaveCriticalApplicationData:exception];
    NSString *_erroeMeg = nil;
    NSString *userInfo = [[exception userInfo] objectForKey:@"UncaughtExceptionHandlerAddressesKey"];
    _erroeMeg = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n" @"异常原因如下:\n%@\n%@", nil), [exception reason], userInfo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉,程序出现了异常" message:_erroeMeg delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"继续", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    for (NSString *mode in (__bridge NSArray *)allModes) {
        CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
    }
    CFRelease(allModes);
#pragma clang diagnostic pop
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:@"UncaughtExceptionHandlerSignalExceptionName"]) {
        kill(getpid(), [[[exception userInfo] objectForKey:@"UncaughtExceptionHandlerSignalKey"] intValue]);
    }else{
        [exception raise];
    }
}

- (void)validateAndSaveCriticalApplicationData:(NSException *)exception{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isCrash"];
    NSString *exceptionMessage = [NSString stringWithFormat:NSLocalizedString(@"\n******************** %@ 异常原因如下: ********************\n%@\n%@\n==================== End ====================\n\n", nil), @"08.16", [exception reason], [[exception userInfo] objectForKey:@"UncaughtExceptionHandlerAddressesKey"]];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"Log.txt"];
    
    NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [handle seekToEndOfFile];
    [handle writeData:[exceptionMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

@end
