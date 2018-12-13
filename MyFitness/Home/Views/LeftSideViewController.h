//
//  LeftSideViewController.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/12.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeftSideViewController : UIViewController

@property (nonatomic, weak) id<SubViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
