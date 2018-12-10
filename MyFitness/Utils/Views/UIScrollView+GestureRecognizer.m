//
//  UIScrollView+GestureRecognizer.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/12/3.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "UIScrollView+GestureRecognizer.h"

@implementation UIScrollView (GestureRecognizer)

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self isScreenEdgeGesture:gestureRecognizer]) {
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return [self isScreenEdgeGesture:gestureRecognizer];
}

-(BOOL)isScreenEdgeGesture:(UIGestureRecognizer*)gesture{
    
    if (gesture != self.panGestureRecognizer) {
        return false;
    }
    
    BOOL shouldRecognize = NO;
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gesture;
    if (panGesture == nil) {
        return shouldRecognize;
    }
    
    CGPoint location = [panGesture locationInView:nil];
    if(panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStatePossible) {
        CGPoint translation = [panGesture translationInView:nil];
        CGFloat translationY = fabs(translation.y);
        CGFloat velocityX = [panGesture velocityInView:self].x / self.frame.size.width;
        if (location.x < 40 && translation.x > 0 && translationY < 10 && velocityX > 1.0) {
            shouldRecognize = YES;
            return shouldRecognize;
        }
    }
    
    return shouldRecognize;
}


@end
