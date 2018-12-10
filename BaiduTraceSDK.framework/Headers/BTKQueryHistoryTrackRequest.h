//
//  BTKQueryHistoryTrackRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月10日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"
#import "BTKQueryTrackProcessOption.h"

/// 查询某entity终端实体，在一段时间之内的行程信息的请求信息类
/**
 查询某entity终端实体，在一段时间之内的行程信息，通过此类设置请求信息
 */
@interface BTKQueryHistoryTrackRequest : BTKAPIBaseRequest

/**
 需要查询的entity的名称，必填，必须为非空字符串
 */
@property (nonatomic, copy) NSString *entityName;
/**
 开始时间 UNIX时间戳，必填。
 */
@property (nonatomic, assign) NSUInteger startTime;
/**
 结束时间 UNIX时间戳，必填。
 结束时间不能大于当前时间，且起止时间区间不超过24小时。
 */
@property (nonatomic, assign) NSUInteger endTime;
/**
 是否返回纠偏后的里程，选填。
 TRUE代表返回纠偏后的里程，FALSE代表使用原始轨迹计算里程。
 默认值为FALSE。
 */
@property (nonatomic, assign) BOOL isProcessed;

/**
 纠偏选项，选填。
 该选项只有在isProcessed选项为TRUE时有效。
 若设置此选项，则使用开发者指定的选项进行纠偏。
 如果不设置，或者值为nil，将使用默认的纠偏选项：去燥、不绑路、不过滤噪点、交通方式为驾车。
 */
@property (nonatomic, strong) BTKQueryTrackProcessOption *processOption;

/**
 里程补偿的方式，选填。
 在里程计算时，两个轨迹点定位时间间隔5分钟以上，被认为是中断。中断轨迹可以进行里程补偿，通过此属性设置里程补偿的方式。
 默认值为BTK_TRACK_PROCESS_OPTION_NO_SUPPLEMENT 不进行里程补偿。
 */
@property (nonatomic, assign) BTKTrackProcessOptionSupplementMode supplementMode;

/**
 返回的坐标类型，选填。
 该字段用于控制返回结果中的坐标类型。
 只允许设置为百度经纬度或者国测局经纬度。
 该参数仅对国内（包含港、澳、台）轨迹有效，海外区域轨迹均返回 wgs84坐标系。
 */
@property (nonatomic, assign) BTKCoordType outputCoordType;

/**
 返回轨迹点的排序规则，选填。
 若不设置，则使用默认值BTK_TRACK_SORT_TYPE_ASC，按照定位时间升序排序（旧->新）
 */
@property (nonatomic, assign) BTKTrackSortType sortType;

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

/**
 构造方法

 @param entityName 要查询的entity终端实体的名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param isProcessed 是否返回纠偏后的轨迹
 @param processOption 纠偏选项
 @param supplementMode 里程补偿方式
 @param outputCoordType 返回轨迹点的坐标类型
 @param sortType 返回轨迹点的排序规则
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime isProcessed:(BOOL)isProcessed processOption:(BTKQueryTrackProcessOption *)processOption supplementMode:(BTKTrackProcessOptionSupplementMode)supplementMode outputCoordType:(BTKCoordType)outputCoordType sortType:(BTKTrackSortType)sortType pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
