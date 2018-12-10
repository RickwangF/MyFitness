//
//  BTKQueryServerFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"

/// 查询服务端地理围栏的请求信息类
/**
 查询服务端地理围栏的请求信息，通过此类设置
 */
@interface BTKQueryServerFenceRequest : BTKAPIBaseRequest

/**
 地理围栏监控对象的名称
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 要查询的地理围栏的ID数组，若为nil或空数组则查询所有客户端地理围栏
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 返回信息的坐标类型
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 构造方法，用于构造查询服务端地理围栏的请求对象

 @param monitoredObject 围栏监控的对象的entity_name
 @param fenceIDs 要查询的地理围栏ID列表，若为空，则查询监控对象上的所有地理围栏
 @param outputCoordType 输出坐标类型，只能选择百度经纬度或者国测局经纬度，在国内（包括港、澳、台）以外区域，无论设置何种坐标系，均返回 wgs84坐标
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 查询服务端地理围栏的请求对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs outputCoordType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
