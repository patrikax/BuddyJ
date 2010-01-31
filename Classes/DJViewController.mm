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
	[playPauseBtn setSelected:![playPauseBtn isSelected]];
	if(AudioEngine::instance()->isPlaying) {
		AudioEngine::instance()->stopAudioEngine();
	} else {
		AudioEngine::instance()->startAudioEngine();
	}
	
}
- (IBAction)cueBtnClicked:(id)sender {
	// PLAYING
	if([playPauseBtn isSelected]) {
		[playPauseBtn setSelected:NO];
	}
	NSLog(@"cue pos %f ", audioEngine->cue);
	if(audioEngine->isPlaying) {
		audioEngine->go2cue();
		audioEngine->stopAudioEngine();
	} else {
		audioEngine->setCue();
	}
}
- (IBAction)rewindBtnClicked:(id)sender {
	audioEngine->rewind();
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(increasePitch) name:@"IncreasePitch" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decreasePitch) name:@"DecreasePitch" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeJogWheel) name:@"JogWheelChanged" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopJogWheel) name:@"StopJogWheel" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startJogWheel) name:@"StartJogWheel" object:nil];


    [super viewDidLoad];
}

- (void)increasePitch {
	double currentPitch = audioEngine->pitch;
	if(currentPitch < 1.08 || audioEngine->pitching) {
		audioEngine->setPitch(currentPitch + 0.001);
	}
	[self updatePitchLabel];
}
- (void)decreasePitch {
	double currentPitch = audioEngine->pitch;
	if(currentPitch > 0.92 || audioEngine->pitching) {
		audioEngine->setPitch(currentPitch - 0.001);
	}
	[self updatePitchLabel];
}
- (void)updatePitchLabel {
	double pitch = audioEngine->pitch;
	if(pitch > 1.0) {
		[pitchLabel setText:[NSString stringWithFormat:@"+%1.2f\%", audioEngine->pitch - 1.0]];
	} else if(pitch < 1.0) {
		[pitchLabel setText:[NSString stringWithFormat:@"-%1.2f\%", 1.0 - audioEngine->pitch]];
	} else if(pitch == 1.0) {
		[pitchLabel setText:[NSString stringWithFormat:@"0.00%"]];
	}
}

- (void)startJogWheel {
	audioEngine->previousPitch = audioEngine->pitch;
}
- (void)changeJogWheel {
	CGFloat diff = [[self jogWheelView] diff];
	audioEngine->setDragging(true);

	// JUST PITCH IT
	if(audioEngine->isPlaying) {
		audioEngine->pitching = true;
		if(diff < 0) {
			[self increasePitch];
		} else {
			[self decreasePitch];
		}
	} else { // SCRATCH IT BABY
		//diff *= 0.5;
		audioEngine->step = -diff;
		audioEngine->diff = fabs(diff);
	}
}
- (void)stopJogWheel {
	audioEngine->setDragging(false);
	if(audioEngine->isPlaying) {
		audioEngine->pitching = false;
		audioEngine->pitch = audioEngine->previousPitch;
	} else { // WASN'T RUNNING BEFORE
		audioEngine->step = 0;
		audioEngine->pitch = audioEngine->previousPitch;
		audioEngine->diff = 0;
	}
	[self updatePitchLabel];
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
