//
//  BTKTraceDelegate.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年02月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKTypes.h"
#import "BTKPushMessage.h"

/// 轨迹服务的代理协议，服务和采集的相关操作的执行结果，通过本协议中的方法回调
@protocol BTKTraceDelegate <NSObject>

@optional
/**
 开启轨迹服务的回调方法

 @param error 开启轨迹服务的结果
 */
-(void)onStartService:(BTKServiceErrorCode) error;
/**
 停止轨迹服务的回调方法

 @param error 停止轨迹服务的结果
 */
-(void)onStopService:(BTKServiceErrorCode) error;

/**
 开始采集的回调方法

 @param error 开始采集的操作结果
 */
-(void)onStartGather:(BTKGatherErrorCode) error;
/**
 停止采集的回调方法

 @param error 停止采集的操作结果
 */
-(void)onStopGather:(BTKGatherErrorCode) error;

/**
 收到推送消息的回调方法

 @param message 推送消息的内容
 */
-(void)onGetPushMessage:(BTKPushMessage *)message;

/**
 用户自定义信息的设置方法，SDK在每个采集周期会回调此方法，将此方法的返回值作为该定位周期内轨迹点的附加数据

 @return 当前定位周期内轨迹点的附加数据，key代表自定义字段名称，value代表自定义字段的值。用法见DEMO
 */
-(NSDictionary *)onGetCustomData;

/**
 更改采集和打包上传周期的结果的回调方法

 @param error 更改周期的结果
 */
-(void)onChangeGatherAndPackIntervals:(BTKChangeIntervalErrorCode) error;

/**
 设置缓存占用的最大磁盘空间的结果的回调方法

 @param error 设置的结果
 */
-(void)onSetCacheMaxSize:(BTKSetCacheMaxSizeErrorCode) error;

@end
