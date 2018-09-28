#import "QLAppDelegate.h"
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@implementation QLAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];
	[_window addSubview:_viewController.view];
	[_window makeKeyAndVisible];
	
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.apple.springboard.plist"];
	
	if ((dict[@"lock-unlock"] == nil || [dict[@"lock-unlock"] boolValue]) && kCFCoreFoundationVersionNumber >= 847.20) {
		// play lock sound
		AudioServicesPlaySystemSound(1100);
	}
	
	CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"com.subdiox.quicklockhelper.center"];
	rocketbootstrap_distributedmessagingcenter_apply(center);
	[center sendMessageName:@"SHOULDLOCKDEVICE" userInfo:nil];

	[self performSelector:@selector(exitApplication) withObject:nil afterDelay:1.0f];
}

- (void)exitApplication {
	int pid = getpid();
	kill(pid, SIGKILL);
}

@end

// vim:ft=objc
