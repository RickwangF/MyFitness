//
//  BTKServerDistrictFence.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月09日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKBaseFence.h"

/// 服务端行政区域地理围栏类
/**
 通过此类来实例化一个服务端行政区域地理围栏实体。
 */
@interface BTKServerDistrictFence : BTKBaseFence

/**
 行政区划关键字，必填。
 支持中国国家、省、市、区/县名称。请尽量输入完整的行政区层级和名称，保证名称的唯一性。若输入的行政区名称匹配多个行政区，围栏将创建失败。 
 示例： 中国 北京市 湖南省长沙市 湖南省长沙市雨花区
 
 */
@property (nonatomic, copy) NSString *keyword;

/**
 服务端地理围栏的去燥精度，选填。
 单位：米
 每个轨迹点都有一个定位误差半径radius，这个值越大，代表定位越不准确，可能是噪点。围栏计算时，如果噪点也参与计算，会造成误报的情况。设置denoiseAccuracy可控制，当轨迹点的定位误差半径大于设置值时，就会把该轨迹点当做噪点，不参与围栏计算。
 若不想去燥，则不需要设置此选项。
 */
@property (nonatomic, assign) NSUInteger denoiseAccuracy;

/**
 构造方法

 @param keyword 行政区划关键字
 @param denoiseAccuracy 去噪精度
 @param fenceName 围栏名称
 @param monitoredObject 监控对象名称
 @return 行政区域围栏对象
 */
-(instancetype)initWithKeyword:(NSString *)keyword denoiseAccuracy:(NSUInteger)denoiseAccuracy fenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject;

@end
