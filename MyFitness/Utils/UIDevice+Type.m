//
//  UIDevice+Type.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "UIDevice+Type.h"
#import <sys/utsname.h>

@implementation UIDevice (Type)
    
-(NSString *)type{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineKey = [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceDic =
    @{
      @"i386"      : @"simulator",
      @"x86_64"    :  @"simulator",
      @"iPod1,1"   :  @"iPod1",
      @"iPod2,1"   :  @"iPod2",
      @"iPod3,1"   :  @"iPod3",
      @"iPod4,1"   :  @"iPod4",
      @"iPod5,1"   :  @"iPod5",
      @"iPad2,1"   :  @"iPad2",
      @"iPad2,2"   :  @"iPad2",
      @"iPad2,3"   :  @"iPad2",
      @"iPad2,4"   :  @"iPad2",
      @"iPad2,5"   :  @"iPadMini1",
      @"iPad2,6"   :  @"iPadMini1",
      @"iPad2,7"   :  @"iPadMini1",
      @"iPhone3,1" :  @"iPhone4",
      @"iPhone3,2" :  @"iPhone4",
      @"iPhone3,3" :  @"iPhone4",
      @"iPhone4,1" :  @"iPhone4S",
      @"iPhone5,1" :  @"iPhone5",
      @"iPhone5,2" :  @"iPhone5",
      @"iPhone5,3" :  @"iPhone5C",
      @"iPhone5,4" :  @"iPhone5C",
      @"iPad3,1"   :  @"iPad3",
      @"iPad3,2"   :  @"iPad3",
      @"iPad3,3"   :  @"iPad3",
      @"iPad3,4"   :  @"iPad4",
      @"iPad3,5"   :  @"iPad4",
      @"iPad3,6"   :  @"iPad4",
      @"iPhone6,1" :  @"iPhone5S",
      @"iPhone6,2" :  @"iPhone5S",
      @"iPad4,2"   :  @"iPadAir1",
      @"iPad5,4"   :  @"iPadAir2",
      @"iPad4,4"   :  @"iPadMini2",
      @"iPad4,5"   :  @"iPadMini2",
      @"iPad4,6"   :  @"iPadMini2",
      @"iPad4,7"   :  @"iPadMini3",
      @"iPad4,8"   :  @"iPadMini3",
      @"iPad4,9"   :  @"iPadMini3",
      @"iPad6,3"   :  @"iPadPro9_7",
      @"iPad6,4"   :  @"iPadPro9_7_cell",
      @"iPad6,12"  :  @"iPad5",
      @"iPad6,7"   :  @"iPadPro12_9",
      @"iPad6,8"   :  @"iPadPro12_9_cell",
      @"iPad7,1"   :  @"iPadPro2_12_9",
      @"iPad7,2"   :  @"iPadPro2_12_9_cell",
      @"iPhone7,1" :  @"iPhone6Plus",
      @"iPhone7,2" :  @"iPhone6",
      @"iPhone8,1" :  @"iPhone6S",
      @"iPhone8,2" :  @"iPhone6SPlus",
      @"iPhone8,4" :  @"iPhoneSE",
      @"iPhone9,1" :  @"iPhone7",
      @"iPhone9,2" :  @"iPhone7Plus",
      @"iPhone9,3" :  @" iPhone7",
      @"iPhone9,4" :  @" iPhone7Plus",
      @"iPhone10,1" : @" iPhone8",
      @"iPhone10,2" : @" iPhone8Plus",
      @"iPhone10,3" : @" iPhoneX",
      @"iPhone10,4" : @" iPhone8",
      @"iPhone10,5" : @" iPhone8Plus",
      @"iPhone10,6" : @" iPhoneX",
      @"iPhone11,2": @"iPhoneXS",
      @"iPhone11,4": @"iPhoneXSMax",
      @"iPhone11,6": @"iPhoneXSMax",
      @"iPhone11,8": @"iPhoneXR"
    };
    
    NSMutableString *deviceName = [deviceDic[machineKey] mutableCopy];
    
    if ([deviceName isEqualToString: @"simulator"]) {
        NSString * simulatorKey = [[NSProcessInfo alloc] init].environment[@"SIMULATOR_MODEL_IDENTIFIER"];
        
        if (simulatorKey != nil && ![simulatorKey isEqual: @""]) {
            deviceName = deviceDic[simulatorKey];
        }
    }
    
    return deviceName;
}
    
-(BOOL)fullScreen{
    
    BOOL fullScreen = NO;
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineKey = [NSString stringWithCString:systemInfo.machine
                                              encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceDic =
    @{
      @"i386"      : @"simulator",
      @"x86_64"    :  @"simulator",
      @"iPhone10,3" : @" iPhoneX",
      @"iPhone10,6" : @" iPhoneX",
      @"iPhone11,2": @"iPhoneXS",
      @"iPhone11,4": @"iPhoneXSMax",
      @"iPhone11,6": @"iPhoneXSMax",
      @"iPhone11,8": @"iPhoneXR"
      };
    
    NSString *deviceName = deviceDic[machineKey];
    if (deviceName != nil && ![deviceName isEqualToString:@""]) {
        if ([deviceName isEqualToString: @"simulator"]) {
            NSString * simulatorKey = [[NSProcessInfo alloc] init].environment[@"SIMULATOR_MODEL_IDENTIFIER"];
            
            NSString *simulatorName = deviceDic[simulatorKey];
            
            if (simulatorName != nil && ![simulatorName isEqual: @""]) {
                fullScreen = YES;
            }
        }
        else{
            fullScreen = YES;
        }
    }
    
    return fullScreen;
}

@end
