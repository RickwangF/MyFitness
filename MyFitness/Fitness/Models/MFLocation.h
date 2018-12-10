//
//  MFLocation.h
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFLocation : NSObject

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *trackId;

@property (nonatomic, assign) double latitute;

@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) double altitude;

@property (nonatomic, assign) double course;

@property (nonatomic, assign) double speed;

@property (nonatomic, copy) NSString *timestamp;

+(instancetype) locationWithDictionary:(NSDictionary*)obj;

@end

NS_ASSUME_NONNULL_END
