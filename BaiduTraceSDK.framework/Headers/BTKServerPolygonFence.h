//
//  BTKServerPolygonFence.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKBaseFence.h"

/// 服务端的多边形地理围栏类
/**
 通过此类可以实例化一个服务端的多边形地理围栏实体。
 */
@interface BTKServerPolygonFence : BTKBaseFence

/**
 服务端多边形地理围栏的顶点坐标，必填。
 数组中的每一项为CLLocationCoordinate2D类型的坐标点，代表多边形的一个顶点。
 */
@property (nonatomic, copy) NSArray *vertexes;

/**
 服务端多边形地理围栏的顶点坐标的坐标类型，必填。
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
 构造方法，用于构造服务端多边形地理围栏对象

 @param vertexes 多边形的顶点坐标数组，数组中每一项为 CLLocationCoordinate2D类型
 @param coordType 顶点坐标的坐标类型
 @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
 @param fenceName 地理围栏的名称
 @param monitoredObject 地理围栏监控对象的名称
 @return 服务端多边形地理围栏对象
 */
-(instancetype)initWithVertexes:(NSArray *)vertexes coordType:(BTKCoordType)coordType denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject;
@end
