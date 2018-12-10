//
//  BTKStartServiceOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年02月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 开启轨迹服务的配置信息
@interface BTKStartServiceOption : NSObject

/**
 终端实体的名称
 */
@property (nonatomic, copy) NSString *entityName;

/**
 构造方法

 @param entityName 终端实体的名称，采集的轨迹将算在该entity名下
 @return 配置信息对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName;

@end
