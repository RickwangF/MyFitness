//
//  TrackRecord.h
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackRecord : NSObject

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *finishedTime;

@property (nonatomic, copy) NSString *minute;
	
@property (nonatomic, assign) double interval;

@property (nonatomic, strong) NSMutableArray *locationArray;

@property (nonatomic, assign) double mileage;

@property (nonatomic, assign) double avgSpeed;

@property (nonatomic, assign) double calorie;

@property (nonatomic, assign) double carbonSaving;

@property (nonatomic, assign) int transportMode;

+(instancetype)trackWithDictionary:(NSDictionary*)obj;

@end

NS_ASSUME_NONNULL_END
