//
//  CounterViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "CounterViewController.h"
#import <AVFoundation/AVFoundation.h>
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
#import "UIColor+UIColor_Hex.h"
#import "UIDevice+Type.h"
#import "SportParameter.h"
#import "BDSSpeechSynthesizer.h"
#import <Hero/Hero-Swift.h>

static NSString * const AppID = @"15411830";
static NSString * const APIKey = @"Ow3ZUB9sDqgMMftvQvYpUFVD";
static NSString * const SecretKey = @"vZThgqUIC5pwIthyRxPgngj1QygriOqD";

@interface CounterViewController ()<BTKTraceDelegate, BMKLocationManagerDelegate, AVAudioPlayerDelegate, BDSSpeechSynthesizerDelegate, CAAnimationDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *modeLabel;

@property (nonatomic, strong) BMKLocationManager *locationManager;
	
@property (nonatomic, strong) UIImageView *topBackgroundView;

@property (nonatomic, strong) UIView *bottomBackgroundView;

@property (nonatomic, strong) MZTimerLabel *timeCountingLabel;

@property (nonatomic, strong) UILabel *speedLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *disUnitLabel;

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

@property (nonatomic, assign) BOOL mute;

// 目标距离，km
@property (nonatomic, assign) NSInteger targetDistance;

// 目标时间，min
@property (nonatomic, assign) NSTimeInterval targetTime;

// 距离提醒已播报
@property (nonatomic, assign) BOOL alertDistance;

// 时间提醒已播报
@property (nonatomic, assign) BOOL alertTime;

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

@property (nonatomic, strong) BDSSpeechSynthesizer *synthesizer;

@property (nonatomic, strong) NSMutableArray *alertIntArray;

@property (nonatomic, strong) NSTimer *animationTimer;
// cover
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, assign) BOOL finishCountDown;
	
@end

@implementation CounterViewController

#pragma  mark - Init

- (instancetype)initWithSportParameter:(SportParameter*)param{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_transportMode = param.mode;
		_mute = param.mute;
		_targetDistance = param.distance;
		_targetTime = param.time;
		if (!_mute) {
			[self initSynthesizer];
		}
		if (_targetTime > 0) {
			[self initTimer];
		}
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
	_alertIntArray = [NSMutableArray new];
	for (int i = 1; i <= 100; i++) {
		if (_targetDistance != i) {
			[_alertIntArray addObject:@(i)];
		}
	}
	_alertTime = NO;
	_alertDistance = NO;
	_finishCountDown = NO;
}

- (void)initSynthesizer{
	// 设置在线合成
	[BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
	_synthesizer = [BDSSpeechSynthesizer sharedInstance];
	[_synthesizer setSynthesizerDelegate:self];
	[_synthesizer setApiKey:APIKey withSecretKey:SecretKey];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	
	// 设置离线合成
	NSString *engineSpeechData = [[NSBundle mainBundle] pathForResource:@"Chinese_And_English_Text.dat" ofType:@""];
	NSString *speechData = [[NSBundle mainBundle] pathForResource:@"Chinese_And_English_Speech_DYY.dat" ofType:@""];
	[_synthesizer loadOfflineEngine:engineSpeechData speechDataPath:speechData licenseFilePath:nil withAppCode:AppID];
	
	// 设置合成参数
	[_synthesizer setSynthParam:@(BDS_SYNTHESIZER_SPEAKER_DYY) forKey:BDS_SYNTHESIZER_PARAM_SPEAKER];
	[_synthesizer setSynthParam:@10 forKey:BDS_SYNTHESIZER_PARAM_ONLINE_REQUEST_TIMEOUT];
	[_synthesizer setSynthParam:@9 forKey:BDS_SYNTHESIZER_PARAM_VOLUME];
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

- (void)initTimer{
	_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerIsCounting) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)initAnimationTimer{
	_animationTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(animationTimerIsCounting) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
}
	
#pragma mark - Lift Circle
	
- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mainView.backgroundColor = UIColor.whiteColor;
	self.view = mainView;
}
	
- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	
	[self initlocationManager];
	[self initBackgroundView];
	[self setUpNavigationBar];
	
	[self initDistanceLabel];
	[self initTimeCountingLabel];
	[self initSpeedLabel];
	
	_centerOriginX = self.view.frame.size.width / 2 - 45;
	_centerOriginY = 35;
	
	_resumeOriginX = self.view.frame.size.width / 2 - 30 - 90;
	_resumeOriginY = 35;
	
	_stopOriginX = self.view.frame.size.width / 2 + 30;
	_stopOriginY = 35;
	
	[self initPauseBtn];
	
	// cover test
	[self initCoverView];
	// Do any additional setup after loading the view.
}
	
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}
	
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[self initResumeBtn];
	[self initStopBtn];
	[self initAnimationTimer];
}
	
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)dealloc{
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
	
	if (_animationTimer) {
		[_animationTimer invalidate];
		_animationTimer = nil;
	}
}

