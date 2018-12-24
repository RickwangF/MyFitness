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
			sharedInstance.naviBarTintColor = UIColor.whiteColor;
			sharedInstance.homeNaviBarTintColor = [UIColor colorWithHexString:@"#ffe617"];
			sharedInstance.homeStepperColor = [UIColor colorWithHexString:@"#424242"];
			sharedInstance.naviTintColor = UIColor.blackColor;
			sharedInstance.viewBgColor = UIColor.whiteColor;
			sharedInstance.lightGrayViewBgColor = [UIColor colorWithHexString:@"#f1f1f1"];
			sharedInstance.leftSideVCBgColor = [UIColor colorWithHexString:@"#ededed"];
			sharedInstance.userCenterBgColor = [UIColor colorWithHexString:@"#323232"];
			sharedInstance.textColor = UIColor.blackColor;
			sharedInstance.smallTextColor = UIColor.darkGrayColor;
			sharedInstance.mainColor = [UIColor colorWithHexString:@"#ffe617"];
			sharedInstance.separatorColor = UIColor.lightGrayColor;
			sharedInstance.lightSeparatorColor = [UIColor colorWithHexString:@"#e1e1e1"];
			sharedInstance.wideSeparatorColor = [UIColor colorWithHexString:@"f1f1f1"];
			sharedInstance.counterBottomBgColor = [UIColor colorWithHexString:@"#1e293d"];
			sharedInstance.themeTextColor = [UIColor colorWithHexString:@"#f0c800"];
			sharedInstance.last7DaysColor = [UIColor colorWithHexString:@"#32d882"];
		}
	});
	return sharedInstance;
}

@end
