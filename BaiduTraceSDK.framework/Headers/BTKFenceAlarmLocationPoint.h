//
//  BTKFenceAlarmLocationPoint.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKLocationPoint.h"

/// 地理围栏报警信息中轨迹点信息类
@interface BTKFenceAlarmLocationPoint : BTKLocationPoint

/**
 该轨迹点的定位精度
 */
@property (nonatomic, assign) double radius;
/**
 该轨迹点上传到服务端的时间
 */
@property (nonatomic, assign) UInt64 createTime;

/**
 构造方法

 @param coordinate 坐标
 @param coordType 坐标类型
 @param loctime 定位时间
 @param radius 定位精度
 @param createTime 轨迹点上传到服务端的时间
 @return 围栏报警中的轨迹点对象
 */
-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate coordType:(BTKCoordType)coordType loctime:(UInt64)loctime radius:(double)radius createTime:(UInt64)createTime;

@end
