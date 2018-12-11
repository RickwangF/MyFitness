//
//  TrackRecord.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "TrackRecord.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation TrackRecord

+(instancetype)trackWithDictionary:(NSDictionary *)obj{
    TrackRecord *trackRecord = [[TrackRecord alloc] init];
    trackRecord.objectId = [obj objectForKey:@"objectId"];
    AVUser *user = [obj objectForKey:@"user"];
    trackRecord.userName = user.username;
    NSDate *startDate = [obj objectForKey:@"startTime"];
    NSDate *finishDate = [obj objectForKey:@"finishedTime"];
    trackRecord.startTime = [TrackRecord stringFromDate: startDate];
    trackRecord.finishedTime = [TrackRecord stringFromDate: finishDate];
    trackRecord.minute = [obj objectForKey:@"minute"];
	trackRecord.interval = [[obj objectForKey:@"interval"] doubleValue];
    trackRecord.locationArray = [[NSMutableArray alloc] init];
    trackRecord.mileage = [[obj objectForKey:@"mileage"] doubleValue];
    trackRecord.avgSpeed = [[obj objectForKey:@"avgSpeed"] doubleValue];
    trackRecord.calorie = [[obj objectForKey:@"calorie"] doubleValue];
    trackRecord.carbonSaving = [[obj objectForKey:@"carbonSaving"] doubleValue];
    trackRecord.transportMode = [[obj objectForKey:@"transportMode"] doubleValue];
    return trackRecord;
}

+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
