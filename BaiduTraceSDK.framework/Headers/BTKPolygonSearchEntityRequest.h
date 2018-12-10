//
//  BTKPolygonSearchEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年06月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"
#import "BTKQueryEntityFilterOption.h"
#import "BTKSearchEntitySortByOption.h"

/**
 在多边形区域内检索终端实体的请求类
 */
@interface BTKPolygonSearchEntityRequest : BTKAPIBaseRequest

/**
 多边形区域的顶点坐标，必填。
 数组中的每一项为CLLocationCoordinate2D类型的坐标点，代表多边形的一个顶点。
 */
@property (nonatomic, copy) NSArray *vertexes;

/**
 多边形区域坐标点的坐标类型，可选，默认为BTK_COORDTYPE_BD09LL。
 该字段用于控制返回结果中的坐标类型。可选值为：
 BTK_COORDTYPE_WGS84：GPS坐标
 BTK_COORDTYPE_GCJ02：国测局加密坐标
 BTK_COORDTYPE_BD09LL：百度经纬度坐标
 */
@property (nonatomic, assign) BTKCoordType inputCoordType;

/**
 过滤条件，可选。
 */
@property (nonatomic, strong) BTKQueryEntityFilterOption *filter;

/**
 排序方法，可选。
 */
@property (nonatomic, assign) BTKSearchEntitySortByOption *sortby;

/**
 返回的坐标类型，可选，默认为BTK_COORDTYPE_BD09LL。
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
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几条记录。
 */
@property (nonatomic, assign) NSUInteger pageSize;


/**
 构造方法

 @param vertexes 多边形的顶点坐标
 @param inputCoordType 多边形顶点的坐标类型
 @param filter 过滤条件
 @param sortby 排序方法
 @param outputCoordType 返回的终端位置的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithVertexes:(NSArray *)vertexes inputCoordType:(BTKCoordType)inputCoordType filter:(BTKQueryEntityFilterOption *)filter sortby:(BTKSearchEntitySortByOption *)sortby outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
