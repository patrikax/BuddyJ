//
//  TouchView.m
//  BuddyJ
//
//  Created by hwaxxer on 2010-01-30.
//  Copyright 2010 KTH. All rights reserved.
//

#import "PitchView.h"


@implementation PitchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	startPoint = [touchLocation locationInView:self];
	[finger setCenter:startPoint];
	[finger setHidden:NO];
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	currentPoint = [touchLocation locationInView:self];
	pointsMoved = startPoint.y - currentPoint.y;
	[UIView beginAnimations:@"" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[finger setCenter:currentPoint];
	[UIView commitAnimations];
	if(pointsMoved > 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"IncreasePitch" object:nil];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DecreasePitch" object:nil];
	}
	startPoint = currentPoint; 
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	endPoint = [touchLocation locationInView:self];
	[finger setHidden:YES];
}
- (CGFloat)pointsMoved {
	return pointsMoved;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
			
	}
    return self;
}

- (void)awakeFromNib {
	CGRect frame = [self frame];
	frame.size.height = 82.0;
	frame.size.width = 81.0;
	finger = [[UIImageView alloc] initWithFrame:frame];
	[finger setImage:[UIImage imageNamed:@"finger_02.png"]];
	[finger setHidden:YES];
	[self addSubview:finger];
}

- (void)drawRect:(CGRect)rect {
}
#pragma mark -
- (void)dealloc {
    [super dealloc];
}


@end
