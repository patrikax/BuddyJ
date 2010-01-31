//
//  TouchView.m
//  BuddyJ
//
//  Created by hwaxxer on 2010-01-30.
//  Copyright 2010 KTH. All rights reserved.
//

#import "JogWheelView.h"


@implementation JogWheelView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	startPoint = [touchLocation locationInView:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"StartJogWheel" object:nil];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touchLocation = [[event allTouches] anyObject];
	currentPoint = [touchLocation locationInView:self];
	pointsMoved = startPoint.x - currentPoint.x;
	diff = pointsMoved * 0.5;
	pointsMoved = 0;
	startPoint = currentPoint;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"JogWheelChanged" object:nil];

}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//UITouch *touchLocation = [[event allTouches] anyObject];
	//endPoint = [touchLocation locationInView:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"StopJogWheel" object:nil];
}
- (CGFloat)pointsMoved {
	return pointsMoved;
}
- (CGFloat)diff {
	return diff;
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
