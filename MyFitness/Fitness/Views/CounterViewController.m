//
//  CounterViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "CounterViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduTraceSDK/BaiduTraceSDK.h>
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "TransportModeEnum.h"
#import "MZTimerLabel.h"
#import "AppStyleSetting.h"
#import "CircleProgressButton.h"
#import "TrackDetailViewController.h"

@interface CounterViewController ()<BTKTraceDelegate, BMKLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;
	
@property (nonatomic, strong) UIView *topBackgroundView;

@property (nonatomic, strong) UIView *bottomBackgroundView;

@property (nonatomic, strong) MZTimerLabel *timeCountingLabel;

@property (nonatomic, strong) UILabel *speedLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIButton *pauseBtn;

@property (nonatomic, strong) UIButton *resumeBtn;

@property (nonatomic, strong) CircleProgressButton *stopBtn;

@property (nonatomic, assign) CGFloat centerOriginX;

@property (nonatomic, assign) CGFloat centerOriginY;

@property (nonatomic, assign) CGFloat resumeOriginX;

@property (nonatomic, assign) CGFloat resumeOriginY;

@property (nonatomic, assign) CGFloat stopOriginX;

@property (nonatomic, assign) CGFloat stopOriginY;

@property (nonatomic, strong) UIImageView *roundView;

@property (nonatomic, assign) TransportModeEnum transportMode;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSTimer *timer;
	
@property (nonatomic, assign) BOOL firstLoad;
	
@property (nonatomic, strong) BMKLocation *lastLocation;
	
@property (nonatomic, strong) BMKLocation *currentLocation;
	
@property (nonatomic, assign) CLLocationDistance distance;
	
@property (nonatomic, strong) NSDate *startDate;
	
@property (nonatomic, strong) NSDate *finishDate;

// m/s
@property (nonatomic, assign) CLLocationSpeed speed;
	
@property (nonatomic, strong) AVObject *trackRecord;
	
@end

@implementation CounterViewController
	
- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleLightContent;
}

#pragma  mark - Init
	
- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_transportMode = TransportModeRunning;
		[self initValueProperty];
	}
	return self;
}
	
- (instancetype)initWithTransportMode:(TransportModeEnum)mode{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_transportMode = mode;
		[self initValueProperty];
	}
	return self;
}
	
#pragma mark - Init Property
	
- (void)initValueProperty{
	_number = 3;
	_firstLoad = YES;
	_lastLocation = [[BMKLocation alloc] init];
	_currentLocation = [[BMKLocation alloc]init];
	_distance = 0;
	_startDate = [NSDate date];
	_finishDate = [NSDate new];
	_speed = 0;
}
	
- (void)initlocationManager{
	_locationManager = [[BMKLocationManager alloc] init];
	_locationManager.delegate = self;
	_locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
	_locationManager.distanceFilter = 5.0;
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
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
	
	[self initlocationManager];
	[self initBackgroundView];
	[self initPauseBtn];
	
	[self initDistanceLabel];
	[self initTimeCountingLabel];
	[self initSpeedLabel];
	
	// Do any additional setup after loading the view.
}
	
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}
	
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	_centerOriginX = self.view.frame.size.width / 2 - 40;
	_centerOriginY = self.view.frame.size.height - 140 - 40;
	
	_resumeOriginX = self.view.frame.size.width / 2 - 10 - 80;
	_resumeOriginY = self.view.frame.size.height - 140 - 40;
	
	_stopOriginX = self.view.frame.size.width / 2 + 10;
	_stopOriginY = self.view.frame.size.height - 140 - 50;
	
	[self initResumeBtn];
	[self initStopBtn];
	
	// 第一次加载的时候默认开始
	if (_firstLoad) {
		_firstLoad = NO;
		[_timeCountingLabel start];
		[_locationManager startUpdatingLocation];
		[self startService];
	}
}
	
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}
	
#pragma mark - Animation
	
	
#pragma mark - Init Views
	
