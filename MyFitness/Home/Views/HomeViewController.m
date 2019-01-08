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
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "NSString+NSDate.h"
#import "TrackRecord.h"
#import "ShadowCircleButton.h"
#import "LeftSideViewController.h"
#import "UIDevice+Type.h"
#import "NavigationViewController.h"
#import "UserCenterViewController.h"
#import "MyRecordViewController.h"
#import "UIImage+UIColor.h"
#import "DistanceStepperView.h"


@interface HomeViewController ()<BMKMapViewDelegate, BMKLocationManagerDelegate, SubViewControllerDelegate, CAPSPageMenuDelegate>
    
@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) UIView *controlContainerView;

@property (nonatomic, strong) HMSegmentedControl *modeControl;

@property (nonatomic, strong) UIButton *todayDistanceBtn;

@property (nonatomic, strong) ShadowCircleButton *startBtn;

@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, strong) UIButton *muteBtn;

@property (nonatomic, strong) DistanceStepperView *stepper;

@property (nonatomic, strong) BMKLocationManager *locationManager;
    
@property (nonatomic, strong) BMKUserLocation *userLocation;
    
@property (nonatomic, assign) TransportModeEnum transportMode;

@property (nonatomic, assign) BOOL needRefreshMap;

@property (nonatomic, assign) BOOL mute;

@property (nonatomic, assign) BOOL showStepper;

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
    _transportMode = TransportModeWalking;
	_needRefreshMap = NO;
	_mute = NO;
	_showStepper = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map.json" ofType:@""];
    [BMKMapView customMapStyle:path];
}

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
    
#pragma mark - Lift Circle
    
- (void)loadView{
    UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainView.backgroundColor = [UIColor whiteColor];
    self.view = mainView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:AppStyleSetting.sharedInstance.homeNaviBarTintColor] forBarMetrics:UIBarMetricsDefault];
	self.navigationItem.backBarButtonItem = [UIBarButtonItem new];
	
	[self initTitleView];
	
	[self initLeftSideBtn];
	
	[self initTodayDistanceBtn];
	
	[self getTodayDistance];
	
	[self initMapView];
	
	[self updateLocationViewParam];
	
	[self initModeControl];
	
	[self initStepper];
	
	[self initStartBtn];
	
	[self initSetBtn];
	
	[self initMuteBtn];
	
	[self initlocationManager];
	
	[self initLeftSideViewController];
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
	_needRefreshMap = YES;
	[_mapView removeFromSuperview];
	_mapView = nil;
	
}
    
#pragma mark - Init View

- (void)initTitleView{
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	titleLabel.textColor = AppStyleSetting.sharedInstance.naviTintColor;
	titleLabel.text = @"MyFitness";
	titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
}
    
- (void)initLeftSideBtn{
    UIButton *leftSideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftSideBtn setImage:[UIImage imageNamed:@"avatar_20#ff"] forState:UIControlStateNormal];
	leftSideBtn.backgroundColor = [UIColor colorWithRed:220.0/255 green:214.0/255 blue:214.0/255 alpha:1.0];
	leftSideBtn.layer.cornerRadius = 15;
	leftSideBtn.layer.masksToBounds = YES;
    [leftSideBtn addTarget:self action:@selector(leftSideBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
        make.left.right.equalTo(self.view);
		if ([[UIDevice currentDevice] fullScreen]) {
			make.bottom.equalTo(self.view).offset(45);
		}
		else{
			make.bottom.equalTo(self.view).offset(25);
		}
    }];
}
    
- (void)updateLocationViewParam{
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = YES;
    displayParam.isAccuracyCircleShow = NO;
    displayParam.locationViewOffsetX = 0;
    displayParam.locationViewOffsetY = 0;
    displayParam.locationViewImgName = @"dot_28#blue";
    [self.mapView updateLocationViewWithParam:displayParam];
}

