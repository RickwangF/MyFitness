//
//  BTKQueryTrackDistanceRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月10日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"
#import "BTKQueryTrackProcessOption.h"

/// 查询某entity终端实体，在指定时间段内的行驶里程的请求信息类
/**
 查询某entity终端实体，在指定的时间段内的行驶里程的请求信息，通过此类设置
 */
@interface BTKQueryTrackDistanceRequest : BTKAPIBaseRequest

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
 构造方法
 
 @param entityName entity名称
 @param startTime 开始时间
 @param endTime 结束时间
 @param isProcessed 是否返回纠偏后的里程
 @param processOption 纠偏选项
 @param supplementMode 里程补偿方式
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 查询某entity行驶里程的请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime isProcessed:(BOOL)isProcessed processOption:(BTKQueryTrackProcessOption *)processOption supplementMode:(BTKTrackProcessOptionSupplementMode)supplementMode serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