#pragma mark - Init Views

- (void)initBackgroundView{
	_bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
	_bottomBackgroundView.backgroundColor = AppStyleSetting.sharedInstance.counterBottomBgColor;
	[self.view addSubview: _bottomBackgroundView];
	
	[_bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.right.equalTo(self.view);
		make.height.equalTo(@200);
	}];
	
	_topBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
	_topBackgroundView.image = [UIImage imageNamed:@"counter_bg"];
	[self.view addSubview:_topBackgroundView];
	
	[_topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self.view);
		make.bottom.equalTo(self.bottomBackgroundView.mas_top);
	}];
}

- (void)setUpNavigationBar{
	_backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[_backBtn setImage:[UIImage imageNamed:@"left_22#ff"] forState:UIControlStateNormal];
	[_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
	
	_modeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
	_modeLabel.textColor = UIColor.whiteColor;
	_modeLabel.textAlignment = NSTextAlignmentCenter;
	_modeLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
	switch (_transportMode) {
		case TransportModeWalking:
			_modeLabel.text = @"健走";
			break;
		case TransportModeRunning:
			_modeLabel.text = @"跑步";
			break;
		case TransportModeRiding:
			_modeLabel.text = @"骑行";
			break;
		default:
			break;
	}
	[_modeLabel sizeToFit];
	self.navigationItem.titleView = _modeLabel;
}

- (void)initDistanceLabel{
	_distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
	_distanceLabel.text = @"0.00";
	_distanceLabel.font = [UIFont systemFontOfSize:100];
	_distanceLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:_distanceLabel];
	
	[_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(70);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop).offset(70);
		}
		make.centerX.equalTo(self.topBackgroundView).offset(-10);
		make.height.equalTo(@90);
	}];
	
	_disUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
	_disUnitLabel.text = @"公里";
	_disUnitLabel.textColor = UIColor.whiteColor;
	_disUnitLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
	[self.view addSubview:_disUnitLabel];
	
	[_disUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.distanceLabel.mas_right).offset(5);
		make.bottom.equalTo(self.distanceLabel).offset(-5);
		make.width.equalTo(@50);
		make.height.equalTo(@25);
	}];
}

- (void)initTimeCountingLabel{
	_timeCountingLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeStopWatch];
	_timeCountingLabel.frame = CGRectMake(0, 0, 100, 26);
	_timeCountingLabel.textColor = UIColor.whiteColor;
	_timeCountingLabel.timeFormat = @"mm:ss";
	_timeCountingLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
	[_topBackgroundView addSubview:self.timeCountingLabel];
	
	[_timeCountingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.distanceLabel.mas_bottom).offset(70);
		make.centerX.equalTo(self.view.mas_centerX).offset(-100);
		make.height.equalTo(@26);
	}];
	
	UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 18)];
	displayLabel.text = @"用时";
	displayLabel.textColor = UIColor.whiteColor;
	displayLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightSemibold];
	[self.topBackgroundView addSubview:displayLabel];
	
	[displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.timeCountingLabel.mas_bottom).offset(15);
		make.centerX.equalTo(self.timeCountingLabel);
		make.height.equalTo(@25);
	}];
}

- (void)initSpeedLabel{
	_speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 26)];
	_speedLabel.text = @"0";
	_speedLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
	_speedLabel.textColor = UIColor.whiteColor;
	[_topBackgroundView addSubview:self.speedLabel];
	
	[_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.distanceLabel.mas_bottom).offset(70);
		make.centerX.equalTo(self.view.mas_centerX).offset(100);
		make.height.equalTo(@26);
	}];
	
	UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 18)];
	displayLabel.text = @"km/h";
	displayLabel.textColor = UIColor.whiteColor;
	displayLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightSemibold];
	[self.topBackgroundView addSubview:displayLabel];
	
	[displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.speedLabel.mas_bottom).offset(15);
		make.centerX.equalTo(self.speedLabel);
		make.height.equalTo(@25);
	}];
}
	
