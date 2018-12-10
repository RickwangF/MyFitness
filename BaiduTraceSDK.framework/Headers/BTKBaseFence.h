//
//  BTKBaseFence.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月30日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BTKTypes.h"

/// 地理围栏的基类，所有类型的地理围栏都继承自此类。
/**
 地理围栏的基类，所有类型的地理围栏都继承自此类。
 开发者不需要关注此类，也不应该用此类去实例化一个地理围栏，而应该使用其子类去实例化具体类型的地理围栏。
 */
@interface BTKBaseFence : NSObject

/**
 地理围栏的名称，选填。
 */
@property (nonatomic, copy) NSString *fenceName;

/**
 地理围栏监控对象的名称。
 新建地理围栏时必填，必须为非空字符串。
 更新地理围栏时选填。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 构造方法

 @param fenceName 地理围栏名称
 @param monitoredObject 地理围栏的监控对象的名称
 @return 对象
 */
-(instancetype)initWithFenceName:(NSString *)fenceName monitoredObject:(NSString *)monitoredObject;

@end
