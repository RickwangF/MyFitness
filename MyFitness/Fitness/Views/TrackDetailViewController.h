//
//  TrackDetailViewController.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/11.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportModeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackDetailViewController : UIViewController
	
- (instancetype)initWithStartTime:(NSDate*)start FinishTime:(NSDate*)finish TransportMode:(TransportModeEnum)mode TrackId:(NSString*)objectId;

@end

NS_ASSUME_NONNULL_END