- (void)initPauseBtn{
	_pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(_centerOriginX, _centerOriginY, 90, 90)];
	_pauseBtn.backgroundColor = AppStyleSetting.sharedInstance.mainColor;
	[_pauseBtn setImage:[UIImage imageNamed:@"pause_25#ff"] forState:UIControlStateNormal];
	[_pauseBtn addTarget:self action:@selector(pauseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	_pauseBtn.layer.cornerRadius = 45;
	_pauseBtn.clipsToBounds = YES;
	[_bottomBackgroundView addSubview:_pauseBtn];
}
	
- (void)initResumeBtn{
	_resumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.centerOriginX, self.centerOriginY, 90, 90)];
	_resumeBtn.backgroundColor = AppStyleSetting.sharedInstance.mainColor;
	[_resumeBtn setImage:[UIImage imageNamed:@"play_25#ff"] forState:UIControlStateNormal];
	[_resumeBtn addTarget:self action:@selector(resumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	_resumeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
	_resumeBtn.layer.cornerRadius = 45;
	_resumeBtn.clipsToBounds = YES;
	_resumeBtn.alpha = 0;
	[_bottomBackgroundView addSubview:_resumeBtn];
}
	
- (void)initStopBtn{
	_stopBtn = [[CircleProgressButton alloc] initWithFrame:CGRectMake(self.centerOriginX, self.centerOriginY, 90, 90)];
	[_stopBtn setProgressBtnBackgroundColor:[UIColor colorWithHexString:@"#e43e45"]];
	[_stopBtn setProgressColor:UIColor.whiteColor];
	__weak typeof(self) weakSelf = self;
	_stopBtn.longPressedBlock = ^{
		[weakSelf stopBtnClicked];
	};
	_stopBtn.alpha = 0;
	[_bottomBackgroundView addSubview:_stopBtn];
}

- (void)initCoverView{
	CGFloat centerX = self.view.center.x;
	CGFloat centerY = self.view.center.y;
	
	CGFloat oriCoverX = centerX - 500;
	CGFloat oriCoverY = centerY - 500;
	
	_coverView = [[UIView alloc] initWithFrame:CGRectMake(oriCoverX, oriCoverY, 1000, 1000)];
	_coverView.backgroundColor = AppStyleSetting.sharedInstance.homeNaviBarTintColor;
	_coverView.layer.cornerRadius = 500;
	_coverView.layer.masksToBounds = YES;
	[self.view addSubview:_coverView];
	
	CGFloat oriNumberX = 500 - 25;
	CGFloat oriNumberY = 500 - (self.view.frame.size.height/2) + 150;
	_numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(oriNumberX, oriNumberY, 50, 50)];
	_numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
	_numberLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_numberLabel.font = [UIFont systemFontOfSize:50 weight:UIFontWeightSemibold];
	_numberLabel.textAlignment = NSTextAlignmentCenter;
	_numberLabel.layer.opacity = 0;
	_numberLabel.opaque = NO;
	[_coverView addSubview:_numberLabel];
}

#pragma mark - Animation

- (void)showCountDownAnimation{
	if (_number <= 1) {
		[_animationTimer invalidate];
		_animationTimer = nil;
	}
	
	_numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
	_number--;
	
	CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(500, 500)];
	positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAni.toValue = [NSNumber numberWithFloat:1.0];
	opacityAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
	CATransform3D transform = CATransform3DMakeScale(4.0, 4.0, 1.0);
	scaleAni.toValue = [NSValue valueWithCATransform3D:transform];
	scaleAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CAAnimationGroup *group  = [CAAnimationGroup animation];
	if (_number == 0) {
		group.delegate = self;
		_finishCountDown = YES;
	}
	group.animations = @[positionAni, opacityAni, scaleAni];
	group.duration = 0.9;
	group.fillMode = kCAFillModeRemoved;
	group.removedOnCompletion = YES;
	
	[_numberLabel.layer addAnimation:group forKey:@"countdown"];
	
	if (_synthesizer != nil) {
		[_synthesizer speakSentence:_numberLabel.text withError:nil];
	}
}

- (void)showShrinkCoverAnimation{
	CGFloat oriX = self.view.frame.size.width / 2;
	CGFloat oriY = (self.view.frame.size.height - 200) + 35 + 45;
	
	CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(oriX, oriY)];
	positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
	CATransform3D transform = CATransform3DMakeScale(0.09, 0.09, 1.0);
	scaleAni.toValue = [NSValue valueWithCATransform3D:transform];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.delegate = self;
	group.animations = @[positionAni, scaleAni];
	group.duration = 0.5;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	
	[_coverView.layer addAnimation:group forKey:@"shrink"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	if (![anim isKindOfClass:CAAnimationGroup.class]) {
		return;
	}
	
	if (_finishCountDown) {
		_finishCountDown = NO;
		[self showShrinkCoverAnimation];
	}
	else{
		[_coverView removeFromSuperview];
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		_numberLabel = nil;
		_coverView = nil;
		// 第一次加载的时候默认开始
		if (_firstLoad) {
			_firstLoad = NO;
			[_timeCountingLabel start];
			[_locationManager startUpdatingLocation];
			[self startService];
		}
		if (_synthesizer != nil) {
			 [_synthesizer speakSentence:@"运动开始" withError:nil];
		}
	}
}

	
#pragma mark - Action

