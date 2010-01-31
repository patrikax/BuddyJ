//
//  TouchView.m
//  BuddyJ
//
//  Created by hwaxxer on 2010-01-30.
//  Copyright 2010 KTH. All rights reserved.
//

#import "PitchView.h"


@implementation PitchView

@synthesize upArrow, downArrow;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	startPoint = [touchLocation locationInView:self];
	NSLog(@"startPoint x:%f, y: %f", startPoint.x, startPoint.y);
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	currentPoint = [touchLocation locationInView:self];
	CGPoint moveImagePoint = CGPointMake(self.frame.size.width/2, currentPoint.y);
	pointsMoved = startPoint.y - currentPoint.y;
	if(pointsMoved > 0) {
		moveImagePoint.y += 30.0;
		[downArrow setHidden:YES];
		[upArrow setHidden:NO];
		[upArrow setCenter:moveImagePoint];
	} else {
		moveImagePoint.y -= 30.0;
		[upArrow setHidden:YES];
		[downArrow setHidden:NO];
		[downArrow setCenter:moveImagePoint];
	}
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
	[upArrow setHidden:YES];
	[downArrow setHidden:YES];
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
	frame.size.height = 45.0;
	NSLog(@"offset: y: %f, origin.y: %f", frame.size.height, frame.origin.y);
	upArrow = [[UIImageView alloc] initWithFrame:frame];
	downArrow = [[UIImageView alloc] initWithFrame:frame];
	[upArrow setImage:[UIImage imageNamed:@"upArrow.png"]];
	[downArrow setImage:[UIImage imageNamed:@"downArrow.png"]];
	[self addSubview:upArrow];
	[self addSubview:downArrow];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
