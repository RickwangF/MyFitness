//
//  AppStyleSetting.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "AppStyleSetting.h"
#import "UIColor+UIColor_Hex.h"

static AppStyleSetting *sharedInstance;

@implementation AppStyleSetting
	
+(AppStyleSetting *)sharedInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (sharedInstance == nil) {
			sharedInstance = [[AppStyleSetting alloc] init];
			sharedInstance.naviBarTintColor = [UIColor colorWithRed:23.0/255 green:179.0/255 blue:93.0/255 alpha:1.0];
			sharedInstance.naviTintColor = UIColor.whiteColor;
			sharedInstance.viewBgColor = UIColor.whiteColor;
			sharedInstance.textColor = UIColor.blackColor;
			sharedInstance.smallTextColor = UIColor.darkGrayColor;
			sharedInstance.mainColor = [UIColor colorWithRed:23.0/255 green:179.0/255 blue:93.0/255 alpha:1.0];
			sharedInstance.separatorColor = UIColor.lightGrayColor;
			sharedInstance.lightSeparatorColor = [UIColor colorWithHexString:@"#e1e1e1"];
		}
	});
	return sharedInstance;
}

@end
