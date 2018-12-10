//
//  BTKQueryLocalFenceHistoryAlarmRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月20日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"

/// 查询指定监控对象的客户端围栏报警信息的请求信息类
/**
 查询指定的监控对象，在指定时间段内，触发客户端地理围栏的报警信息历史的请求信息，通过此类设置。
 客户端地理围栏历史报警信息，最多保留7天，超出该范围内的历史报警信息无法查询。
 */
@interface BTKQueryLocalFenceHistoryAlarmRequest : BTKAPIBaseRequest

/**
 围栏监控对象的名称，必须为非空的字符串。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 客户端地理围栏实体的ID列表。
 若设置此属性，则查找监控对象触发指定的围栏的历史报警。
 若不设置此属性，则查询监控对象上的所有客户端地理围栏的历史报警。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 时间段起点，UNIX时间戳。
 可选。
 注意：由于客户端地理围栏历史报警信息，最多保留7天。要求startTime必须在[now-7天, now]这个时间段之内。
 若指定了startTime，未指定endTime，则返回startTime时间戳以后的，符合其他查询条件的客户端地理围栏历史报警信息。
 若未指定startTime，但指定了endTime，则返回endTime时间戳以前7天之内的，符合其他查询条件的客户端地理围栏历史报警信息。
 若同时指定了starTime与endTime,则返回该时间段之内的，符合其他查询条件的客户端地理围栏历史报警信息。
 若startTime和endTime都没有设置，则返回当前时间为止7天之内，符合其他查询条件的所有客户端地理围栏历史报警信息。
 */
@property (nonatomic, assign) NSUInteger startTime;

/**
 时间段终点，UNIX时间戳。
 可选。
 时间段终点endTime的值必须大于时间段起点starTime的值。
 注意：由于客户端地理围栏历史报警信息，最多保留7天。要求endTime必须在[now-7天, now]这个时间段之内。
 若指定了startTime，未指定endTime，则返回startTime时间戳以后的，符合其他查询条件的客户端地理围栏历史报警信息。
 若未指定startTime，但指定了endTime，则返回endTime时间戳以前7天之内的，符合其他查询条件的客户端地理围栏历史报警信息。
 若同时指定了starTime与endTime,则返回该时间段之内的，符合其他查询条件的客户端地理围栏历史报警信息。
 若startTime和endTime都没有设置，则默认返回当前时间为止7天之内，符合其他查询条件的所有客户端地理围栏历史报警信息。
 */
@property (nonatomic, assign) NSUInteger endTime;

/**
 构造方法
 注意：由于客户端地理围栏历史报警信息，最多保留7天。
 要求startTime和endTime必须在[now-7天, now]这个时间段之内。
 其他要求请参考startTime和endTime各自的注释。
 
 @param monitoredObject 被监控对象的名称
 @param fenceIDs 地理围栏实体的ID列表
 @param startTime 时间段起点
 @param endTime 时间段终点
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime tag:(NSUInteger)tag;

@end
