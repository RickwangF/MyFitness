//
//  CounterViewController.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportModeEnum.h"
#import "SportParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CounterViewController : UIViewController

- (instancetype)initWithSportParameter:(SportParameter*)param;

@end

NS_ASSUME_NONNULL_END
