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
#import "AudioEngine.h"

@implementation BuddyJAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Add the tab bar controller's current view as a subview of the window
    NSLog(@"%d", [[TrackHandler tracks] count]);
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	audioEngine = AudioEngine::instance(); 

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

-(void)showChooseTracks {
    //tabBarController = [[ChooseTrackTabBarController alloc] initWithNibName:@"ChooseTrackTabBarController" bundle:nil];
    //NSLog(@"ViewControllers: %d", [[tabBarController viewControllers] count]);
    [navigationController pushViewController:tabBarController animated:YES];
}

- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}

@end

