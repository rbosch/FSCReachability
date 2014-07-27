FSCReachability
===============

Simple COCOA Reachability wrapper


# Installation
- add `SystemConfiguration.framework`
- add FSCReachability repository to project


# Usage


````cocoa

	// file.h
	include "FSCReachability/source/FSCReachability.h"
	@interface .... {
		FSCReachability *reachability;
	}
	@end
	
	// file.m
	- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
		// Crewate Reachibily instance
		reachability = [[FSCReachability alloc] initWithHostname:@"www.my_site.com"];

		// Subscribe to one or more notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:FSCReachabilityChangedNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityOnline:) name:FSCReachabilityOnlineNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityOffline:) name:FSCReachabilityOfflineNotification object:nil];

	}
	
	- (void)reachabilityChanged:(NSNotification *)note {
		NSLog(@"%s", __FUNCTION__);
		FSCReachability* curReach = [note object];
		NSParameterAssert([curReach isKindOfClass:[FSCReachability class]]);
		// do something usefull
	}

	- (void)reachabilityOnline:(NSNotification *)note {
		NSLog(@"%s", __FUNCTION__);
		FSCReachability* curReach = [note object];
		NSParameterAssert([curReach isKindOfClass:[FSCReachability class]]);
		// do something usefull
	}

	- (void)reachabilityOffline:(NSNotification *)note {
		NSLog(@"%s", __FUNCTION__);
		FSCReachability* curReach = [note object];
		NSParameterAssert([curReach isKindOfClass:[FSCReachability class]]);
		// do something usefull
	}

````