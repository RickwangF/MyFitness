//
//  BTKFenceDelegate.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 地理围栏代理协议，地理围栏相关操作的执行结果，通过本协议中的方法回调
/**
 地理围栏代理协议，地理围栏相关操作的执行结果，通过本协议中的方法回调
 */
@protocol BTKFenceDelegate <NSObject>

@optional

#pragma mark - 客户端围栏 实体管理
/**
 创建客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onCreateLocalFence:(NSData *)response;

/**
 删除客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onDeleteLocalFence:(NSData *)response;

/**
 更新客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onUpdateLocalFence:(NSData *)response;

/**
 查询客户端地理围栏的回调方法

 @param response 创建客户端围栏的结果
 */
-(void)onQueryLocalFence:(NSData *)response;


#pragma mark - 客户端围栏 状态与报警查询

/**
 查询监控对象和客户端地理围栏的位置关系的回调方法

 @param response 查询结果
 */
-(void)onQueryLocalFenceStatus:(NSData *)response;

/**
 根据自定义位置，查询监控对象和客户端地理围栏的位置关系的回调方法

 @param response 查询结果
 */
-(void)onQueryLocalFenceStatusByCustomLocation:(NSData *)response;

/**
 查询客户端地理围栏历史报警信息的回调方法

 @param response 查询结果
 */
-(void)onQueryLocalFenceHistoryAlarm:(NSData *)response;


#pragma mark - 服务端围栏 实体管理
/**
 创建服务端地理围栏的回调方法

 @param response 创建服务端围栏的结果
 */
-(void)onCreateServerFence:(NSData *)response;

/**
 删除服务端地理围栏的回调方法

 @param response 删除服务端围栏的结果
 */
-(void)onDeleteServerFence:(NSData *)response;

/**
 修改服务端地理围栏的回调方法

 @param response 修改服务端围栏的结果
 */
-(void)onUpdateServerFence:(NSData *)response;

/**
 查询服务端地理围栏的回调方法

 @param response 查询服务端围栏的结果
 */
-(void)onQueryServerFence:(NSData *)response;


#pragma mark - 服务端围栏 状态与报警查询
/**
 查询监控对象在服务端地理围栏内外的回调方法

 @param response 查询结果
 */
-(void)onQueryServerFenceStatus:(NSData *)response;

/**
 根据指定的位置查询被监控对象的状态的回调方法

 @param response 查询结果
 */
-(void)onQueryServerFenceStatusByCustomLocation:(NSData *)response;

/**
 查询监控对象的服务端围栏报警信息的回调方法

 @param response 查询结果
 */
-(void)onQueryServerFenceHistoryAlarm:(NSData *)response;

/**
 批量同步某service的服务端地理围栏报警信息的回调方法

 @param response 查询结果
 */
-(void)onBatchQueryServerFenceHistoryAlarm:(NSData *)response;

@end
