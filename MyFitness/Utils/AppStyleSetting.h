//
//  AppStyleSetting.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppStyleSetting : NSObject
	
@property (nonatomic, strong) UIColor *naviBarTintColor;
	
@property (nonatomic, strong) UIColor *naviTintColor;
	
@property (nonatomic, strong) UIColor *viewBgColor;

@property (nonatomic, strong) UIColor *leftSideVCBgColor;
	
@property (nonatomic, strong) UIColor *textColor;
	
@property (nonatomic, strong) UIColor *smallTextColor;
	
@property (nonatomic, strong) UIColor *mainColor;
	
@property (nonatomic, strong) UIColor *separatorColor;
	
@property (nonatomic, strong) UIColor *lightSeparatorColor;

@property (nonatomic, strong) UIColor *counterBottomBgColor;

@property (nonatomic, strong) UIColor *themeTextColor;
 
+(AppStyleSetting*)sharedInstance;

@end

NS_ASSUME_NONNULL_END
