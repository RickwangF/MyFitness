//
//  ShadowCircleButton.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/12.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "ShadowCircleButton.h"

@implementation ShadowCircleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.layer.cornerRadius = frame.size.width / 2;
		self.layer.masksToBounds = NO;
	}
	return self;
}

- (void)setShadow{
	self.layer.shadowColor = self.backgroundColor.CGColor;
	self.layer.shadowOffset = CGSizeMake(0, 5);
	self.layer.shadowOpacity = 0.8;
	self.layer.shadowRadius = 8;
}

@end
