//
//  BTKQueryTrackLatestPointRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月10日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKQueryTrackProcessOption.h"

/// 查询某entity终端实体的实时位置的请求信息类
/**
 查询某entity终端实体的实时位置时，请求信息通过此类设置
 */
@interface BTKQueryTrackLatestPointRequest : BTKAPIBaseRequest

/**
 需要查询的entity的名称，必填，必须为非空字符串。
 */
@property (nonatomic, copy) NSString *entityName;

/**
 纠偏选项，选填。
 若设置此选项，则使用开发者指定的选项进行纠偏。
 如果不设置，或者值为nil，将使用默认的纠偏选项：去燥、不绑路、不过滤噪点、交通方式为驾车。
 */
@property (nonatomic, strong) BTKQueryTrackProcessOption *processOption;

/**
 返回的坐标类型，选填。
 该字段用于控制返回结果中的坐标类型。
 只允许设置为百度经纬度或者国测局经纬度。
 该参数仅对国内（包含港、澳、台）轨迹有效，海外区域轨迹均返回 wgs84坐标系。
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 构造方法

 @param entityName entity名称
 @param processOption 纠偏选项
 @param outputCoordType 返回的坐标类型
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 查询某entity的实时位置的请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName processOption:(BTKQueryTrackProcessOption *)processOption outputCootdType:(BTKCoordType)outputCoordType serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
