//
//  DJViewController.h
//  BuddyJ
//
//  Created by Leo Giertz on 100130.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PitchView.h"
#import "JogWheelView.h"

#include "AudioEngine.h"

@interface DJViewController : UIViewController {
	IBOutlet UIButton *playPauseBtn, *cueBtn, *rewindBtn;
	AudioEngine *audioEngine;
	IBOutlet UISlider *pitchSlider, *jogWheel;
	CGFloat newSpeed, currentSpeed;
	IBOutlet PitchView *pitchView;
	IBOutlet JogWheelView *jogWheelView;
	IBOutlet UILabel *pitchLabel, *timeLeftLabel;

}

@property (nonatomic, retain) IBOutlet PitchView *pitchView;
@property (nonatomic, retain) IBOutlet JogWheelView *jogWheelView;
- (IBAction)playPauseBtnClicked:(id)sender;
- (IBAction)showChooseTracks;
- (IBAction)cueBtnClicked:(id)sender;
- (IBAction)rewindBtnClicked:(id)sender;
- (void)updatePitchLabel;
@end
