//
//  BTKUpdateServerFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKServerCircleFence.h"
#import "BTKServerPolygonFence.h"
#import "BTKServerPolylineFence.h"
#import "BTKServerDistrictFence.h"

/// 更新服务端地理围栏的请求信息类
/**
 更新服务端地理围栏的请求信息，通过此类设置
 注意：只能更新为相同种类的地理围栏，比如原来fenceID对应的是圆形围栏，则无法更新为多边形围栏。
 */
@interface BTKUpdateServerFenceRequest : BTKAPIBaseRequest

/**
 服务端地理围栏实体，SDK将根据该围栏对象的信息将fenceID对应的服务端地理围栏进行更新。
 本属性应该设置为具体的服务端地理围栏类型，如BTKServerCircleFence, BTKServerPolygonFence, BTKServerPolylineFence, BTKServerDistrictFence 等。
 */
@property (nonatomic, strong) BTKBaseFence *fence;
/**
 要更新的服务端地理围栏的ID
 */
@property (nonatomic, assign) NSUInteger fenceID;

/**
 构造方法，用于构造更新圆形服务端地理围栏的请求对象

 @param fence 新的服务端圆形地理围栏对象
 @param fenceID 要更新的地理围栏ID
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 更新圆形服务端地理围栏的请求对象
 */
-(instancetype)initWithServerCircleFence:(BTKServerCircleFence *)fence fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

/**
 构造方法，用于构造更新多边形服务端地理围栏的请求对象

 @param fence 新的服务端多边形地理围栏对象
 @param fenceID 要更新的地理围栏ID
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 更新多边形服务端地理围栏的请求对象
 */
-(instancetype)initWithServerPolygonFence:(BTKServerPolygonFence *)fence fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

/**
 构造方法，用于构造更新线形服务端地理围栏的请求对象

 @param fence 新的服务端线形地理围栏对象
 @param fenceID 要更新的地理围栏ID
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 更新线形服务端地理围栏的请求对象
 */
-(instancetype)initWithServerPolylineFence:(BTKServerPolylineFence *)fence fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

/**
 构造方法，用于构造更新行政区域服务端地理围栏的请求对象

 @param fence 新的服务端行政区域地理围栏对象
 @param fenceID 要更新的地理围栏ID
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 更新行政区域服务端地理围栏的请求对象
 */
-(instancetype)initWithServerDistrictFence:(BTKServerDistrictFence *)fence fenceID:(NSUInteger)fenceID serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