- (void)initBackgroundView{
	_bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 140)];
	_bottomBackgroundView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:_bottomBackgroundView];
	
	[_bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self.view);
		make.height.equalTo(@140);
	}];
	
	//0x17b35d
	_topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
	_topBackgroundView.backgroundColor = AppStyleSetting.sharedInstance.mainColor;
	[self.view addSubview:_topBackgroundView];
	
	[_topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.top.right.equalTo(self.view);
		make.bottom.equalTo(self.bottomBackgroundView.mas_top);
	}];
}
	
- (void)initPauseBtn{
	CGFloat bottomXcenter = self.view.center.x - 52.5;
	CGFloat originY = self.view.bounds.size.height - 140 - 52.5;
	_pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomXcenter, originY, 105, 105)];
	_pauseBtn.backgroundColor = [UIColor whiteColor];
	[_pauseBtn setImage:[UIImage imageNamed:@"pause_30#51"] forState:UIControlStateNormal];
	[_pauseBtn addTarget:self action:@selector(pauseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	_pauseBtn.layer.cornerRadius = 52.5;
	_pauseBtn.clipsToBounds = YES;
	[self.view addSubview:_pauseBtn];
}
	
- (void)initResumeBtn{
	_resumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.centerOriginX, self.centerOriginY, 80, 80)];
	_resumeBtn.backgroundColor = [UIColor whiteColor];
	[_resumeBtn setImage:[UIImage imageNamed:@"start_24#17b35d"] forState:UIControlStateNormal];
	[_resumeBtn addTarget:self action:@selector(resumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	_resumeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	_resumeBtn.layer.cornerRadius = 40;
	_resumeBtn.clipsToBounds = YES;
	_resumeBtn.alpha = 0;
	[self.view addSubview:_resumeBtn];
}
	
- (void)initStopBtn{
	_stopBtn = [[CircleProgressButton alloc] initWithFrame:CGRectMake(self.centerOriginX - 10, self.centerOriginY - 10, 100, 100)];
	[_stopBtn setProgressBtnBackgroundColor:AppStyleSetting.sharedInstance.viewBgColor];
	[_stopBtn setProgressColor:UIColor.whiteColor];
	__weak typeof(self) weakSelf = self;
	_stopBtn.longPressedBlock = ^{
		[weakSelf stopBtnClicked];
	};
	_stopBtn.alpha = 0;
	[self.view addSubview:_stopBtn];
}
	
	//104 158 144
- (void)initDistanceLabel{
	_distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
	_distanceLabel.text = @"0.00";
	_distanceLabel.font = [UIFont systemFontOfSize:100];
	_distanceLabel.textColor = [UIColor whiteColor];
	[_topBackgroundView addSubview:_distanceLabel];
	
	[_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.topBackgroundView).offset(250);
		make.centerX.equalTo(self.topBackgroundView);
		make.height.equalTo(@110);
	}];
	
	UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 18)];
	displayLabel.text = @"距离（公里）";
	displayLabel.textColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
	displayLabel.font = [UIFont systemFontOfSize:16];
	[self.topBackgroundView addSubview:displayLabel];
	
	[displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.distanceLabel.mas_bottom).offset(20);
		make.centerX.equalTo(self.topBackgroundView);
		make.height.equalTo(@18);
	}];
}
	
- (void)initTimeCountingLabel{
	_timeCountingLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeStopWatch];
	_timeCountingLabel.frame = CGRectMake(0, 0, 100, 26);
	_timeCountingLabel.textColor = [UIColor whiteColor];
	_timeCountingLabel.timeFormat = @"HH:mm:ss";
	_timeCountingLabel.font = [UIFont systemFontOfSize:26];
	[_topBackgroundView addSubview:self.timeCountingLabel];
	
	[_timeCountingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.distanceLabel.mas_bottom).offset(100);
		make.centerX.equalTo(self.topBackgroundView).offset(-90);
		make.height.equalTo(@26);
	}];
	
	UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 18)];
	displayLabel.text = @"时：分：秒";
	displayLabel.textColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
	displayLabel.font = [UIFont systemFontOfSize:14];
	[self.topBackgroundView addSubview:displayLabel];
	
	[displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.timeCountingLabel.mas_bottom).offset(15);
		make.centerX.equalTo(self.timeCountingLabel);
		make.height.equalTo(@16);
	}];
}
	
