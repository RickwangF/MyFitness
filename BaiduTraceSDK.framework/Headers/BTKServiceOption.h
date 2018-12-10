//
//  BTKServiceOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年02月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 轨迹服务运行需要的基础信息类
@interface BTKServiceOption : NSObject

/**
 AK
 */
@property (nonatomic, copy) NSString *ak;

/**
 MCODE
 */
@property (nonatomic, copy) NSString *mcode;

/**
 轨迹服务的ID
 */
@property (nonatomic, assign) NSUInteger serviceID;

/**
 是否保活
 */
@property (nonatomic, assign) BOOL keepAlive;

/**
 构造方法

 @param ak ak
 @param mcode mcode
 @param serviceID 轨迹服务的ID
 @param keepAlive 是否保活
 @return 轨迹服务运行需要的基础信息对象
 */
-(instancetype)initWithAK:(NSString *)ak mcode:(NSString *)mcode serviceID:(NSUInteger)serviceID keepAlive:(BOOL)keepAlive;

@end
