//
//  TrackRecord.h
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportModeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackRecord : NSObject

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *userName;
	
@property (nonatomic, strong) NSDate *startTime;
	
@property (nonatomic, strong) NSDate *finishedTime;

@property (nonatomic, copy) NSString *startTimeString;

@property (nonatomic, copy) NSString *finishedTimeString;

@property (nonatomic, copy) NSString *minute;
	
@property (nonatomic, assign) double interval;

@property (nonatomic, strong) NSMutableArray *locationArray;

@property (nonatomic, assign) double mileage;

@property (nonatomic, assign) double avgSpeed;

@property (nonatomic, assign) double paceSpeed;

@property (nonatomic, assign) double calorie;

@property (nonatomic, assign) double carbonSaving;

@property (nonatomic, assign) TransportModeEnum transportMode;

+(instancetype)trackWithDictionary:(NSDictionary*)obj;

@end

NS_ASSUME_NONNULL_END
