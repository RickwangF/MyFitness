//
//  BTKQueryServerFenceHistoryAlarmRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月13日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"

/// 查询指定监控对象的服务端围栏报警信息的请求信息类
/**
 查询指定的监控对象，在指定时间段内，触发服务端地理围栏的报警信息历史的请求信息，通过此类设置
 */
@interface BTKQueryServerFenceHistoryAlarmRequest : BTKAPIBaseRequest

/**
 服务端地理围栏监控对象的名称，必须指定
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 服务端地理围栏实体的ID列表。
 若设置此属性，则查找监控对象触发指定的围栏的历史报警。
 若不设置此属性，则查询监控对象上的所有服务端地理围栏的历史报警。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 时间段起点，UNIX时间戳。
 若值 > 0，则返回该时间戳之后的服务端地理围栏报警信息。
 若值 = 0，则返回7天内所有报警信息。
 */
@property (nonatomic, assign) NSUInteger startTime;

/**
 时间段终点，UNIX时间戳。
 若值 > 0，则返回该时间戳之前的服务端地理围栏报警信息。
 若值 = 0，则返回7天内所有报警信息。
 endTime的值必须比startTime的值大。
 */
@property (nonatomic, assign) NSUInteger endTime;

/**
 用于控制返回结果的坐标类型
 可选值如下：
 BTK_COORDTYPE_GCJ02：国测局经纬度
 BTK_COORDTYPE_BD09LL：百度经纬度
 注：国外均返回 wgs84 坐标。
 若不设置，则默认返回百度经纬度
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 构造方法

 @param monitoredObject 被监控对象的名称
 @param fenceIDs 地理围栏实体的ID列表
 @param startTime 时间段起点
 @param endTime 时间段终点
 @param outputCoordType 返回坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime outputCoordType:(BTKCoordType)outputCoordType ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
