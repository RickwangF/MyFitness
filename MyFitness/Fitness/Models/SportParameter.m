//
//  SportParameter.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/11.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "SportParameter.h"
#import "TransportModeEnum.h"

@implementation SportParameter

- (instancetype)init
{
	self = [super init];
	if (self) {
		_mode = TransportModeWalking;
		_mute = NO;
		_distance = 0;
		_time = 0;
	}
	return self;
}

- (instancetype)initWithTransportMode:(TransportModeEnum)mode Mute:(BOOL)mute Distance:(NSInteger)distance Time:(NSInteger)time{
	self = [super init];
	if (self) {
		_mode = mode;
		_mute = mute;
		_distance = distance;
		_time = time;
	}
	return self;
}

@end
