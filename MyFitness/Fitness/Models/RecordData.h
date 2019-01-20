//
//  RecordData.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/19.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportModeEnum.h"

typedef NS_ENUM(NSInteger, RecordTypeEnum) {
	RecordTypeEnumFirstSport = 1, // now
	RecordTypeEnumLongestSport, // now
	RecordTypeEnumLongestWalk,
	RecordTypeEnumLongestRun,
	RecordTypeEnumLongestRide,
	RecordTypeEnumFastestPace, // now
	RecordTypeEnumFastestWalk,
	RecordTypeEnumFastestRun,
	RecordTypeEnumFastestRide,
	RecordTypeEnumDurationSport, // now
	RecordTypeEnumDurationWalk,
	RecordTypeEnumDurationRun,
	RecordTypeEnumDurationRide,
	RecordTypeEnumLastSport, // now
	RecordTypeEnumYearSummary
};

@class TrackRecord;

NS_ASSUME_NONNULL_BEGIN

@interface RecordData : NSObject

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *dateString;

@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *minute;

@property (nonatomic, assign) NSString *kiloMeter;

@property (nonatomic, copy) NSString *pace;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) double avgSpeed;

@property (nonatomic, assign) double speed;

@property (nonatomic, assign) double duration;

@property (nonatomic, assign) double avgDuration;

@property (nonatomic, assign) RecordTypeEnum type;

@property (nonatomic, assign) TransportModeEnum mode;

@property (nonatomic, copy) NSString *modeString;

- (instancetype)initFirstSportWithTrackRecord:(TrackRecord*)trackRecord;

- (instancetype)initLongestSportWithTrackRecord:(TrackRecord*)trackRecord;

- (instancetype)initFastestSportWithTrackRecord:(TrackRecord*)trackRecord AvgSpeed:(double)avgSpeed;

- (instancetype)initLastSportWithTrackRecord:(TrackRecord*)trackRecord;

- (instancetype)initDurationSportWithTrackRecord:(TrackRecord*)trackRecord AvgDuration:(double)avgDuration;

@end

NS_ASSUME_NONNULL_END
