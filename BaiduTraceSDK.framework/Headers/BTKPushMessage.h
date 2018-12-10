//
//  BTKPushMessage.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKPushMessageBaseContent.h"

/// 推送信息类
@interface BTKPushMessage : NSObject

/**
 推送消息的类型
 * 0x01：配置下发;
 * 0x02：语音消息;
 * 0x03：服务端地理围栏报警消息;
 * 0x04：客户端地理围栏报警消息;
 * 0x05~0x40：系统预留;
 * 0x41~0xFF：开发者自定义;
 */
@property (nonatomic, assign) UInt16 type;

/**
 推送消息的内容，BTKPushMessageBaseContent是所有推送消息内容的基类，根据type字段的值，选择不同的子类去解析该内容。
 当type字段的值为 0x03 和 0x04 时，使用BTKPushMessageFenceAlarmContent对象来解析。
 */
@property (nonatomic, strong) BTKPushMessageBaseContent *content;

@end
