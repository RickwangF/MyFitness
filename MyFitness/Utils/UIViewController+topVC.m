//
//  UIViewController+topVC.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "UIViewController+topVC.h"

@implementation UIViewController (topVC)
    
-(UIViewController *)topVC{
    if ([self isKindOfClass:UINavigationController.class]) {
        UINavigationController *naviSelf = (UINavigationController*)self;
        
        return naviSelf.visibleViewController.topVC == nil ? naviSelf : naviSelf.visibleViewController.topVC;
    }
    else if ([self isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabSelf = (UITabBarController*)self;
        return tabSelf.selectedViewController.topVC == nil ? tabSelf : tabSelf.selectedViewController.topVC;
    }
    else {
        return self.presentedViewController.topVC == nil ? self : self.presentedViewController.topVC;
    }
}

@end
