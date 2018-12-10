//
//  BTKPushMessageFenceAlarmContent.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKPushMessageBaseContent.h"
#import "BTKFenceAlarmLocationPoint.h"
#import "BTKTypes.h"

/// 地理围栏报警推送信息类
/**
 客户端和服务端的地理围栏报警的内容都使用本类来解析
 */
@interface BTKPushMessageFenceAlarmContent : BTKPushMessageBaseContent

/**
 触发报警的地理围栏的ID
 */
@property (nonatomic, assign) NSUInteger fenceID;

/**
 触发报警的地理围栏的名称
 */
@property (nonatomic, copy) NSString *fenceName;

/**
 触发报警的地理围栏所监控的对象的名称
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 触发报警的动作类型
 */
@property (nonatomic, assign) BTKFenceMonitoredObjectActionType actionType;

/**
 触发报警的轨迹点
 */
@property (nonatomic, strong) BTKFenceAlarmLocationPoint *currentPoint;

/**
 触发报警之前的轨迹点
 */
@property (nonatomic, strong) BTKFenceAlarmLocationPoint *previousPoint;

@end
