//
//  BTKDeleteEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月11日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"

/// 删除指定的某个entity终端实体的请求信息类
/**
 删除某个entity终端实体操作的请求信息通过此类设置
 */
@interface BTKDeleteEntityRequest : BTKAPIBaseRequest

/**
 entity名称，作为其唯一标识，必填
 同一service服务中entity_name不可重复。一旦创建，entity_name 不可更新。
 命名规则：仅支持中文、英文大小字母、英文下划线"_"、英文横线"-"和数字。 entity_name 和 entity_desc 支持联合模糊检索。
 */
@property (nonatomic, copy) NSString *entityName;

/**
 构造方法

 @param entityName entity名称
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 删除entity的请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end
