//
//  NavigationViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/17.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "NavigationViewController.h"
#import "CounterViewController.h"
#import <Hero/Hero-Swift.h>

@interface NavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.interactivePopGestureRecognizer.delegate = self;
	self.isHeroEnabled = YES;
    // Do any additional setup after loading the view.
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	if (self.viewControllers.count <= 1 || [self.viewControllers.lastObject isKindOfClass:CounterViewController.class]) {
		return NO;
	}
	return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
