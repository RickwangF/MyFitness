//
//  CounterViewController.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportModeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CounterViewController : UIViewController
	
-(instancetype)initWithTransportMode:(TransportModeEnum)mode Mute:(BOOL)mute;

@end

NS_ASSUME_NONNULL_END
