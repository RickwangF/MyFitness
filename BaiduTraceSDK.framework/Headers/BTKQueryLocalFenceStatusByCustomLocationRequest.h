//
//  BTKQueryLocalFenceStatusByCustomLocationRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月18日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"
#import <CoreLocation/CoreLocation.h>

/// 查询被监控对象，在指定的位置时，和客户端地理围栏的位置关系的请求信息类
/**
 查询指定的坐标位置，是在指定的客户端围栏的内部还是外部的请求信息，通过此类设置
 */
@interface BTKQueryLocalFenceStatusByCustomLocationRequest : BTKAPIBaseRequest

/**
 客户端地理围栏监控对象的名称，必须为非空的字符串。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 指定的坐标位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D customLocation;

/**
 坐标类型
 */
@property (nonatomic, assign) BTKCoordType coordType;

/**
 客户端地理围栏的ID列表
 若为nil或空数组，则查询指定坐标位置相对该监控对象上的所有客户端地理围栏的位置关系。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 构造方法

 @param monitoredObject 围栏的监控对象名称
 @param customLocation 指定的位置坐标
 @param coordType 坐标类型
 @param fenceIDs 客户端地理围栏的ID列表
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithmonitoredObject:(NSString *)monitoredObject CustomLocation:(CLLocationCoordinate2D)customLocation coordType:(BTKCoordType)coordType fenceIDs:(NSArray *)fenceIDs tag:(NSUInteger)tag;

@end