- (void)initSpeedLabel{
	_speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 26)];
	_speedLabel.text = @"0";
	_speedLabel.font = [UIFont systemFontOfSize:24];
	_speedLabel.textColor = [UIColor whiteColor];
	[_topBackgroundView addSubview:self.speedLabel];
	
	[_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.distanceLabel.mas_bottom).offset(100);
		make.centerX.equalTo(self.topBackgroundView).offset(90);
		make.height.equalTo(@26);
	}];
	
	UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 18)];
	displayLabel.text = @"实时速度（公里/时）";
	displayLabel.textColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
	displayLabel.font = [UIFont systemFontOfSize:14];
	[self.topBackgroundView addSubview:displayLabel];
	
	[displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.speedLabel.mas_bottom).offset(15);
		make.centerX.equalTo(self.speedLabel);
		make.height.equalTo(@16);
	}];
}
	
#pragma mark - Action
	
- (void)startService{
	NSString *userName = [AVUser currentUser].username;
	BTKStartServiceOption *opt = [[BTKStartServiceOption alloc] initWithEntityName:userName];
	[[BTKAction sharedInstance] startService:opt delegate:self];
	[[BTKAction sharedInstance] startGather:self];
	[self.view makeToast:@"开始服务并开始采集轨迹"];
}
	
- (void)stopGather{
	[[BTKAction sharedInstance] stopGather:self];
	[self.view makeToast:@"停止采集轨迹"];
}
	
- (void)startGather{
	[[BTKAction sharedInstance] startGather:self];
	[self.view makeToast:@"开始采集轨迹"];
}
	
- (void)stopService{
	[[BTKAction sharedInstance] stopGather:self];
	[[BTKAction sharedInstance] stopService:self];
	[self.view makeToast:@"关闭轨迹采集服务"];
}
	
- (void)constructTrackRecord{
	_trackRecord = [AVObject objectWithClassName:@"TrackRecord"];
	
	double timeInterval = [_timeCountingLabel getTimeCounted];
	double minDouble = timeInterval / 60;
	int minFloor = floor(minDouble);
	int secRound = round(timeInterval - (minFloor * 60));
	
	NSMutableString *formattString = [NSMutableString stringWithString:@"%d:%d"];
	if (minFloor < 10) {
		formattString = [NSMutableString stringWithString:@"0%d:%d"];
		
		if (secRound < 10) {
			formattString = [NSMutableString stringWithString:@"0%d:0%d"];
		}
	}
	
	NSMutableString *minuteString = [NSMutableString stringWithFormat:formattString,minFloor, secRound];
	
	CLLocationSpeed avgSpeed = (_distance / 1000) / (minDouble / 60);
	double calorie = 41 * _distance / 1000;
	double carbon = 115 * _distance / 1000;
	double intervalKm = timeInterval / (_distance / 1000);
	
	[_trackRecord setObject:[AVUser currentUser] forKey:@"user"];
	[_trackRecord setObject:_startDate forKey:@"startTime"];
	[_trackRecord setObject:_finishDate forKey:@"finishedTime"];
	[_trackRecord setObject:[NSNumber numberWithDouble:timeInterval] forKey:@"interval"];
	[_trackRecord setObject:minuteString forKey:@"minuteString"];
	[_trackRecord setObject:[NSNumber numberWithDouble:_distance] forKey:@"mileage"];
	[_trackRecord setObject:[NSNumber numberWithDouble: avgSpeed] forKey:@"avgSpeed"];
	[_trackRecord setObject:[NSNumber numberWithDouble:intervalKm] forKey:@"paceSpeed"];
	[_trackRecord setObject:[NSNumber numberWithDouble:calorie] forKey:@"calorie"];
	[_trackRecord setObject:[NSNumber numberWithDouble:carbon] forKey:@"carbonSaving"];
	[_trackRecord setObject:[NSNumber numberWithInt: _transportMode] forKey:@"transportMode"];
}
	
