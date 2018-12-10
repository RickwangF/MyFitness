//
//  BTKQueryLocalFenceStatusRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月18日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"

/// 查询被监控对象和客户端地理围栏的位置关系的请求信息类
/**
 查询监控对象的最新位置，是在客户端围栏的内部还是外部的请求信息，通过此类设置
 */
@interface BTKQueryLocalFenceStatusRequest : BTKAPIBaseRequest

/**
 围栏监控对象的名称。
 必选，且必须为非空的字符串。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 围栏实体的ID列表。
 设置此属性，则查找监控对象相对于指定围栏的位置关系。
 不设置此属性，则查询监控对象相对于其上所有围栏的位置关系。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 构造方法
 
 @param monitoredObject 监控对象的名称
 @param fenceIDs 围栏实体的ID列表
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithMonitoredObject:(NSString *)monitoredObject fenceIDs:(NSArray *)fenceIDs tag:(NSUInteger)tag;

@end
