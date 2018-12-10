//
//  BTKUpdateLocalFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKLocalCircleFence.h"

/// 更新客户端地理围栏的请求信息类
/**
 更新客户端地理围栏的请求信息类
 */
@interface BTKUpdateLocalFenceRequest : BTKAPIBaseRequest

/**
 要更新的客户端地理围栏的ID
 */
@property (nonatomic, assign) NSUInteger fenceID;

/**
 客户端地理围栏实体，SDK将根据该围栏对象的信息，更新相应的客户端地理围栏。
 本属性应该设置为具体的客户端地理围栏类型。
 由于目前客户端地理围栏只支持圆形围栏，所以这里目前只能是BTKLocalCircleFence类型的对象。
 */
@property (nonatomic, strong) BTKBaseFence *fence;

/**
 构造方法

 @param fenceID 要更新的地理围栏ID
 @param fence 新的地理围栏实体信息
 @param tag 请求标志
 @return 更新客户端地理围栏的请求信息对象
 */
-(instancetype)initWithLocalFenceID:(NSUInteger)fenceID localCircleFence:(BTKLocalCircleFence *)fence tag:(NSUInteger)tag;

@end
