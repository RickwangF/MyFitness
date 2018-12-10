//
//  BTKQueryEntityFilterOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月12日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 查询Entity的请求对象中的过滤条件
/**
 查询Entity的请求对象中的过滤条件
 */
@interface BTKQueryEntityFilterOption : NSObject

/**
 entityName列表，精确筛选
 NSArray数组中，每一项为NSString
 */
@property (nonatomic, copy) NSArray *entityNames;

/**
 UNIX时间戳，查询在此时间之后有定位信息上传的entity（loc_time>=activeTime）。
 如查询2016-8-21 00:00:00之后仍活跃的entity，此字段设置为1471708800。
 activeTime 和 inactiveTime 不可同时输入
 */
@property (nonatomic, assign) NSUInteger activeTime;

/**
 UNIX时间戳，查询在此时间之后无定位信息上传的entity（loc_time < inactiveTime）。
 如查询2016-8-21 00:00:00之后不活跃的entity，此字段设置为1471708800。
 activeTime 和 inactiveTime 不可同时输入
 */
@property (nonatomic, assign) NSUInteger inactiveTime;

/**
 开发者自定义的可筛选的entity属性字段，示例："team:北京"
 */
@property (nonatomic, copy) NSDictionary *columnKey;

@end
