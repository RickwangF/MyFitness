//
//  BTKClearTrackCacheOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年05月05日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 删除客户端缓存的轨迹数据时的筛选条件
/**
 删除客户端缓存的轨迹数据时的筛选条件，每个筛选条件用于指定某个需要删除的entity所符合的特征。
 若指定startTime和endTime，则删除指定entity在该时间段内的缓存；
 若不指定，则删除指定entity的所有缓存数据。
 */
@interface BTKClearTrackCacheOption : NSObject

/**
 需要删除哪个entity的缓存数据，必选。
 */
@property (nonatomic, copy) NSString *entityName;

/**
 需要删除的缓存的开始时间，可选。
 */
@property (nonatomic, assign) NSUInteger startTime;

/**
 需要删除的缓存的结束时间，可选。
 */
@property (nonatomic, assign) NSUInteger endTime;


/**
 构造方法

 @param entityName 要删除的缓存所属的entity名称
 @param startTime 要删除的缓存的开始时间
 @param endTime 要删除的缓存的结束时间
 @return 筛选条件对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName startTime:(NSUInteger)startTime endTime:(NSUInteger)endTime;

@end
