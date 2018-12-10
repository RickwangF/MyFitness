//
//  BTKQueryLocalFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"

/// 查询客户端地理围栏实体的请求信息类
/**
 查询客户端地理围栏实体的请求信息类
 fenceIDs与monitoredObject共同决定了客户端地理围栏实体的查询条件，规则如下：
 若fenceIDs与monitoredObject同时设置，会返回指定的ID列表中，被监控对象为monitoredObject的客户端地理围栏；
 若设置了fenceIDs，但是没有设置monitoredObject，则会返回指定的ID列表对应的客户端地理围栏；
 若设置了monitoredObject，但是没有设置fenceIDs，则会返回所有被监控对象为monitoredObject的客户端地理围栏；
 若fenceIDs与monitoredObject都没有设置，则会返回所有的客户端地理围栏。
 */
@interface BTKQueryLocalFenceRequest : BTKAPIBaseRequest

/**
 要查询的客户端地理围栏监控对象的名称。
 可选。
 fenceIDs与monitoredObject共同决定了客户端地理围栏实体的查询条件，规则如下：
 若fenceIDs与monitoredObject同时设置，会返回指定的ID列表中，被监控对象为monitoredObject的客户端地理围栏；
 若设置了fenceIDs，但是没有设置monitoredObject，则会返回指定的ID列表对应的客户端地理围栏；
 若设置了monitoredObject，但是没有设置fenceIDs，则会返回所有被监控对象为monitoredObject的客户端地理围栏；
 若fenceIDs与monitoredObject都没有设置，则会返回所有的客户端地理围栏。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 要查询的地理围栏的ID数组。
 可选。
 fenceIDs与monitoredObject共同决定了客户端地理围栏实体的查询条件，规则如下：
 若fenceIDs与monitoredObject同时设置，会返回指定的ID列表中，被监控对象为monitoredObject的客户端地理围栏；
 若设置了fenceIDs，但是没有设置monitoredObject，则会返回指定的ID列表对应的客户端地理围栏；
 若设置了monitoredObject，但是没有设置fenceIDs，则会返回所有被监控对象为monitoredObject的客户端地理围栏；
 若fenceIDs与monitoredObject都没有设置，则会返回所有的客户端地理围栏。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 构造方法

 @param monitoredObject 监控对象的名称
 @param fenceIDs 地理围栏ID数组
 @param tag 请求标志
 @return 查询客户端地理围栏实体的请求信息对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs tag:(NSUInteger)tag;

@end
