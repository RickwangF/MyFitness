//
//  BTKEntityAction.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月11日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAddEntityRequest.h"
#import "BTKDeleteEntityRequest.h"
#import "BTKUpdateEntityRequest.h"
#import "BTKQueryEntityRequest.h"
#import "BTKSearchEntityRequest.h"
#import "BTKBoundSearchEntityRequest.h"
#import "BTKAroundSearchEntityRequest.h"
#import "BTKPolygonSearchEntityRequest.h"
#import "BTKDistrictSearchEntityRequest.h"
#import "BTKEntityDelegate.h"

/// entity终端的相关操作，包括entity的增、删、改、查
/**
 entity终端的相关操作，包括entity的增、删、改、查
 */
@interface BTKEntityAction : NSObject

/**
 entity相关操作单例的全局访问点

 @return 单例对象
 */
+(BTKEntityAction *)sharedInstance;

#pragma mark - 终端管理
/**
 创建Entity终端实体，并赋属性信息

 @param request 添加Entity的请求对象
 @param delegate Entity操作结果的回调对象
 */
-(void)addEntityWith:(BTKAddEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;


/**
 删除Entity终端实体

 @param request 删除Entity的请求对象
 @param delegate Entity操作结果的回调对象
 */
-(void)deleteEntityWith:(BTKDeleteEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;


/**
 更新Entity终端实体属性信息

 @param request 修改Entity的请求对象
 @param delegate Entity操作结果的回调对象
 */
-(void)updateEntityWith:(BTKUpdateEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;


/**
 检索符合过滤条件的Entity终端实体，返回Entity属性信息和最新位置，可用于列出Entity，也可用于批量查询多个Entity的位置。

 @param request 查询Entity的请求对象
 @param delegate Entity操作结果的回调对象
 */
-(void)queryEntityWith:(BTKQueryEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

#pragma mark - 实时位置搜索
/**
 根据关键字搜索Entity终端实体，并返回实时位置。

 @param request 搜索Entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)searchEntityWith:(BTKSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

/**
 根据矩形地理范围搜索Entity终端实体，并返回实时位置

 @param request 搜索Entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)boundSearchEntityWith:(BTKBoundSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

/**
 根据圆心半径搜索Entity终端实体，并返回实时位置

 @param request 搜索Entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)aroundSearchEntityWith:(BTKAroundSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

/**
 在多边形区域内搜索Entity终端实体，并返回实时位置

 @param request 搜索Entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)polygonSearchEntityWith:(BTKPolygonSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

/**
 在行政区域内搜索Entity终端实体，并返回实时位置

 @param request 搜索Entity的请求对象
 @param delegate 搜索结果的回调对象
 */
-(void)districtSearchEntityWith:(BTKDistrictSearchEntityRequest *)request delegate:(id<BTKEntityDelegate>)delegate;

@end
