//
//  Cooperation.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cooperation : NSObject

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *content;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) BOOL darkImage;

+ (instancetype)cooperationWithDictionary:(NSDictionary*)obj;

@end

NS_ASSUME_NONNULL_END
