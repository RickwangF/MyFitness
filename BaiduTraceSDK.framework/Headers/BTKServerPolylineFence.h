//
//  BTKServerPolylineFence.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKBaseFence.h"

/// 服务端线形地理围栏类
/**
 通过此类可以实例化一个服务端线形地理围栏实体。
 */
@interface BTKServerPolylineFence : BTKBaseFence

/**
 服务端线形围栏的形状点的的坐标，必填。
 数组中的每一项为CLLocationCoordinate2D类型的坐标点，代表构成线段的一个形状点。
 坐标点个数在2个到100个之间。
 */
@property (nonatomic, copy) NSArray *vertexes;

/**
 服务端线形围栏的形状点的坐标类型
 */
@property (nonatomic, assign) BTKCoordType coordType;

/**
 服务端线形围栏的报警偏移距离（若偏离折线距离超过该距离即报警），必填。
 单位：米
 */
@property (nonatomic, assign) NSInteger offset;

/**
 服务端地理围栏的去燥精度，选填。
 单位：米
 每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuracy可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。
 若不想去燥，则不需要设置此选项。
 */
@property (nonatomic, assign) NSUInteger denoiseAccuracy;

/**
 构造方法，用于构造服务端线形地理围栏对象

 @param vertexes 构成线段的坐标点数组，数组中每一项为CLLocationCoordinate2D类型
 @param coordType 坐标点的坐标类型
 @param offset 偏离距离 偏移距离（若偏离折线距离超过该距离即报警），单位：米 示例：200
 @param denoiseAccuracy 去燥精度 单位：米。每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuray可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。如果不想去噪，设置为0即可。
 @param fenceName 地理围栏的名称
 @param monitoredObject 监控对象的entity_name
 @return 服务端线形地理围栏对象
 */
-(instancetype)initWithVertexes:(NSArray *)vertexes coordType:(BTKCoordType)coordType offset:(NSInteger)offset denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject;

@end

