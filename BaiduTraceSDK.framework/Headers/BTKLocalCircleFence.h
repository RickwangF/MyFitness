//
//  BTKLocalCircleFence.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKBaseFence.h"

/// 客户端圆形地理围栏类
/**
 客户端圆形地理围栏类
 */
@interface BTKLocalCircleFence : BTKBaseFence

/**
 客户端圆形地理围栏的圆心，必选。
 */
@property (nonatomic, assign) CLLocationCoordinate2D center;

/**
 客户端圆形地理围栏的半径，必选。
 单位：米
 半径的值必须为正整数。
 */
@property (nonatomic, assign) double radius;

/**
 客户端圆形地理围栏的圆心的坐标类型。
 可选，如果不设置，默认为百度经纬度。
 */
@property (nonatomic, assign) BTKCoordType coordType;

/**
 客户端地理围栏的去燥精度。
 每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoise可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。
 可选，如果不设置，该值默认为0，不去噪。
 单位：米。
 精度的值必须为正整数。
 */
@property (nonatomic, assign) NSUInteger denoiseAccuracy;

/**
 构造方法

 @param center 圆形的圆心
 @param radius 圆形的半径
 @param coordType 圆心坐标类型
 @param denoiseAccuracy 去燥精度
 @param fenceName 地理围栏的名称
 @param monitoredObject 地理围栏的监控对象
 @return 客户端地理围栏实体对象
 */
-(instancetype)initWithCenter:(CLLocationCoordinate2D)center radius:(double)radius coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject;
@end
