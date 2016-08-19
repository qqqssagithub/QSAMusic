//
//  CSWFarmeworkTest.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/19.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CSWFramework/CSWFramework.h>
#import <QSMusicEngine/QSMusicEngine.h>
#import "QSMusicXinDie.h"

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];


@interface CSWFarmeworkTest : XCTestCase

@end

@implementation CSWFarmeworkTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//歌单测试
- (void)testExample {
    [[QSMusicXinDie sharedQSMusicXinDie] requestSingleWithAlbumId:@"269107012" response:^(NSDictionary *albumInfo, NSArray *songList) {
        NSLog(@"请求完成");
        NOTIFY
    }];
    WAIT
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
    }];
}

@end
