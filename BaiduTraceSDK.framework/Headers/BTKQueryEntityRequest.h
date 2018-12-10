//
//  BTKQueryEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月11日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKQueryEntityFilterOption.h"
#import "BTKTypes.h"

/// 查询符合条件的entity终端实体操作的请求信息类
/**
 查询符合条件的entity终端实体操作，请求信息通过此类设置
 */
@interface BTKQueryEntityRequest : BTKAPIBaseRequest

/**
 过滤条件
 */
@property (nonatomic, strong) BTKQueryEntityFilterOption *filter;

/**
 返回结果的坐标类型
 国内只能选择百度经纬度或者国测局经纬度，该字段在国外无效，国外均返回 wgs84坐标
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 分页索引，选填。
 默认值为1。
 pageIndex与pageSize一起计算从第几条结果返回，代表返回第几页。
 */
@property (nonatomic, assign) NSUInteger pageIndex;

/**
 分页大小，选填。
 默认值为100。
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几条记录。
 */
@property (nonatomic, assign) NSUInteger pageSize;

/**
 构造方法
 
 @param filter 查询的过滤条件
 @param outputCoordType 返回结果的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 查询entity的请求对象
 */
-(instancetype)initWithFilter:(BTKQueryEntityFilterOption *)filter outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