- (void)initModeControl{
	_controlContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
	_controlContainerView.backgroundColor = AppStyleSetting.sharedInstance.homeNaviBarTintColor;
	[self.view addSubview:_controlContainerView];
	
	[_controlContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		} else {
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.right.equalTo(self.view);
		make.height.equalTo(@50);
	}];
	
	_modeControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	_modeControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_modeControl setSectionTitles:@[@"健走", @"跑步", @"骑行"]];
	_modeControl.backgroundColor = AppStyleSetting.sharedInstance.homeNaviBarTintColor;
	_modeControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
	_modeControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
	_modeControl.selectionIndicatorColor = AppStyleSetting.sharedInstance.textColor;
	_modeControl.selectionIndicatorHeight = 2.0;
	_modeControl.selectedSegmentIndex = 0;
	[_modeControl addTarget:self action:@selector(modeControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	[_controlContainerView addSubview:_modeControl];
	
	[_modeControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.controlContainerView);
		make.width.equalTo(@200);
		make.height.equalTo(@40);
	}];
}

- (void)initTodayDistanceBtn{
	UIView *bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 130, 25)];
	containerView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	containerView.layer.cornerRadius = 12.5;
	containerView.layer.masksToBounds = YES;
	[bottomContainerView addSubview:containerView];
	
	_todayDistanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
	[_todayDistanceBtn setTitle:@"今日0km" forState:UIControlStateNormal];
	[_todayDistanceBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	_todayDistanceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
	[_todayDistanceBtn addTarget:self action:@selector(todayDistanceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[containerView addSubview:_todayDistanceBtn];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bottomContainerView];
}

- (void)initStepper{
	_stepper = [[DistanceStepperView alloc] initWithFrame:CGRectMake(0, 0, 250, 110)];
	_stepper.hidden = YES;
	[self.view addSubview:_stepper];
	
	[_stepper mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.controlContainerView.mas_bottom).offset(70);
		make.centerX.equalTo(self.view);
		make.height.equalTo(@110);
		make.width.equalTo(@250);
	}];
}

- (void)initStartBtn{
	_startBtn = [[ShadowCircleButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	_startBtn.backgroundColor = AppStyleSetting.sharedInstance.mainColor;
	[_startBtn setTitle:@"GO!" forState:UIControlStateNormal];
	[_startBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	_startBtn.titleLabel.font = [UIFont systemFontOfSize:35 weight:UIFontWeightSemibold];
	[_startBtn setShadow];
	[_startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_startBtn];
	
	[_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-65);
		make.centerX.equalTo(self.view);
		make.width.height.equalTo(@100);
	}];
}

- (void)initSetBtn{
	_setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
	_setBtn.backgroundColor = UIColor.whiteColor;
	_setBtn.layer.cornerRadius = 27.5;
	[_setBtn setImage:[UIImage imageNamed:@"set_27#42"] forState:UIControlStateNormal];
	_setBtn.layer.shadowColor = UIColor.lightGrayColor.CGColor;
	_setBtn.layer.shadowOffset = CGSizeMake(0, 5);
	_setBtn.layer.shadowOpacity = 0.8;
	_setBtn.layer.shadowRadius = 8;
	[_setBtn addTarget:self action:@selector(setBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_setBtn];
	
	[_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.startBtn.mas_left).offset(-20);
		make.centerY.equalTo(self.startBtn);
		make.width.height.equalTo(@55);
	}];
}

- (void)initMuteBtn{
	_muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
	_muteBtn.backgroundColor = UIColor.whiteColor;
	_muteBtn.layer.cornerRadius = 27.5;
	[_muteBtn setImage:[UIImage imageNamed:@"voice_27#42"] forState:UIControlStateNormal];
	_muteBtn.layer.shadowColor = UIColor.lightGrayColor.CGColor;
	_muteBtn.layer.shadowOffset = CGSizeMake(0, 5);
	_muteBtn.layer.shadowOpacity = 0.8;
	_muteBtn.layer.shadowRadius = 8;
	[_muteBtn addTarget:self action:@selector(muteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_muteBtn];
	
	[_muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.startBtn.mas_right).offset(20);
		make.centerY.equalTo(self.startBtn);
		make.width.height.equalTo(@55);
	}];
}

- (void)initLeftSideViewController{
	LeftSideViewController *leftSideVC = [[LeftSideViewController alloc] init];
	leftSideVC.delegate = self;
	UISideMenuNavigationController *leftNaviVC = [[UISideMenuNavigationController alloc] initWithRootViewController:leftSideVC];
	
	[SideMenuManager defaultManager].menuLeftNavigationController = leftNaviVC;
	[SideMenuManager defaultManager].menuPresentMode = MenuPresentModeMenuSlideIn;
	[SideMenuManager defaultManager].menuFadeStatusBar = NO;
	[SideMenuManager defaultManager].menuAnimationFadeStrength = 0.6;
	[SideMenuManager defaultManager].menuWidth = self.view.frame.size.width * 0.7;
}

