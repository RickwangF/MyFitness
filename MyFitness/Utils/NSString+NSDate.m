//
//  NSString+NSDate.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "NSString+NSDate.h"

@implementation NSString (NSDate)

+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
