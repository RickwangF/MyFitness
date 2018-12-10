//
//  BTKCustomTrackPoint.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月08日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKLocationPoint.h"

/// 自定义轨迹点信息类
/**
 开发者自定义的轨迹点信息类，开发者可以通过此类设置需要上传的轨迹点信息。
 */
@interface BTKCustomTrackPoint : BTKLocationPoint

/**
 方向
 */
@property (nonatomic, assign) NSUInteger direction;

/**
 高度
 */
@property (nonatomic, assign) double height;

/**
 定位精度
 */
@property (nonatomic, assign) double radius;

/**
 速度
 */
@property (nonatomic, assign) double speed;

/**
 自定义数据字典。可选。
 key为开发者添加的自定义字段；
 value为该字段对应的值。
 */
@property (nonatomic, copy) NSDictionary *customData;

/**
 该轨迹点所属的终端实体的名称
 */
@property (nonatomic, copy) NSString *entityName;

/**
 构造方法

 @param coordinate 位置坐标
 @param coordType 坐标类型
 @param loctime 定位时间（UNIX时间戳）
 @param direction 方向
 @param height 高度
 @param radius 定位精度
 @param speed 速度
 @param customData 自定义数据
 @param entityName 轨迹点所属的终端实体的名称
 @return 自定义轨迹点
 */
-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate coordType:(BTKCoordType)coordType loctime:(UInt64)loctime direction:(NSUInteger)direction height:(double)height radius:(double)radius speed:(double)speed customData:(NSDictionary *)customData entityName:(NSString *)entityName;

@end
