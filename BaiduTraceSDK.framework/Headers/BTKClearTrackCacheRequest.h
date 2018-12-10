//
//  BTKClearTrackCacheRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月04日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKClearTrackCacheOption.h"

/// 清空客户端缓存的轨迹数据的请求信息类
/**
 清空客户端缓存的轨迹数据的请求信息类
 */
@interface BTKClearTrackCacheRequest : BTKAPIBaseRequest

/**
 需要清空的缓存数据的筛选条件数组，选填。
 数组中每个option用于指定一个筛选条件，类型为BTKClearTrackCacheOption。
 若设置，则清空符合条件的缓存数据；
 若不设置或设置为nil或为空数组，则清空所有的缓存数据。
 */
@property (nonatomic, copy) NSArray *options;

/**
 构造方法

 @param options 筛选条件列表
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithOptions:(NSArray *)options serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
