//
//  BTKAPIBaseRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年03月31日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 API请求的基类，开发者不需要关注此类，也不应该使用该类的对象进行操作
 */
@interface BTKAPIBaseRequest : NSObject

/**
 轨迹服务的ID
 */
@property (nonatomic, assign) NSUInteger serviceID;
/**
 请求标志
 */
@property (nonatomic, assign) NSUInteger tag;

/**
 构造方法

 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithServiceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
