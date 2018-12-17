//
//  AppDelegate.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduTraceSDK/BaiduTraceSDK.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <AVOSCloud/AVOSCloud.h>
#import <SideMenu/SideMenu-Swift.h>
#import "UIDevice+Type.h"
#import "ProjectConst.h"
#import "AppStyleSetting.h"
#import "HomeViewController.h"
#import "UIImage+UIColor.h"
#import "NavigationViewController.h"

@interface AppDelegate ()<BMKLocationAuthDelegate, BMKGeneralDelegate>
    
@property (nonatomic, strong) BMKMapManager *mapManager; // 地图的主引擎

@end

@implementation AppDelegate
    
@synthesize mapManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:BaiduMapAppID mcode:EagleEyeMcode serviceID:EagleEyeServiceID keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduMapAppID authDelegate:self];
    
    mapManager = [[BMKMapManager alloc] init];
    
    BOOL result = [mapManager start:BaiduMapAppID generalDelegate:self];
    if (!result) {
        NSLog(@"引擎启动失败");
    }
    
    [AVOSCloud setApplicationId:AVOSCloudAppID clientKey:AVOSCloudClientKey];
    [AVOSCloud setAllLogsEnabled:YES];
	
	[UINavigationBar appearance].translucent = YES;
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithUIColor:AppStyleSetting.sharedInstance.naviBarTintColor] forBarMetrics:UIBarMetricsDefault];
	[UINavigationBar appearance].tintColor = AppStyleSetting.sharedInstance.naviTintColor;
	[UINavigationBar appearance].barStyle = UIBarStyleDefault;
	[[UINavigationBar appearance] setShadowImage:[UIImage new]];
	
	_window = [[UIWindow alloc] init];
	_window.frame = UIScreen.mainScreen.bounds;
	
	HomeViewController *homeVC = [[HomeViewController alloc] init];
	NavigationViewController *naviVC = [[NavigationViewController alloc] initWithRootViewController:homeVC];
	
	_window.rootViewController = naviVC;
	[_window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
