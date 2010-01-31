//
//  JogWheelView.h
//  BuddyJ
//
//  Created by hwaxxer on 2010-01-30.
//  Copyright 2010 KTH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JogWheelView : UIImageView {
	CGPoint startPoint, currentPoint;
	CGFloat pointsMoved, diff;
}

- (CGFloat)pointsMoved;
- (CGFloat)diff;

@end
