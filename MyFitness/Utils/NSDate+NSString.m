//
//  NSDate+NSString.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/26.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "NSDate+NSString.h"

@implementation NSDate (NSString)

+(NSDate*)dateFromString:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

@end
