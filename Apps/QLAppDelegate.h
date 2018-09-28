#import <AudioToolbox/AudioToolbox.h>
#import <unistd.h>
#import "RootViewController.h"

@interface QLAppDelegate: UIResponder <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
}
@property (nonatomic, retain) UIWindow *window;

@end