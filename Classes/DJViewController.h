//
//  DJViewController.h
//  BuddyJ
//
//  Created by Leo Giertz on 100130.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DJViewController : UIViewController {
	IBOutlet UIButton *playPauseBtn;
}

- (IBAction)playPauseBtnClicked:(id)sender;
@end
