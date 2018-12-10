//
//  BTKDistrictSearchEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年06月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKQueryEntityFilterOption.h"
#import "BTKSearchEntitySortByOption.h"

/// 在指定的行政区域内检索Entity的请求类
@interface BTKDistrictSearchEntityRequest : BTKAPIBaseRequest

/**
 行政区划关键字，必填。
 支持中国国家、省、市、区/县名称。请尽量输入完整的行政区层级和名称，保证名称的唯一性。若输入的行政区名称匹配多个行政区，围栏将创建失败。
 示例： 中国 北京市 湖南省长沙市 湖南省长沙市雨花区
 
 */
@property (nonatomic, copy) NSString *keyword;

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
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几个结果。
 */
@property (nonatomic, assign) NSUInteger pageSize;

/**
 返回结果的内容（只返回个数还是返回完整结果）
 注意：此字段的值会影响返回结果的格式
 */
@property (nonatomic, assign) BTKEntitySearchResultType returnType;

/**
 构造方法(已废弃，请使用包含returnType字段的新方法)

 @param keyword 行政区域关键字
 @param filter 过滤条件
 @param sortby 排序方法
 @param outputCoordType 返回的Entity位置的坐标类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithQueryKeyword:(NSString *)keyword filter:(BTKQueryEntityFilterOption *)filter sortby:(BTKSearchEntitySortByOption *)sortby outputCoordType:(BTKCoordType)outputCoordType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag __deprecated;

/**
 构造方法
 
 @param keyword 行政区域关键字
 @param filter 过滤条件
 @param sortby 排序方法
 @param outputCoordType 返回的Entity位置的坐标类型
 @param returnType 返回结果的内容类型
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithQueryKeyword:(NSString *)keyword filter:(BTKQueryEntityFilterOption *)filter sortby:(BTKSearchEntitySortByOption *)sortby outputCoordType:(BTKCoordType)outputCoordType returnType:(BTKEntitySearchResultType)returnType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize ServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
