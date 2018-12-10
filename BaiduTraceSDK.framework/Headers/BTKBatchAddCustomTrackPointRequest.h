//
//  BTKBatchAddCustomTrackPointRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月08日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"

/// 批量上传多个开发者自定义的轨迹点的请求类
/**
 批量上传多个开发者自定义的轨迹点的请求类，开发者通过此类设置需要批量上传的轨迹点的信息
 */
@interface BTKBatchAddCustomTrackPointRequest : BTKAPIBaseRequest

/**
 需要批量上传的轨迹点数组，数组中每一项为BTKCustomTrackPoint类型。
 */
@property (nonatomic, copy) NSArray *customTrackPoints;

/**
 构造方法

 @param customTrackPoints 需要批量上传的轨迹点数组
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithCustomTrackPoints:(NSArray *)customTrackPoints serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
