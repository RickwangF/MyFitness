//
//  BTKSearchEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKQueryEntityFilterOption.h"
#import "BTKSearchEntitySortByOption.h"

///根据关键字检索Entity的请求类
/**
 根据关键字检索Entity时，请求信息通过此类设置
 */
@interface BTKSearchEntityRequest : BTKAPIBaseRequest

/**
 检索关键字，可选。
 */
@property (nonatomic, copy) NSString *query;

/**
 过滤条件，可选。
 */
@property (nonatomic, strong) BTKQueryEntityFilterOption *filter;

/**
 排序方法，可选。
 */
@property (nonatomic, assign) BTKSearchEntitySortByOption *sortby;

/**
 返回的坐标类型，可选。
 该字段用于控制返回结果中的坐标类型。可选值为：
 BTK_COORDTYPE_GCJ02：国测局加密坐标
 BTK_COORDTYPE_BD09LL：百度经纬度坐标
 该参数仅对国内（包含港、澳、台）轨迹有效，海外区域轨迹均返回 wgs84坐标系
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
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几个轨迹点。
 */
@property (nonatomic, assign) NSUInteger pageSize;

-(instancetype)initWithQueryKeyword:(NSString *)query filter:(BTKQueryEntityFilterOption *)filter sortby:(BTKSearchEntitySortByOption *)sortby outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
