//
//  BTKServerCircleFence.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKBaseFence.h"

/// 服务端圆形地理围栏类
/**
 通过此类来实例化一个服务端圆形地理围栏实体。
 */
@interface BTKServerCircleFence : BTKBaseFence

/**
 服务端圆形地理围栏的圆心坐标，必填。
 */
@property (nonatomic, assign) CLLocationCoordinate2D center;

/**
 服务端圆形地理围栏的半径，必填。
 单位：米
 */
@property (nonatomic, assign) double radius;

/**
 服务端圆形地理围栏的圆心的坐标类型，必填。
 */
@property (nonatomic, assign) BTKCoordType coordType;

/**
 服务端地理围栏的去燥精度，选填。
 单位：米
 每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuracy可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。
 若不想去燥，则不需要设置此选项。
 */
@property (nonatomic, assign) NSUInteger denoiseAccuracy;

/**
 构造方法，用于构造服务端圆形地理围栏对象

 @param center 圆心坐标
 @param radius 半径
 @param coordType 圆心的坐标类型
 @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
 @param fenceName 围栏名称
 @param monitoredObject 围栏监控对象的名称
 @return 服务端圆形地理围栏对象
 */
-(instancetype)initWithCenter:(CLLocationCoordinate2D)center radius:(double)radius coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject;

@end
