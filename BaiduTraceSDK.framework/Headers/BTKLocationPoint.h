//
//  BTKLocationPoint.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BTKTypes.h"

/// 轨迹点的基类
/**
 轨迹点的基类
 */
@interface BTKLocationPoint : NSObject

/**
 轨迹点的坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 轨迹点的坐标类型
 */
@property (nonatomic, assign) BTKCoordType coordType;

/**
 轨迹点的定位时间
 */
@property (nonatomic, assign) UInt64 loctime;

/**
 构造方法

 @param coordinate 坐标
 @param coordType 坐标类型
 @param loctime 定位时间
 @return 轨迹点对象
 */
-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate coordType:(BTKCoordType)coordType loctime:(UInt64)loctime;

@end
