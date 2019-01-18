//
//  SolidRoundView.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/18.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "RoundIndicatorView.h"

@implementation RoundIndicatorView

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	}
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
	UIBezierPath *roundPath = [UIBezierPath bezierPathWithOvalInRect:bounds];
	[UIColor.whiteColor setFill];
	[roundPath fill];
	
	UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.5, 0.5, bounds.size.width - 1, bounds.size.height - 1)];
	[borderPath setLineWidth:1.0];
	[[UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1.0] setStroke];
	[borderPath stroke];
}


@end
