//
//  BTKDrivingBehaviourAnalysisRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKQueryTrackProcessOption.h"
#import "BTKDrivingBehaviorThresholdOption.h"

/// 驾驶行为分析的请求信息类
@interface BTKDrivingBehaviourAnalysisRequest : BTKAPIBaseRequest

/**
 需要查询的entity的名称，必填，必须为非空字符串。
 */
@property (nonatomic, copy) NSString *entityName;

/**
 开始时间，必选。
 */
@property (nonatomic, assign) NSUInteger startTime;

/**
 结束时间，必选。
 */
@property (nonatomic, assign) NSUInteger endTime;

/**
 固定限速值，可选。
 若设置为非0值，则以设置的数值为阈值，轨迹点速度超过该值则认为是超速；
 若不设置，或设置为0，则根据百度地图道路限速数据计算超速点。
 */
@property (nonatomic, assign) double speedingThreshold;

/**
 自定义轨迹分析时需要的阈值，可选。
 若为nil，则使用默认的阈值，若设置，则使用指定的各阈值进行轨迹分析。
 */
@property (nonatomic, strong) BTKDrivingBehaviorThresholdOption *thresholdOption;

/**
 纠偏选项，用于控制返回坐标的纠偏处理方式。
 在驾驶行为分析方法中，只有其中的mapMatch和transportMode有效。
 可选。若不设置或为nil，则采用默认值。不绑路、交通方式为驾车。
 */
@property (nonatomic, strong) BTKQueryTrackProcessOption *processOption;

/**
 返回的坐标类型，可选。
 该字段用于控制返回结果中的坐标类型。可选值为：
 BTK_COORDTYPE_GCJ02：国测局加密坐标
 BTK_COORDTYPE_BD09LL：百度经纬度坐标
 该参数仅对国内（包含港、澳、台）轨迹有效，海外区域轨迹均返回 wgs84坐标系
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 构造方法
 
 @param entityName 要查询的entity终端实体的名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param speedingThreshold 固定限速值
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime speedingThreshold:(double)speedingThreshold processOption:(BTKQueryTrackProcessOption *)processOption outputCoordType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag __deprecated;

/**
 构造方法

 @param entityName 要查询的entity终端实体的名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param thresholdOption 阈值选项
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime thresholdOption:(BTKDrivingBehaviorThresholdOption *)thresholdOption processOption:(BTKQueryTrackProcessOption *)processOption outputCoordType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
