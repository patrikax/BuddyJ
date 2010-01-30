//
//  BuddyJAppDelegate.h
//  BuddyJ
//
//  Created by Leo Giertz on 100130.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AudioEngine;

@interface BuddyJAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	AudioEngine *audioEngine;
    UIWindow *window;
    UINavigationController *navigationController;
    UITabBarController *tabBarController;

}

-(void)showChooseTracks;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