- (void)saveTrackRecord{
	// 构造轨迹记录模型
	[self constructTrackRecord];
	
	[_trackRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
		if (succeeded) {
			[self.view makeToast:@"记录保存成功"];
			// 打开轨迹记录的详细
			TrackDetailViewController *detailVC = [[TrackDetailViewController alloc] initWithStartTime:self.startDate FinishedTime:self.finishDate TransportMode:self.transportMode TrackId:self.trackRecord.objectId];
			[self.navigationController pushViewController:detailVC animated:YES];
		}
		else{
			if (error == nil) {
				[self.view makeToast:@"轨迹保存失败"];
				return;
			}
			
			[self.view makeToast:[NSString stringWithFormat:@"轨迹保存失败，%@", error.localizedDescription]];
		}
	}];
}

	
- (void)pauseBtnClicked:(UIButton*)sender{
	[_timeCountingLabel pause];
	_resumeBtn.alpha = 1;
	_stopBtn.alpha = 1;
	
	_currentLocation = nil;
	_lastLocation = nil;
	[_locationManager stopUpdatingLocation];
	[self stopGather];
	
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.pauseBtn.alpha = 0;
		self.resumeBtn.frame = CGRectMake(self.resumeOriginX, self.resumeOriginY, 80, 80);
		self.stopBtn.frame = CGRectMake(self.stopOriginX, self.stopOriginY, 100, 100);
	} completion:^(BOOL finish){
		if (finish) {
			[self stopGather];
		}
	}];
}
	
- (void)resumeBtnClicked:(UIButton*)sender{
	[_timeCountingLabel start];
	
	[_locationManager startUpdatingLocation];
	[self startGather];
	
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.pauseBtn.alpha = 1;
		self.resumeBtn.alpha = 0;
		self.stopBtn.alpha = 0;
		self.resumeBtn.frame = CGRectMake(self.centerOriginX, self.centerOriginY, 80, 80);
		self.stopBtn.frame = CGRectMake(self.centerOriginX - 10, self.centerOriginY - 10, 100, 100);
	} completion:^(BOOL finish){
		if (finish) {
			[self startGather];
		}
	}];
}
	
- (void)stopBtnClicked{
	_finishDate = [NSDate date];
	[self stopService];
	[_locationManager stopUpdatingLocation];
	
	// 测试代码
	//TrackDetailViewController *detailVC = [[TrackDetailViewController alloc] initWithStartTime:self.startDate FinishedTime:self.finishDate TransportMode:self.transportMode TrackId:@"12312312398787"];
	//[self.navigationController pushViewController:detailVC animated:YES];
	
	//正式代码
	[self saveTrackRecord];
}
	
- (void)calculateDistance{
	CLLocation *last = _lastLocation.location;
	CLLocation *current = _currentLocation.location;
	CLLocationDistance pointsDistance = [current distanceFromLocation:last];
	if (pointsDistance > 0) {
		_distance += pointsDistance;
	}
}
	
- (void)refreshDisplayData{
	_distanceLabel.text = [NSString stringWithFormat:@"%.2f", _distance / 1000];
	_speedLabel.text = [NSString stringWithFormat:@"%.1f", _speed];
}
	
#pragma mark - BMKLocationManagerDelegate
	
// 更新定位的位置信息
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
	
	if (error != nil) {
		NSLog(@"Location Error--%ld   detail==>%@",(long)error.code, error.localizedDescription);
	}
	
	if (location == nil) {
		[self.navigationController.view makeToast:@"定位失败"];
		return;
	}
	
	_lastLocation = _currentLocation;
	_currentLocation = location;
	_speed = fabs(_currentLocation.location.speed);
	[self calculateDistance];
	[self refreshDisplayData];
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
