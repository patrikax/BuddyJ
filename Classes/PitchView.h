//
//  TouchView.h
//  BuddyJ
//
//  Created by hwaxxer on 2010-01-30.
//  Copyright 2010 KTH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PitchView : UIImageView {
	CGPoint startPoint, endPoint, currentPoint;
	CGFloat pointsMoved;
	UIImageView *upArrow, *downArrow;
}
@property (nonatomic, retain) UIImageView *upArrow;
@property (nonatomic, retain) UIImageView *downArrow;
- (CGFloat)pointsMoved;
@end
