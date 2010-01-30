//
//  BuddyJAppDelegate.m
//  BuddyJ
//
//  Created by Leo Giertz on 100130.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BuddyJAppDelegate.h"
#import "TrackHandler.h"
#import "DJViewController.h"

@implementation BuddyJAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Add the tab bar controller's current view as a subview of the window
    NSLog(@"%d", [[TrackHandler tracks] count]);
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];

}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

@end