- (void)animationTimerIsCounting{
	[self showCountDownAnimation];
}

- (void)backBtnClicked:(UIButton*)sender{
	[self.navigationController popViewControllerAnimated:YES];
}
	
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
	// 创建类名是TrackRecord的AVObject
	_trackRecord = [AVObject objectWithClassName:@"TrackRecord"];
	// 获取定时器的时间
	double timeInterval = [_timeCountingLabel getTimeCounted];
	// 构造用时的NSString
	double minDouble = timeInterval / 60;
	int minFloor = floor(minDouble);
	int secRound = round(timeInterval - (minFloor * 60));
	if (secRound == 60) {
		minFloor += 1;
		secRound = 0;
	}
	// 用时String的format
	NSMutableString *formatString = [NSMutableString stringWithString:@"%d:%d"];
	if (minFloor < 10) {
		formatString = [NSMutableString stringWithString:@"0%d:%d"];
		
		if (secRound < 10) {
			formatString = [NSMutableString stringWithString:@"0%d:0%d"];
		}
	}
	else {
		if (secRound < 10) {
			formatString = [NSMutableString stringWithString:@"%d:0%d"];
		}
	}
	NSMutableString *minuteString = [NSMutableString stringWithFormat:formatString,minFloor, secRound];
	
	// 计算平均速度
	CLLocationSpeed avgSpeed = (_distance / 1000) / (minDouble / 60);
	// 计算卡路里量
	double calorie = 41 * _distance / 1000;
	// 计算碳排放量
	double carbon = 115 * _distance / 1000;
	// 计算配速的值
	double intervalKm = timeInterval / (_distance / 1000);
	// 构造配速的NSString
	int paceMinFloor = floor(intervalKm / 60);
	int paceSecRound = round(intervalKm - (paceMinFloor * 60));
	if (paceSecRound == 60){
		paceMinFloor += 1;
		paceSecRound = 0;
	}
	// 配速的Format
	NSMutableString *paceFormat = [NSMutableString stringWithString:@"%d':%d\""];
	if (paceSecRound < 10){
		paceFormat = [NSMutableString stringWithString:@"%d':0%d\""];
	}
	NSString *paceSpeedString = [NSString stringWithFormat:paceFormat, paceMinFloor, paceSecRound];
	// 获取年份，月份
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate:_startDate];
	NSInteger year = components.year;
	NSInteger month = components.month;
	// 设置AVObject的键值
	[_trackRecord setObject:[AVUser currentUser] forKey:@"user"];
	[_trackRecord setObject:_startDate forKey:@"startTime"];
	[_trackRecord setObject:_finishDate forKey:@"finishedTime"];
	[_trackRecord setObject:[NSNumber numberWithInteger:year] forKey:@"year"];
	[_trackRecord setObject:[NSNumber numberWithInteger:month] forKey:@"month"];
	[_trackRecord setObject:[NSNumber numberWithDouble:timeInterval] forKey:@"interval"];
	[_trackRecord setObject:minuteString forKey:@"minuteString"];
	[_trackRecord setObject:[NSNumber numberWithDouble:_distance] forKey:@"mileage"];
	[_trackRecord setObject:[NSNumber numberWithDouble: avgSpeed] forKey:@"avgSpeed"];
	[_trackRecord setObject:[NSNumber numberWithDouble:intervalKm] forKey:@"paceSpeed"];
	[_trackRecord setObject:paceSpeedString forKey:@"paceString"];
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
			TrackDetailViewController *detailVC = [[TrackDetailViewController alloc] initWithStartTime:self.startDate FinishedTime:self.finishDate TransportMode:self.transportMode TrackId:self.trackRecord.objectId openList:YES];
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
	
	if (_synthesizer != nil && !_mute) {
		[self playVoiceAlertWithType:10000];
	}
	
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.pauseBtn.alpha = 0;
		self.resumeBtn.frame = CGRectMake(self.resumeOriginX, self.resumeOriginY, 90, 90);
		self.stopBtn.frame = CGRectMake(self.stopOriginX, self.stopOriginY, 90, 90);
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
	
	if (_synthesizer != nil && !_mute) {
		[self playVoiceAlertWithType:20000];
	}
	
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.pauseBtn.alpha = 1;
		self.resumeBtn.alpha = 0;
		self.stopBtn.alpha = 0;
		self.resumeBtn.frame = CGRectMake(self.centerOriginX, self.centerOriginY, 90, 90);
		self.stopBtn.frame = CGRectMake(self.centerOriginX, self.centerOriginY, 90, 90);
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
	
	if (_distance < 100) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
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
	
	NSNumber *numDistance = [NSNumber numberWithDouble: floor(_distance / 1000)];
	
	if (_synthesizer == nil){
		return;
	}
	
	if ([_alertIntArray containsObject: numDistance]) {
		[_alertIntArray removeObject:numDistance];
		[self playVoiceAlertWithType: [numDistance integerValue]];
	}
	if (_targetDistance > 0 && _distance >= _targetDistance*1000 && !_alertDistance) {
		_alertDistance = YES;
		[self playDistanceVoiceAlert];
	}
}
	
