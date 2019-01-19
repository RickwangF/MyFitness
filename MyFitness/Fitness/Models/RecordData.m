//
//  RecordData.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/19.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "RecordData.h"
#import "TransportModeEnum.h"
#import "TrackRecord.h"

//@property (nonatomic, copy) NSString *year;
//
//@property (nonatomic, copy) NSString *dateString;
//
//@property (nonatomic, copy) NSString *timeString;
//
//@property (nonatomic, strong) NSDate *startTime;
//
//@property (nonatomic, copy) NSString *info;
//
//@property (nonatomic, copy) NSString *minute;
//
//@property (nonatomic, assign) NSString *kiloMeter;
//
//@property (nonatomic, copy) NSString *pace;
//
//@property (nonatomic, copy) NSString *imageUrl;
//
//@property (nonatomic, assign) double avgSpeed;
//
//@property (nonatomic, assign) double speed;
//
//@property (nonatomic, assign) RecordTypeEnum type;
//
//@property (nonatomic, assign) TransportModeEnum mode;

@implementation RecordData

- (instancetype)initFirstSportWithTrackRecord:(TrackRecord *)trackRecord{
	self = [super init];
	if (self) {
		_info = @"第一次运动";
		_type = RecordTypeEnumFirstSport;
		[self initBaseInfo:trackRecord];
	}
	return self;
}

- (instancetype)initLongestSportWithTrackRecord:(TrackRecord *)trackRecord{
	self = [super init];
	if (self) {
		_info = @"距离最长的运动";
		_type = RecordTypeEnumLongestSport;
		[self initBaseInfo:trackRecord];
	}
	return self;
}

- (instancetype)initFastestSportWithTrackRecord:(TrackRecord*)trackRecord AvgSpeed:(double)avgSpeed{
	self = [super init];
	if (self) {
		_info = @"配速最快的运动";
		_type = RecordTypeEnumFastestPace;
		_avgSpeed = avgSpeed;
		[self initBaseInfo:trackRecord];
	}
	return self;
}

- (instancetype)initLastSportWithTrackRecord:(TrackRecord *)trackRecord{
	self = [super init];
	if (self) {
		_info = @"最近一次运动";
		_type = RecordTypeEnumFirstSport;
		[self initBaseInfo:trackRecord];
	}
	return self;
}

- (void)initBaseInfo:(TrackRecord*)trackRecord{
	_year = [NSString stringWithFormat:@"%ld", (long)trackRecord.year];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components: NSCalendarUnitMonth | NSCalendarUnitDay fromDate:trackRecord.startTime];
	_dateString = [NSString stringWithFormat:@"%ld月%ld日", (long)components.month, (long)components.day];
	_timeString = [self timeStringFromDate:trackRecord.startTime];
	_startTime = trackRecord.startTime;
	_minute = [trackRecord.minuteString substringToIndex:2];
	_kiloMeter = [NSString stringWithFormat:@"%.1f", round(trackRecord.mileage / 1000)];
	_pace = trackRecord.paceString;
	_imageUrl = trackRecord.imageUrl;
	_speed = trackRecord.avgSpeed;
	_mode = trackRecord.transportMode;
	switch (_mode) {
		case TransportModeWalking:
			_modeString = @"健走:";
		break;
		case TransportModeRunning:
			_modeString = @"跑步:";
		break;
		case TransportModeRiding:
			_modeString = @"骑行:";
		break;
		default:
			break;
	}
}

-(NSString*)timeStringFromDate:(NSDate*)date{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm:ss"];
	
	NSString *dateString = [formatter stringFromDate:date];
	return dateString;
}


@end
