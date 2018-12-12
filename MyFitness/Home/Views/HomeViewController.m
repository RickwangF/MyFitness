//
//  HomeViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "HomeViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "CAPSPageMenu.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import "TransportModeEnum.h"
#import <SideMenu/SideMenu-Swift.h>
#import "PageItemViewController.h"
#import "AppStyleSetting.h"
#import "UIDevice+Type.h"
#import "CounterViewController.h"
#import "LoginViewController.h"
#import "TrackListViewController.h"


@interface HomeViewController ()<BMKMapViewDelegate, BMKLocationManagerDelegate, SubViewControllerDelegate, CAPSPageMenuDelegate>
    
@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationManager *locationManager;
    
@property (nonatomic, strong) BMKUserLocation *userLocation;
	
@property (nonatomic, strong) CAPSPageMenu *pageMenu;
    
@property (nonatomic, strong) NSMutableArray *subViewControllers;
    
@property (nonatomic, assign) TransportModeEnum transportMode;

@property (nonatomic, assign) BOOL needRefreshMap;

@end

@implementation HomeViewController

#pragma mark - Init
    
- (instancetype)init{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self initValueProperty];
    }
    return self;
}
    
- (void)initValueProperty{
    _subViewControllers = [[NSMutableArray alloc] init];
    _transportMode = TransportModeRunning;
	_needRefreshMap = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"map_config.json" ofType:@""];
    [BMKMapView customMapStyle:path];
}
    
#pragma mark - Lift Circle
    
- (void)loadView{
    UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainView.backgroundColor = [UIColor whiteColor];
    self.view = mainView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"MyFitness";
	
	[self initLeftSideBtn];
	
	[self initMapView];
	
	[self updateLocationViewParam];
	
	[self initlocationManager];
	
	[self initPageMenu];
    // Do any additional setup after loading the view.
}
	
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[BMKMapView enableCustomMapStyle:YES];
	[_locationManager startUpdatingHeading];
	[_locationManager startUpdatingLocation];
	if (_needRefreshMap) {
		_needRefreshMap = NO;
		[self initMapView];
		[self.view sendSubviewToBack:_mapView];
		[self updateLocationViewParam];
	}
}
    
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [BMKMapView enableCustomMapStyle:NO];
	[_locationManager stopUpdatingHeading];
	[_locationManager stopUpdatingLocation];
	[_mapView removeFromSuperview];
	_mapView = nil;
	_needRefreshMap = YES;
}
    
#pragma mark - Init View
    
- (void)initLeftSideBtn{
    UIButton *leftSideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftSideBtn setImage:[UIImage imageNamed:@"mine_25#ff"] forState:UIControlStateNormal];
    [leftSideBtn addTarget:self action:@selector(leftSideBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftSideBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftSideBtn];
}
    
- (void)initMapView{
    _mapView = [[BMKMapView alloc] initWithFrame: UIScreen.mainScreen.bounds];
    [self.view addSubview: _mapView];
    [BMKMapView enableCustomMapStyle:YES];
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeHeading;
    _mapView.zoomLevel = 20;
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }
        else{
            make.top.equalTo(self.mas_topLayoutGuideTop);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
}
    
- (void)updateLocationViewParam{
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = YES;
    displayParam.isAccuracyCircleShow = NO;
    displayParam.locationViewOffsetX = 0;
    displayParam.locationViewOffsetY = 0;
    displayParam.locationViewImgName = @"bnavi_icon_location_fixed";
    [self.mapView updateLocationViewWithParam:displayParam];
}
	
#pragma mark - Init Property

- (void)initlocationManager{
    _locationManager = [[BMKLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = YES;
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
}
	
- (void)initPageMenu{
	PageItemViewController *runningVC = [[PageItemViewController alloc] init];
	runningVC.title = @"跑步";
	runningVC.delegate = self;
	PageItemViewController *walingVC = [[PageItemViewController alloc] init];
	walingVC.title = @"健走";
	walingVC.view.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	walingVC.delegate = self;
	PageItemViewController *ridingVC = [[PageItemViewController alloc] init];
	ridingVC.title = @"骑行";
	ridingVC.delegate = self;
	
	[self.subViewControllers addObject:runningVC];
	[self.subViewControllers addObject:walingVC];
	[self.subViewControllers addObject:ridingVC];
	
	NSDictionary *dic =
	@{
	  CAPSPageMenuOptionMenuMargin: @(0),
	  CAPSPageMenuOptionMenuHeight: @(40),
	  CAPSPageMenuOptionMenuItemWidth: @(70),
	  CAPSPageMenuOptionCenterMenuItems: @(YES),
	  CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithWhite:1.0 alpha:0.0],
	  CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithWhite:1.0 alpha:1.0],
	  CAPSPageMenuOptionSelectionIndicatorColor: AppStyleSetting.sharedInstance.mainColor,
	  CAPSPageMenuOptionSelectedMenuItemLabelColor: AppStyleSetting.sharedInstance.mainColor,
	  CAPSPageMenuOptionUnselectedMenuItemLabelColor: UIColor.darkGrayColor
	  };
	
	_pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:self.subViewControllers frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) options:dic];
	_pageMenu.delegate = self;
	
	[self.view addSubview:self.pageMenu.view];
}
    
#pragma mark - Action
    
- (void)leftSideBtnClicked:(UIButton*)sender{
	TrackListViewController *listVC = [[TrackListViewController alloc] init];
	[self.navigationController pushViewController:listVC animated:YES];
    //[self presentViewController:SideMenuManager.defaultManager.menuLeftNavigationController animated:YES completion:nil];
}
    
#pragma mark - BMKMapViewDelegate

    
#pragma mark - BMKLocationManagerDelegate
// 更新定位的位置朝向
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading{
    
    if (heading == nil) {
        return;
    }
    
    if (_userLocation == nil){
        _userLocation = [[BMKUserLocation alloc] init];
    }
    
    _userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}
    
// 更新定位的位置信息
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
    
    if (error != nil) {
        NSLog(@"Location Error--%ld   detail==>%@",(long)error.code, error.localizedDescription);
    }
    
    if (location == nil) {
        [self.navigationController.view makeToast:@"定位失败"];
        return;
    }
    
    if (_userLocation == nil || _userLocation.location == nil) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
	
    _userLocation.location = location.location;
    [_mapView updateLocationData:self.userLocation];
    [_mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
}

#pragma mark - SubViewControllerDelegate
	
- (void)subViewControllerMakePush{
	
	if([AVUser currentUser] == nil) {
		LoginViewController *loginVC = [[LoginViewController alloc] init];
		UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
		[self presentViewController:naviVC animated:YES completion:nil];
		return;
	}
	
	CounterViewController *counterVC = [[CounterViewController alloc] initWithTransportMode:_transportMode];
	[self.navigationController pushViewController:counterVC animated:YES];
}
	
- (void)leftSideViewControllerMakePush{
	if([AVUser currentUser] == nil) {
		LoginViewController *loginVC = [[LoginViewController alloc] init];
		UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
		[self presentViewController:naviVC animated:YES completion:nil];
		return;
	}
}
	
#pragma mark - CAPSPageMenuDelegate
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index{
	switch (index) {
		case 0:
		_transportMode = TransportModeRunning;
		break;
		case 1:
		_transportMode = TransportModeWalking;
		break;
		case 2:
		_transportMode = TransportModeRiding;
		break;
		default:
		break;
	}
}
	
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
