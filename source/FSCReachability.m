//
//  FSCReachability.m
//  TCPServer
//
//  Created by Rogier Bosch on 17/07/14.
//  Copyright (c) 2014 Flare Star Creations. All rights reserved.
//

#import "FSCReachability.h"

// Notification messages
NSString *FSCReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";
NSString *FSCReachabilityOnlineNotification = @"kNetworkReachabilityOnlineNotification";
NSString *FSCReachabilityOfflineNotification = @"kNetworkReachabilityOfflineNotification";

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
    NSLog(@"%s", __FUNCTION__);
    FSCReachability* noteObject = (__bridge FSCReachability *)info;
    noteObject.flags = flags;
    [noteObject printNetworkStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: FSCReachabilityChangedNotification object: noteObject];
    
    if (flags & kSCNetworkReachabilityFlagsReachable) {
        
        if (flags & kSCNetworkReachabilityFlagsConnectionRequired) {
            [[NSNotificationCenter defaultCenter] postNotificationName: FSCReachabilityOfflineNotification object: noteObject];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName: FSCReachabilityOnlineNotification object: noteObject];
            
        }
        
    }
}


@implementation FSCReachability

@synthesize flags = _flags; // holds reachability status

- (id)initWithHostname:(NSString *)hostName
{
    if (self = [super init]) {

        _reachabilityRef = SCNetworkReachabilityCreateWithName(NULL,[hostName UTF8String]);

        SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        
        if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
        {
            if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
            {
                NSLog(@"SCNetworkReachability scheduled with runloop");
            }
        }
    }
    return self;

}

- (void)checkNetworkStatus
{
    SCNetworkReachabilityGetFlags(_reachabilityRef, &_flags);
}

/* return network status string */
- (NSString *)networkStatus
{
#if TARGET_OS_IPHONE
   return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c"
          (flags & kSCNetworkReachabilityFlagsIsWWAN)		  		 ? 'W' : '-',     /* only available iOS */
          (_flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          (_flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (_flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (_flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (_flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (_flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (_flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (_flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'
          ];
    
#else
    return [NSString stringWithFormat:@"%c %c%c%c%c%c%c%c",
          (_flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          (_flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (_flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (_flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (_flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (_flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (_flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (_flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'
          ];
#endif
    
}

/* for debuging purpose */
- (void)printNetworkStatus
{
    NSLog(@"Reachability Flag Status: %@", [self networkStatus]);
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    
    SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

    if (_reachabilityRef != NULL)
	{
        NSLog(@"release");
		CFRelease(_reachabilityRef);
	}

}

@end
