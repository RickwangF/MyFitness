//
//  BTKFenceAction.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKCreateLocalFenceRequest.h"
#import "BTKUpdateLocalFenceRequest.h"
#import "BTKQueryLocalFenceRequest.h"
#import "BTKDeleteLocalFenceRequest.h"
#import "BTKCreateServerFenceRequest.h"
#import "BTKDeleteServerFenceRequest.h"
#import "BTKUpdateServerFenceRequest.h"
#import "BTKQueryServerFenceRequest.h"
#import "BTKQueryServerFenceStatusRequest.h"
#import "BTKQueryServerFenceStatusByCustomLocationRequest.h"
#import "BTKQueryServerFenceHistoryAlarmRequest.h"
#import "BTKBatchQueryServerFenceHistoryAlarmRequest.h"
#import "BTKQueryLocalFenceStatusRequest.h"
#import "BTKQueryLocalFenceStatusByCustomLocationRequest.h"
#import "BTKQueryLocalFenceHistoryAlarmRequest.h"
#import "BTKFenceDelegate.h"

/// 地理围栏业务的相关操作
/**
 地理围栏业务的相关操作
 */
@interface BTKFenceAction : NSObject

/**
 单例的全局访问点

 @return 单例对象
 */
+(BTKFenceAction *)sharedInstance;

#pragma mark - 客户端地理围栏的增删改查

/**
 新建客户端围栏

 @param request 创建客户端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)createLocalFenceWith:(BTKCreateLocalFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 删除客户端围栏

 @param request 删除客户端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)deleteLocalFenceWith:(BTKDeleteLocalFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 更新客户端围栏

 @param request 更新客户端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)updateLocalFenceWith:(BTKUpdateLocalFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 查询客户端围栏

 @param request 查询客户端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryLocalFenceWith:(BTKQueryLocalFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;


#pragma mark - 客户端地理围栏的报警查询
/**
 查询被监控对象和客户端地理围栏的位置关系
 
 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryLocalFenceStatusWith:(BTKQueryLocalFenceStatusRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 查询被监控对象，在指定的坐标时，和客户端地理围栏的位置关系

 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryLocalFenceStatusByCustomLocationWith:(BTKQueryLocalFenceStatusByCustomLocationRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 查询指定监控对象的客户端地理围栏历史报警信息
 
 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryLocalFenceHistoryAlarmWith:(BTKQueryLocalFenceHistoryAlarmRequest *)request delegate:(id<BTKFenceDelegate>)delegate;


#pragma mark - 服务端地理围栏的增删改查
/**
 创建服务端地理围栏

 @param request 创建服务端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)createServerFenceWith:(BTKCreateServerFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 删除服务端地理围栏

 @param request 删除服务端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)deleteServerFenceWith:(BTKDeleteServerFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 修改服务端地理围栏
 注意：只能更新为相同种类的地理围栏，比如原来fenceID对应的是圆形围栏，则无法更新为多边形围栏。

 @param request 修改服务端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)updateServerFenceWith:(BTKUpdateServerFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 查询服务端地理围栏

 @param request 查询服务端地理围栏的请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryServerFenceWith:(BTKQueryServerFenceRequest *)request delegate:(id<BTKFenceDelegate>)delegate;


#pragma mark - 服务端地理围栏的报警查询

/**
 查询监控对象在围栏内或外

 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryServerFenceStatusWith:(BTKQueryServerFenceStatusRequest *)request delegate:(id<BTKFenceDelegate>)delegate;


/**
 根据指定的坐标位置，查询监控对象和服务端地理围栏的位置关系

 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryServerFenceStatusByCustomLocationWith:(BTKQueryServerFenceStatusByCustomLocationRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 查询某监控对象的历史报警信息

 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)queryServerFenceHistoryAlarmWith:(BTKQueryServerFenceHistoryAlarmRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

/**
 批量查询某 service 下时间段以内的所有报警信息，用于服务端报警同步

 @param request 请求对象
 @param delegate 执行结果的回调对象
 */
-(void)batchQueryServerFenceHistoryAlarmWith:(BTKBatchQueryServerFenceHistoryAlarmRequest *)request delegate:(id<BTKFenceDelegate>)delegate;

@end
