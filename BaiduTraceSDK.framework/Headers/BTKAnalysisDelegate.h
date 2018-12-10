//
//  BTKAnalysisDelegate.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月26日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTKAnalysisDelegate <NSObject>

@optional

/**
 停留点分析的回调方法

 @param response 停留点分析的结果
 */
-(void)onAnalyzeStayPoint:(NSData *)response;

/**
 驾驶行为分析的回调方法

 @param response 驾驶行为分析的结果
 */
-(void)onAnalyzeDrivingBehaviour:(NSData *)response;

@end
