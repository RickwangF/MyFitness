//
//  BTKDeleteServerFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"

/// 删除服务端地理围栏的请求信息类
/**
 删除服务端地理围栏的请求信息，通过此类设置
 */
@interface BTKDeleteServerFenceRequest : BTKAPIBaseRequest

/**
 要删除的地理围栏所监控的对象
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 要删除的地理围栏的ID数组，若为nil或空数组则删除监控对象上的所有地理围栏
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 构造方法，用于构造删除服务端地理围栏的请求对象

 @param monitoredObject 围栏的监控对象
 @param fenceIDs 围栏ID的数组，若为空，则删除监控对象上的所有地理围栏
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 删除服务端地理围栏的请求对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