- (void)refreshDisplayData{
	_distanceLabel.text = [NSString stringWithFormat:@"%.2f", _distance / 1000];
	_speedLabel.text = [NSString stringWithFormat:@"%.1f", _speed];
}

- (void)timerIsCounting{
	if (_synthesizer == nil) {
		[_timer invalidate];
		_timer = nil;
	}
	
	NSTimeInterval counted = [_timeCountingLabel getTimeCounted];
	if (_targetTime > 0 && counted >= _targetTime*60 && !_alertTime) {
		_alertTime = YES;
		[_timer invalidate];
		_timer = nil;
		
		if (_synthesizer == nil) {
			return;
		}
		
		[self playTimeVoiceAlert];
	}
}

- (void)playTimeVoiceAlert{
	int minute = _targetTime;
	NSString *paceString = [self calculateTargetTimeDistanceString];
	NSString *speechString = [NSString stringWithFormat:@"目标%d分钟已完成, %@", minute, paceString];
	[_synthesizer speakSentence:speechString withError:nil];
}

- (void)playDistanceVoiceAlert{
	long intDistance = _targetDistance;
	NSString *paceString = [self calculatePaceString];
	NSString *speechString = [NSString stringWithFormat:@"目标%ld公里已完成, %@", intDistance, paceString];
	[_synthesizer speakSentence:speechString withError:nil];
}

- (void)playIntegerKilometerAlert:(int)kilo{
	NSString *paceString = [self calculatePaceString];
	NSString *alertString = [NSString stringWithFormat:@"已完成%d公里, %@", kilo, paceString];
	[_synthesizer speakSentence:alertString withError:nil];
}

- (NSString*)calculatePaceString{
	int minute = 0;
	int second = 0;
	
	NSTimeInterval interval = [_timeCountingLabel getTimeCounted];
	double paceSpeed = interval / (_distance / 1000);
	minute = floor(paceSpeed/60);
	second = round(paceSpeed - (minute*60));
	
	int min = floor(interval/60);
	int sec = round(interval - (min*60));
	
	NSString *paceString = [NSString stringWithFormat:@"平均配速%d分%d秒, 用时%d分%d秒", minute, second, min, sec];
	return paceString;
}

- (NSString*)calculateTargetTimeDistanceString{
	int minute = 0;
	int second = 0;
	
	NSTimeInterval interval = [_timeCountingLabel getTimeCounted];
	double paceSpeed = interval / (_distance / 1000);
	minute = floor(paceSpeed/60);
	second = round(paceSpeed - (minute*60));
	
	NSString *distanceString = [NSString stringWithFormat:@"%.1f公里", (_distance / 1000)];
	NSString *paceString = [NSString stringWithFormat:@"平均配速%d分%d秒, 完成%@", minute, second, distanceString];
	return paceString;
}

/*
 根据语音提示的类型来播放语音提示
 0: 运动开始提示
 1～100: 公里整数提示
 10000: 运动暂停提示
 20000: 运动继续提示
 30000: 运动结束提示
 */
- (void)playVoiceAlertWithType:(NSInteger)type{
	switch (type) {
		case 0:
			[_synthesizer speakSentence:@"运动开始" withError:nil];
		break;
		case 10000:
			[_synthesizer speakSentence:@"运动暂停" withError:nil];
		break;
		case 20000:
			[_synthesizer speakSentence:@"运动继续" withError:nil];
		break;
		case 30000:
			[_synthesizer speakSentence:@"运动结束" withError:nil];
		break;
			
		default:
			if (_distance / 1000 > 0) {
				int intDistance = floor(_distance / 1000);
				[self playIntegerKilometerAlert:intDistance];
			}
			break;
	}
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
