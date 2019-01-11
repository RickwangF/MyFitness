//
//  SportParameter.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/11.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportModeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface SportParameter : NSObject

@property (nonatomic, assign) TransportModeEnum mode;

@property (nonatomic, assign) BOOL mute;

@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, assign) NSInteger time;

- (instancetype)initWithTransportMode:(TransportModeEnum)mode Mute:(BOOL)mute Distance:(NSInteger)distance Time:(NSInteger)time;

@end

NS_ASSUME_NONNULL_END
