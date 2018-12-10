//
//  BTKSearchEntitySortByOption.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月27日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKTypes.h"

///检索Entity时返回结果的排序规则
/**
 检索Entity时，通过此类设置返回结果的排序规则
 */
@interface BTKSearchEntitySortByOption : NSObject

/**
 需要排序的字段。
 支持的排序字段有：
 loc_time：entity 最新定位时间
 entity_name：entity 唯一标识
 entity_desc：entity描述信息
 <custom-key>：开发者自定义的 entity 属性字段
 */
@property (nonatomic, copy) NSString *fieldName;

/**
 排序方式。升序或降序。
 */
@property (nonatomic, assign) BTKEntitySortType sortType;

@end
