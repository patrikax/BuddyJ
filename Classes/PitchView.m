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
	NSLog(@"startPoint x:%f, y: %f", startPoint.x, startPoint.y);
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	currentPoint = [touchLocation locationInView:self];
	pointsMoved = startPoint.y - currentPoint.y;
	if(abs(pointsMoved) > 10) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PitchChanged" object:nil];
		pointsMoved = 0.0;
	}
	NSLog(@"pointsMoved %f", pointsMoved);

}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	endPoint = [touchLocation locationInView:self];
}
- (CGFloat)pointsMoved {
	return pointsMoved;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
