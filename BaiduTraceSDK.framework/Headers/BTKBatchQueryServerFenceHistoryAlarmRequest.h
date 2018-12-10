//
//  BTKBatchQueryServerFenceHistoryAlarmRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月13日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"

/// 批量查询服务端地理围栏的历史报警信息请求类
/**
 批量查询服务端地理围栏的历史报警信息请求信息，通过此类设置
 */
@interface BTKBatchQueryServerFenceHistoryAlarmRequest : BTKAPIBaseRequest

/**
 开始时间，UNIX时间戳，必须设置
 查询的时间是服务端接收到报警的时间，即报警信息的 create_time。例如，轨迹点实际触发围栏时间为13:00，但若由于各种原因，轨迹点上传至服务端进行围栏计算的时间为14:00，则该报警的 create_time为14:00。
 */
@property (nonatomic, assign) NSUInteger startTime;

/**
 结束时间，UNIX时间戳，必须设置
 结束时间需大于开始时间，但不可超过1小时。即每次请求，最多只能同步1个小时时长的报警信息。
 */
@property (nonatomic, assign) NSUInteger endTime;

/**
 用于控制返回结果的坐标类型，可选
 可选值如下：
 BTK_COORDTYPE_GCJ02：国测局经纬度
 BTK_COORDTYPE_BD09LL：百度经纬度
 注：国外均返回 wgs84 坐标。
 若不设置，则默认返回百度经纬度
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 分页索引，可选。
 默认值为1。page_index与page_size一起计算从第几条结果返回，代表返回第几页。
 */
@property (nonatomic, assign) NSUInteger pageIndex;

/**
 分页大小，可选。
 默认值为500。page_size与page_index一起计算从第几条结果返回，代表返回结果中每页有几条记录。
 */
@property (nonatomic, assign) NSUInteger pageSize;

/**
 构造方法

 @param startTime 开始时间
 @param endTime 结束时间
 @param outputCoordType 返回坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithStartTime:(NSUInteger)startTime endTime:(NSUInteger)endTime outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
