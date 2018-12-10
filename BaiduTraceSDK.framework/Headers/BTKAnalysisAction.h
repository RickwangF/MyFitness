//
//  BTKAnalysisAction.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKStayPointAnalysisRequest.h"
#import "BTKDrivingBehaviourAnalysisRequest.h"
#import "BTKAnalysisDelegate.h"

/// 轨迹分析相关操作类
@interface BTKAnalysisAction : NSObject

/**
 轨迹分析相关操作的全局访问点

 @return 单例对象
 */
+(BTKAnalysisAction *)sharedInstance;

/**
 停留点分析

 @param request 请求对象
 @param delegate 操作结果的回调对象
 */
-(void)analyzeStayPointWith:(BTKStayPointAnalysisRequest *)request delegate:(id<BTKAnalysisDelegate>)delegate;

/**
 驾驶行为分析

 @param request 请求对象
 @param delegate 操作结果的回调对象
 */
-(void)analyzeDrivingBehaviourWith:(BTKDrivingBehaviourAnalysisRequest *)request delegate:(id<BTKAnalysisDelegate>)delegate;

@end
