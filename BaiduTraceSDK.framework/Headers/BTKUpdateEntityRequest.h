//
//  BTKUpdateEntityRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月11日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BTKAPIBaseRequest.h"

/// 更新某个指定的entity终端实体的请求信息类
/**
 更新某个指定的entity终端实体操作时，请求信息通过此类设置
 */
@interface BTKUpdateEntityRequest : BTKAPIBaseRequest

/**
 entity名称，必填。不可更新。
 同一service服务中entity_name不可重复。一旦创建，entity_name 不可更新。
 命名规则：仅支持中文、英文大小字母、英文下划线"_"、英文横线"-"和数字。 entity_name 和 entity_desc 支持联合模糊检索。
 */
@property (nonatomic, copy) NSString *entityName;
/**
 entity的可读性描述，选填，可更新。
 命名规则：仅支持中文、英文大小字母、英文下划线"_"、英文横线"-"和数字。entity_name 和 entity_desc 支持联合模糊检索
 */
@property (nonatomic, copy) NSString *entityDesc;
/**
 开发者自定义字段，选填，可更新。
 字典中的key必须是已经通过鹰眼的轨迹管理台创建过的属性字段才有效
 */
@property (nonatomic, copy) NSDictionary *columnKey;

/**
 构造方法
 
 @param entityName entity名称，作为其唯一标识
 @param entityDesc entity的可读性描述
 @param columnKey 开发者自定义字段信息
 @param serviceID 轨迹服务的ID
 @param tag 请求标志
 @return 更新entity信息的请求对象
 */
-(instancetype)initWithEntityName:(NSString *)entityName entityDesc:(NSString *)entityDesc columnKey:(NSDictionary *)columnKey serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;



@end
