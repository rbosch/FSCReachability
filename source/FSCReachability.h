//
//  FSCReachability.h
//  TCPServer
//
//  Created by Rogier Bosch on 17/07/14.
//  Copyright (c) 2014 Flare Star Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


extern NSString *FSCReachabilityChangedNotification;
extern NSString *FSCReachabilityOnlineNotification;
extern NSString *FSCReachabilityOfflineNotification;

@interface FSCReachability : NSObject
{
    SCNetworkReachabilityRef _reachabilityRef;
}

@property SCNetworkReachabilityFlags flags;

- (id)initWithHostname:(NSString *)hostName;
- (void)checkNetworkStatus;
- (void)printNetworkStatus;

@end