#pragma mark - Request

- (void)getTodayDistance{
	if ([AVUser currentUser] == nil) {
		return;
	}
	
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
	
	NSDate *toady = [calendar dateFromComponents:components];
	NSDate *tomorrow = [NSDate dateWithTimeInterval:24*60*60 sinceDate:toady];
	
	AVQuery *query = [AVQuery queryWithClassName:@"TrackRecord"];
	[query whereKey:@"user" equalTo:[AVUser currentUser]];
	[query whereKey:@"startTime" greaterThanOrEqualTo:toady];
	[query whereKey:@"finishedTime" lessThan:tomorrow];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		if (error != nil) {
			[self.view makeToast:error.localizedDescription];
			return;
		}
		else{
			if (objects == nil || objects.count == 0) {
				return;
			}
			
			double mileage = 0;
			for (NSDictionary *dic in objects) {
				double trackDistance = [dic[@"mileage"] doubleValue];
				if (trackDistance > 0) {
					mileage += trackDistance;
				}
			}
			mileage = mileage / 1000;
			NSString *mileString = [NSString stringWithFormat:@"今日%.1fkm", mileage];
			[self.todayDistanceBtn setTitle:mileString forState:UIControlStateNormal];
		}
	}];
}
    
#pragma mark - Action
    
- (void)leftSideBtnClicked:(UIButton*)sender{
    [self presentViewController:SideMenuManager.defaultManager.menuLeftNavigationController animated:YES completion:nil];
}

- (void)presentLoginVC{
	LoginViewController *loginVC = [[LoginViewController alloc] init];
	NavigationViewController *naviVC = [[NavigationViewController alloc] initWithRootViewController:loginVC];
	[naviVC.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	[self presentViewController:naviVC animated:YES completion:nil];
}

- (void)todayDistanceBtnClicked:(UIButton*)sender{
	if ([AVUser currentUser] == nil) {
		[self presentLoginVC];
		return;
	}
}

- (void)modeControlValueChanged:(HMSegmentedControl*)sender{
	NSInteger index = sender.selectedSegmentIndex;
	switch (index) {
		case 0:
			_transportMode = TransportModeWalking;
			break;
		case 1:
			_transportMode = TransportModeRunning;
			break;
		case 2:
			_transportMode = TransportModeRiding;
		default:
			break;
	}
}

- (void)startBtnClicked:(UIButton*)sender{
	
	if ([AVUser currentUser] == nil) {
		[self presentLoginVC];
		return;
	}
	
	CounterViewController *counterVC = [[CounterViewController alloc] initWithTransportMode:_transportMode Mute:_mute];
	[self.navigationController pushViewController:counterVC animated:YES];
}

- (void)muteBtnClicked:(UIButton*)sender{
	_mute = !_mute;
	if (_mute){
		[_muteBtn setImage:[UIImage imageNamed:@"mute_27#42"] forState:UIControlStateNormal];
	}
	else{
		[_muteBtn setImage:[UIImage imageNamed:@"voice_27#42"] forState:UIControlStateNormal];
	}
}

- (void)setBtnClicked:(UIButton*)sender{
	_showStepper = !_showStepper;
	if (_showStepper) {
		_stepper.hidden = NO;
	}
	else{
		_stepper.hidden = YES;
	}
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
	
- (void)leftSideViewControllerMakePushWithFlag:(NSInteger)flag{
	if ([AVUser currentUser] == nil) {
		[self presentLoginVC];
		return;
	}
	
	switch (flag) {
		case 0: {
			UserCenterViewController *userVC = [[UserCenterViewController alloc] init];
			[self.navigationController pushViewController:userVC animated:YES];
		}
		break;
		case 1:{
			TrackListViewController *trackListVC = [[TrackListViewController alloc] init];
			[self.navigationController pushViewController:trackListVC animated:YES];
		}
		break;
		
		case 2:{
			MyRecordViewController *recordVC = [[MyRecordViewController alloc] init];
			[self.navigationController pushViewController:recordVC animated:YES];
		}
		default:
			break;
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
