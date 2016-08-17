//
//  CSWNetworkMonitoringManager.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealReachability.h"

@interface CSWNetworkMonitoringManager : NSObject

@property (nonatomic) RealReachability *netState;

/**
 Returns the shared network monitoring manager.
 */
+ (instancetype)sharedManager;

/**
 Starts monitoring for changes in network reachability status.
 */
- (void)startMonitoring;

/**
 Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

/**
 Returns the current state of the network.
 */
- (NetworkStatus)currentReachabilityStatus;

@end
