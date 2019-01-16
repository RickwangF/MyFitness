//
//  Cooperation.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "Cooperation.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation Cooperation

+ (instancetype)cooperationWithDictionary:(NSDictionary *)obj{
	Cooperation *coop = [Cooperation new];
	coop.objectId = [obj objectForKey:@"objectId"];
	coop.title = [obj objectForKey:@"title"];
	coop.content = [obj objectForKey:@"content"];
	coop.imageUrl = [obj objectForKey:@"imageUrl"];
	coop.darkImage = [[obj objectForKey:@"darkImage"] boolValue];
	return coop;
}

@end
