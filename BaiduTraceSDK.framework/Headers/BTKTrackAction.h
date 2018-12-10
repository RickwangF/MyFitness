//
//  BTKTrackAction.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月11日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKQueryTrackLatestPointRequest.h"
#import "BTKQueryTrackDistanceRequest.h"
#import "BTKQueryHistoryTrackRequest.h"
#import "BTKQueryTrackCacheInfoRequest.h"
#import "BTKClearTrackCacheRequest.h"
#import "BTKAddCustomTrackPointRequest.h"
#import "BTKBatchAddCustomTrackPointRequest.h"
#import "BTKTrackDelegate.h"

/// 轨迹纠偏与里程计算操作类
/**
 轨迹纠偏与里程计算
 */
@interface BTKTrackAction : NSObject

/**
 轨迹相关操作的全局访问点

 @return 单例对象
 */
+(BTKTrackAction *)sharedInstance;


/**
 上传某个开发者自定义的轨迹点
 除了SDK自动的轨迹采集上传外，开发者可以通过此方法上传自定义的轨迹点。
 比如在两个采集周期之间，上传某个轨迹点作为补充。或者上传非当前登陆的entity的其他终端的轨迹点等。

 @param request 请求对象
 @param delegate 操作结果的回调对象
 */
-(void)addCustomPointWith:(BTKAddCustomTrackPointRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

/**
 批量上传若干个开发者自定义的轨迹点
 除了SDK自动的轨迹采集上传外，开发者可以通过此方法批量上传自定义的轨迹点。
 这些轨迹点可以属于不同的终端实体。

 @param request 请求对象
 @param delegate 操作结果的回调对象
 */
-(void)batchAddCustomPointWith:(BTKBatchAddCustomTrackPointRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

/**
 查询某终端实体的实时位置

 @param request 查询请求对象
 @param delegate 操作结果的回调对象
 */
-(void)queryTrackLatestPointWith:(BTKQueryTrackLatestPointRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

/**
 查询某终端实体在一段时间内的里程

 @param request 查询请求对象
 @param delegate 操作结果的回调对象
 */
-(void)queryTrackDistanceWith:(BTKQueryTrackDistanceRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

/**
 查询某终端实体在一段时间内的轨迹

 @param request 查询请求对象
 @param delegate 操作结果的回调对象
 */
-(void)queryHistoryTrackWith:(BTKQueryHistoryTrackRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

/**
 查询客户端缓存的轨迹信息

 @param request 查询请求对象
 @param delegate 操作结果的回调对象
 */
-(void)queryTrackCacheInfoWith:(BTKQueryTrackCacheInfoRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

/**
 清空客户端缓存的轨迹信息

 @param request 清除操作的请求对象
 @param delegate 操作结果的回调对象
 */
-(void)clearTrackCacheWith:(BTKClearTrackCacheRequest *)request delegate:(id<BTKTrackDelegate>)delegate;

@end
