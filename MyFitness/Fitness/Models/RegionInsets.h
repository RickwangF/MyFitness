//
//  RegionInsets.h
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/12/6.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef RegionInsets_h
#define RegionInsets_h

typedef struct RegionInsets{
    CGFloat minLatitude;
    CGFloat minLongitude;
    CGFloat maxLatitude;
    CGFloat maxLongitude;
}RegionInsets;

RegionInsets RegionInsetsMake(CGFloat minLat, CGFloat minLon, CGFloat maxLat, CGFloat maxLon){
    RegionInsets regionInsets;
    regionInsets.minLatitude = minLat;
    regionInsets.minLongitude = minLon;
    regionInsets.maxLatitude = maxLat;
    regionInsets.maxLongitude = maxLon;
    return regionInsets;
};

#endif /* RegionInsets_h */
