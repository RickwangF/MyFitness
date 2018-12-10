//
//  BTKAddCustomTrackPointRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月08日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKCustomTrackPoint.h"

/// 上传单个轨迹点的请求类
/**
 上传单个轨迹点的请求类，开发者通过此类设置需要上传的轨迹点的信息
 */
@interface BTKAddCustomTrackPointRequest : BTKAPIBaseRequest

/**
 需要上传的轨迹点
 */
@property (nonatomic, strong) BTKCustomTrackPoint *customTrackPoint;

/**
 构造方法

 @param customTrackPoint 需要上传的轨迹点
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithCustomTrackPoint:(BTKCustomTrackPoint *)customTrackPoint serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
