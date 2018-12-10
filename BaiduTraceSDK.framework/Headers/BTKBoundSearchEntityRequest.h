//
//  BTKBoundSearchEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"
#import "BTKQueryEntityFilterOption.h"
#import "BTKSearchEntitySortByOption.h"

/// 在矩形区域内检索终端实体的请求类
@interface BTKBoundSearchEntityRequest : BTKAPIBaseRequest

/**
 矩形区域左下角和右上角的顶点坐标，必选。
 数组应该有2个元素，均为CLLocationCoordinate2D类型，第一个代表矩形区域左下角的顶点坐标，第二个代表矩形区域右上角的顶点坐标。
 */
@property (nonatomic, copy) NSArray *bounds;

/**
 矩形区域坐标点的坐标类型，可选，默认为BTK_COORDTYPE_BD09LL。
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
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几条记录。
 */
@property (nonatomic, assign) NSUInteger pageSize;

/**
 构造方法

 @param bounds 矩形区域左下角和右上角的顶点坐标
 @param inputCoordType 矩形区域顶点的坐标类型
 @param filter 过滤条件
 @param sortby 排序方法
 @param outputCoordType 返回的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithBounds:(NSArray *)bounds inputCoordType:(BTKCoordType)inputCoordType filter:(BTKQueryEntityFilterOption *)filter sortby:(BTKSearchEntitySortByOption *)sortby outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
