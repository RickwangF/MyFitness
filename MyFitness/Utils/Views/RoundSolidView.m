//
//  RoundSolidView.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/15.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "RoundSolidView.h"
#import "AppStyleSetting.h"

@implementation RoundSolidView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
	[AppStyleSetting.sharedInstance.mainColor setFill];
	[path fill];
}


@end
