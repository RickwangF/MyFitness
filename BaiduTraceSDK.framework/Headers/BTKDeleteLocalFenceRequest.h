//
//  BTKDeleteLocalFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"

/// 删除客户端地理围栏的请求信息类
/**
 删除客户端地理围栏的请求信息类。
 fenceIDs与monitoredObject共同决定了将被删除的客户端地理围栏实体，规则如下：
 若fenceIDs与monitoredObject同时设置，会删除指定的ID列表中，被监控对象为monitoredObject的客户端地理围栏；
 若设置了fenceIDs，但是没有设置monitoredObject，则会删除指定的ID列表对应的客户端地理围栏；
 若设置了monitoredObject，但是没有设置fenceIDs，则会删除所有被监控对象为monitoredObject的客户端地理围栏；
 若fenceIDs与monitoredObject都没有设置，则会删除所有的客户端地理围栏。
 */
@interface BTKDeleteLocalFenceRequest : BTKAPIBaseRequest

/**
 要删除的地理围栏所监控的对象
 可选。
 fenceIDs与monitoredObject共同决定了将被删除的客户端地理围栏实体，规则如下：
 若fenceIDs与monitoredObject同时设置，会删除指定的ID列表中，被监控对象为monitoredObject的客户端地理围栏；
 若设置了fenceIDs，但是没有设置monitoredObject，则会删除指定的ID列表对应的客户端地理围栏；
 若设置了monitoredObject，但是没有设置fenceIDs，则会删除所有被监控对象为monitoredObject的客户端地理围栏；
 若fenceIDs与monitoredObject都没有设置，则会删除所有的客户端地理围栏。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 要删除的地理围栏的ID数组。
 可选。
 fenceIDs与monitoredObject共同决定了将被删除的客户端地理围栏实体，规则如下：
 若fenceIDs与monitoredObject同时设置，会删除指定的ID列表中，被监控对象为monitoredObject的客户端地理围栏；
 若设置了fenceIDs，但是没有设置monitoredObject，则会删除指定的ID列表对应的客户端地理围栏；
 若设置了monitoredObject，但是没有设置fenceIDs，则会删除所有被监控对象为monitoredObject的客户端地理围栏；
 若fenceIDs与monitoredObject都没有设置，则会删除所有的客户端地理围栏。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 构造方法

 @param monitoredObject 被监控对象
 @param fenceIDs 要删除的地理围栏的ID数组
 @param tag 请求标志
 @return 删除客户端地理围栏的请求信息对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs tag:(NSUInteger)tag;

@end
