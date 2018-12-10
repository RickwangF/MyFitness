//
//  BTKQueryServerFenceStatusRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月13日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"

/// 查询服务端地理围栏监控对象的状态的请求信息类
/**
 查询监控对象的最新位置，是在服务端围栏的内部还是外部的请求信息，通过此类设置
 */
@interface BTKQueryServerFenceStatusRequest : BTKAPIBaseRequest

/**
 围栏监控对象的名称，必须指定
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 围栏实体的ID列表。
 设置此属性，则查找指定ID的围栏。
 不设置此属性，则查询监控对象上的所有围栏状态。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 构造方法

 @param monitoredObject 监控对象的名称
 @param fenceIDs 围栏实体的ID列表
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
