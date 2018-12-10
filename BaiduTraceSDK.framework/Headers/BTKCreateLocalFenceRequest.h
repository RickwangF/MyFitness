//
//  BTKCreateLocalFenceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKLocalCircleFence.h"

/// 创建客户端地理围栏的请求信息类
/**
 创建客户端地理围栏的请求信息类
 */
@interface BTKCreateLocalFenceRequest : BTKAPIBaseRequest

/**
 客户端地理围栏实体，SDK将根据该围栏对象的信息创建相应的客户端地理围栏。
 本属性应该设置为具体的客户端地理围栏类型。
 由于目前客户端地理围栏只支持圆形围栏，所以这里目前只能是BTKLocalCircleFence类型的对象。
 */
@property (nonatomic, strong) BTKBaseFence *fence;

/**
 构造方法

 @param fence 新的客户端地理围栏实体
 @param tag 请求标志
 @return 创建客户端地理围栏的请求信息对象
 */
-(instancetype)initWithLocalCircleFence:(BTKLocalCircleFence *)fence tag:(NSUInteger)tag;

@end
