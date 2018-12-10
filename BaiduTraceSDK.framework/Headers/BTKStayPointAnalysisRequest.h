//
//  BTKStayPointAnalysisRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKQueryTrackProcessOption.h"


/// 停留点分析的请求信息类
@interface BTKStayPointAnalysisRequest : BTKAPIBaseRequest

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
 停留时间，可选。
 单位：秒，默认值：600。
 该字段用于设置停留点判断规则，即若系统判断在半径为stay_radius的圆形范围内停留时间超过stay_time，则被认为是一次停留。
 */
@property (nonatomic, assign) NSUInteger stayTime;

/**
 停留半径，可选。
 单位：米，取值范围：[1,500]，默认值：20。
 该字段用于设置停留点判断规则，即若系统判断在半径为stay_radius的圆形范围内停留时间超过stay_time，则被认为是一次停留。
 */
@property (nonatomic, assign) NSUInteger stayRadius;

/**
 纠偏选项，用于控制返回坐标的纠偏处理方式。
 在停留点分析方法中，只有其中的mapMatch和transportMode有效。
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
 @param stayTime 停留时间
 @param stayRadius 停留半径
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime stayTime:(NSUInteger)stayTime stayRadius:(NSUInteger)stayRadius processOption:(BTKQueryTrackProcessOption *)processOption outputCoordType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;
@end
