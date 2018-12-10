//
//  BTKQueryTrackCacheInfoRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月03日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"

/// 查询客户端缓存的轨迹数据的请求信息类
/**
 查询客户端缓存的轨迹数据的请求信息类
 */
@interface BTKQueryTrackCacheInfoRequest : BTKAPIBaseRequest

/**
 需要查询的缓存数据所属的entity的名称列表，选填。
 若设置，则查询指定entity的缓存数据；
 若不设置或设置为nil或为空数组，则查询所有缓存数据。
 */
@property (nonatomic, copy) NSArray *entityNames;

/**
 构造方法

 @param entityNames entity名称列表
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithEntityNames:(NSArray *)entityNames serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
