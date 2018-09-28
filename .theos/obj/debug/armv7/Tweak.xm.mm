#line 1 "Tweak.xm"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <objc/runtime.h>
#import <SpringBoard/SpringBoard.h>
#import <rocketbootstrap/rocketbootstrap.h>

@interface SBUserAgent : NSObject
+ (id)sharedUserAgent;

- (void)lockAndDimDevice;
@end

@interface SpringBoard (NEW)
- (void)lockAndDimDevice;

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
		center = [CPDistributedMessagingCenter centerNamed:@"me.devbug.quicklockhelper.center"];
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$lockAndDimDevice(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); 

#line 52 "Tweak.xm"


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
	_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
	
	g_SpringBoard = self;
}


static void _logos_method$_ungrouped$SpringBoard$lockAndDimDevice(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSLog(@"[QuickLock] lockAndDimDevice");
	if ([self respondsToSelector:@selector(_simulateLockButtonPress)]) {
		[self _simulateLockButtonPress];
	} else {
		SBUserAgent *userAgent = [objc_getClass("SBUserAgent") sharedUserAgent];
		if ([userAgent respondsToSelector:@selector(lockAndDimDevice)]) {
			[userAgent lockAndDimDevice];
		}
	}
}



static __attribute__((constructor)) void _logosLocalCtor_0271b2a0(int __unused argc, char __unused **argv, char __unused **envp) {
	{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(lockAndDimDevice), (IMP)&_logos_method$_ungrouped$SpringBoard$lockAndDimDevice, _typeEncoding); }}
	quickLockHelper = [[QuickLockHelper alloc] init];
}
