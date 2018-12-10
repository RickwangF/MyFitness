//
//  BTKDrivingBehaviorThresholdOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年06月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 轨迹分析时需要的阈值，各阈值均有默认值。
@interface BTKDrivingBehaviorThresholdOption : NSObject

/**
 固定限速值，可选。
 若设置为非0值，则以设置的数值为阈值，轨迹点速度超过该值则认为是超速；
 若不设置，或设置为0，则根据百度地图道路限速数据计算超速点。
 */
@property (nonatomic, assign) double speedingThreshold;

/**
 急加速的水平加速度阈值。
 单位：m^2/s，默认值：1.67，仅支持正数
 */
@property (nonatomic, assign) double harshAccelerationThreshold;

/**
 急减速的水平加速度阈值。
 单位：m^2/s，默认值：-1.67，仅支持负数
 */
@property (nonatomic, assign) double harshBreakingThreshold;

/**
 急转弯的向心加速度阈值。
 单位：m^2/s，默认值：5，仅支持正数
 */
@property (nonatomic, assign) double harshSteeringThreshold;


@end
