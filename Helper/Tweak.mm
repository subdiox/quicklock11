#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <objc/runtime.h>
#import <SpringBoard/SpringBoard.h>
#import <rocketbootstrap/rocketbootstrap.h>

@interface SBUserAgent : NSObject
+ (id)sharedUserAgent;
// iOS 6
- (void)lockAndDimDevice;
@end

@interface SpringBoard (NEW)
- (void)lockAndDimDevice;
// iOS 11
- (void)_simulateLockButtonPress;
@end

@class QuickLockHelper;

static QuickLockHelper *quickLockHelper = nil;
static SpringBoard *g_SpringBoard = nil;

@interface QuickLockHelper : NSObject {
	CPDistributedMessagingCenter *center;
}

- (void)shouldLockDevice:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end

@implementation QuickLockHelper

- (id)init {
	if ((self = [super init])) {
		center = [CPDistributedMessagingCenter centerNamed:@"com.subdiox.quicklockhelper.center"];
		rocketbootstrap_distributedmessagingcenter_apply(center);
		[center runServerOnCurrentThread];
		[center registerForMessageName:@"SHOULDLOCKDEVICE" target:self selector:@selector(shouldLockDevice:userInfo:)];
	}
	
	return self;
}

- (void)shouldLockDevice:(NSString *)name userInfo:(NSDictionary *)userInfo {
	[g_SpringBoard lockAndDimDevice];
}

@end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	
	g_SpringBoard = self;
}

%new
- (void)lockAndDimDevice {
	if ([self respondsToSelector:@selector(_simulateLockButtonPress)]) {
		[self _simulateLockButtonPress];
	} else {
		SBUserAgent *userAgent = [objc_getClass("SBUserAgent") sharedUserAgent];
		if ([userAgent respondsToSelector:@selector(lockAndDimDevice)]) {
			[userAgent lockAndDimDevice];
		}
	}
}

%end

%ctor {
	%init;
	quickLockHelper = [[QuickLockHelper alloc] init];
}
