//
//  BTKQueryTrackProcessOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月19日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKTypes.h"

/// 查询Track时的纠偏选项
/**
 查询Track的最新位置、轨迹里程、轨迹点等操作中，如果需要返回纠偏后的结果，需要通过此类设置纠偏参数
 */
@interface BTKQueryTrackProcessOption : NSObject

/**
 纠偏时是否需要去噪，TRUE代表去噪
 */
@property (nonatomic, assign) BOOL denoise;

/**
 纠偏时是否需要抽稀，TRUE代表抽稀。
 该选项只有在查询行程信息的请求BTKQueryHistoryTrackRequest中有效。
 在BTKQueryTrackLatestPointRequest和BTKQueryTrackDistanceRequest中的processOption选项中设置此属性没有效果。
 */
@property (nonatomic, assign) BOOL vacuate;

/**
 纠偏时是否需要绑路，TRUE代表绑路
 */
@property (nonatomic, assign) BOOL mapMatch;

/**
 纠偏时的定位精度过滤阀值，用于过滤掉定位精度较差的轨迹点。
 0代表不过滤，100代表过滤掉定位精度大于100米的轨迹点。
 例如：若只需保留 GPS 定位点，则建议设为：20；若需保留 GPS 和 Wi-Fi 定位点，去除基站定位点，则建议设为：100
 */
@property (nonatomic, assign) NSUInteger radiusThreshold;

/**
 纠偏时的交通方式，鹰眼将根据不同交通工具选择不同的纠偏策略
 */
@property (nonatomic, assign) BTKTrackProcessOptionTransportMode transportMode;

@end
