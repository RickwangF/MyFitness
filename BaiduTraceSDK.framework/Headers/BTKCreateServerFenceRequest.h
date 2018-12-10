//
//  BTKCreateServerFenceRequest.h
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

/// 创建服务端地理围栏的请求信息类
/**
 创建服务端地理围栏的请求信息，通过此类设置
 本类提供了4个构造方法，分别用于构造4种不同类型的服务端地理围栏的请求
 */
@interface BTKCreateServerFenceRequest : BTKAPIBaseRequest

/**
 服务端地理围栏实体，SDK将根据该围栏对象的信息创建相应的服务端地理围栏。
 本属性应该设置为具体的服务端地理围栏类型，如BTKServerCircleFence, BTKServerPolygonFence, BTKServerPolylineFence等。
 */
@property (nonatomic, strong) BTKBaseFence *fence;

/**
 构造方法，用于构造创建圆形服务端地理围栏的请求对象

 @param fence 新的服务端圆形地理围栏对象
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 创建圆形服务端地理围栏的请求对象
 */
-(instancetype)initWithServerCircleFence:(BTKServerCircleFence *)fence serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;
/**
 构造方法，用于构造创建多边形服务端地理围栏的请求对象

 @param fence 新的服务端多边形地理围栏对象
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 创建多边形服务端地理围栏的请求对象
 */
-(instancetype)initWithServerPolygonFence:(BTKServerPolygonFence *)fence serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;
/**
 构造方法，用于构造创建线形服务端地理围栏的请求对象

 @param fence 新的服务端线形地理围栏对象
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 创建线形服务端地理围栏的请求对象
 */
-(instancetype)initWithServerPolylineFence:(BTKServerPolylineFence *)fence serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

/**
 构造方法，用于构造创建行政区域服务端地理围栏的请求对象

 @param fence 新的服务端行政区域地理围栏对象
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return 创建行政区域服务端地理围栏的请求对象
 */
-(instancetype)initWithServerDistrictFence:(BTKServerDistrictFence *)fence serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
