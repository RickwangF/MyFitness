//
//  TopDismissScrollView.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/17.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "TopDismissScrollView.h"

@implementation TopDismissScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	
	if (!self.isUserInteractionEnabled || self.isHidden || self.alpha < 0.01) {
		return nil;
	}
	
	if (![self pointInside:point withEvent:event]) {
		return nil;
	}
	
	if (self.contentOffset.y <= 0 && point.y < 400) {
		return nil;
	}
	
	return self;
}

@end
