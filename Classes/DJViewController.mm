//
//  DJViewController.m
//  BuddyJ
//
//  Created by Leo Giertz on 100130.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DJViewController.h"
#import "BuddyJAppDelegate.h"

class AudioEngine;
@implementation DJViewController

@synthesize pitchView;
@synthesize jogWheelView;

- (IBAction)playPauseBtnClicked:(id)sender {
	if(AudioEngine::instance()->isPlaying) {
		AudioEngine::instance()->stopAudioEngine();
	} else {
		AudioEngine::instance()->startAudioEngine();
	}
	
}
- (IBAction)pitchSliderChanged:(id)sender {
	//audioEngine->setPitch(pitch);
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	audioEngine = AudioEngine::instance(); 
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePitch) name:@"PitchChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeJogWheel) name:@"JogWheelChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeJogWheel) name:@"JogWheelChanged" object:nil];

    [super viewDidLoad];
}

- (void)changePitch {
	CGFloat pointsMoved = [[self pitchView] pointsMoved];
	double currentPitch = audioEngine->pitch;
	if(pointsMoved > 0) {
		if(currentPitch < 1.08) {
			audioEngine->setPitch(currentPitch + 0.001);
			if(audioEngine->pitch < 0) {
				[pitchLabel setText:[NSString stringWithFormat:@"-%1.2f%", 1.0 - audioEngine->pitch]];
			} else {
				[pitchLabel setText:[NSString stringWithFormat:@"+%1.2f%", audioEngine->pitch - 1.0]];
			}
		}
	} else {
		if(currentPitch > 0.92) {
			audioEngine->setPitch(currentPitch - 0.001);
			if(audioEngine->pitch > 0) {
				[pitchLabel setText:[NSString stringWithFormat:@"+%1.2f%", audioEngine->pitch - 1.0]];
			} else {
				[pitchLabel setText:[NSString stringWithFormat:@"-%1.2f%", 1.0 - audioEngine->pitch]];
			}
		}
	}

}
- (void)changeJogWheel {
	NSLog(@"changeJogWheel called");
	audioEngine->setDragging(true);
	CGFloat diff = [[self jogWheelView] pointsMoved];
	audioEngine->pitch = -diff;
	audioEngine->diff = fabs(diff);
	NSLog(@"diff: %f", fabs(diff));
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)showChooseTracks {
    BuddyJAppDelegate* delegate = (BuddyJAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showChooseTracks];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
