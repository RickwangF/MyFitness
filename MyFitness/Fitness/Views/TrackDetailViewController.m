//
//  TrackDetailViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/11.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "TrackDetailViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduTraceSDK/BaiduTraceSDK.h>
#import "TransportModeEnum.h"
#import "AppStyleSetting.h"
#import "UIDevice+Type.h"
#import "NSString+NSDate.h"
#import "FitnessItemView.h"
#import "MFLocation.h"
#import "RegionInsets.h"
#import "ProjectConst.h"
#import "NSDate+NSString.h"
#import "UIColor+UIColor_Hex.h"
#import "UIDevice+Type.h"
#import "TrackListViewController.h"
#import "CounterViewController.h"

static NSString* const startLocIdentifier = @"startLoc";
static NSString* const stopLocIdentifier = @"stopLoc";

@interface TrackDetailViewController ()<BMKMapViewDelegate, BTKTrackDelegate>
	
@property (nonatomic, strong) BMKMapView *mapView;
	
@property (nonatomic, strong) BMKPolyline *trackLine;
	
@property (nonatomic, strong) CLLocation *beginLocation;
	
@property (nonatomic, strong) CLLocation *endLocation;
	
@property (nonatomic, strong) UIButton *backBtn;
	
@property (nonatomic, strong) UIView *bottomContainerView;
	
@property (nonatomic, strong) UIView *topInfoView;
	
@property (nonatomic, strong) UIView *bottomInfoView;
	
@property (nonatomic, strong) UILabel *transportModeLabel;
	
@property (nonatomic, strong) UIView *verticalSSeparator;
	
@property (nonatomic, strong) UILabel *avgSpeedLabel;
	
@property (nonatomic, strong) UILabel *startTimeLabel;
	
@property (nonatomic, strong) UIView *separatorView;
	
@property (nonatomic, strong) UILabel *distanceLabel;
	
@property (nonatomic, strong) FitnessItemView *minKmView;
	
@property (nonatomic, strong) FitnessItemView *durationView;
	
@property (nonatomic, strong) FitnessItemView *calorieView;
	
@property (nonatomic, strong) NSDate *startTime;
	
@property (nonatomic, strong) NSDate *finishedTime;
	
@property (nonatomic, assign) TransportModeEnum transportMode;
	
@property (nonatomic, strong) NSString *trackId;
	
// 存储从百度鹰眼服务查询到的轨迹点
@property (nonatomic, strong) NSMutableArray<CLLocation*>* locationArray;

@property (nonatomic, strong) AVObject *trackRecord;

// 存储准备添加到LeanCloud中的轨迹点数据
@property (nonatomic, strong) NSMutableArray<AVObject*> *trackPoints;

// 从LeanCloud获取到的轨迹点数据
@property (nonatomic, strong) NSMutableArray<MFLocation*> *mfLocations;

// 从百度鹰眼服务查询到的轨迹的距离
@property (nonatomic, assign) double distance;

// 轨迹点坐标的数组NSValue存储的CGPoint
@property (nonatomic, strong) NSMutableArray *coordinateArray;

// 轨迹点对应的颜色数组
@property (nonatomic, strong) NSMutableArray *colorArray;

// 轨迹点对应颜色的索引数组
@property (nonatomic, strong) NSMutableArray *colorIndexArray;

// 分段绘制轨迹时分段的起点和终点的颜色数组（会随时覆盖）
@property (nonatomic, strong) NSMutableArray *sectionColorArray;

// 绘制轨迹的计时器
@property (nonatomic, strong) NSTimer *timer;

// 绘制轨迹的起点坐标在轨迹点数组中的索引
@property (nonatomic, assign) NSInteger startIndex;

// 绘制轨迹的终点坐标在轨迹点数组中的索引
@property (nonatomic, assign) NSInteger endIndex;

// 绘制起点完成的标志
@property (nonatomic, assign) BOOL drawStartPointFlag;

// 绘制轨迹完成的标志
@property (nonatomic, assign) BOOL drawTrackFlag;

// 绘制终点完成的标志
@property (nonatomic, assign) BOOL drawEndPointFlag;

// 地图第一次完成绘制的标志
@property (nonatomic, assign) BOOL firstRendered;

// 打开里程页面的标志
@property (nonatomic, assign) BOOL openListFlag;

// 截图的矩形范围
@property (nonatomic, assign) CGRect snapRect;

@end

@implementation TrackDetailViewController
	
- (UIStatusBarStyle)preferredStatusBarStyle{
	return UIStatusBarStyleDefault;
}
	
#pragma  mark - Init
	
- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_startTime = [NSDate new];
		_finishedTime = [NSDate new];
		_transportMode = TransportModeWalking;
		_trackId = @"";
		_openListFlag = NO;
		[self initValueProperty];
		[self initTimer];
	}
	return self;
}
	
- (instancetype)initWithStartTime:(NSDate*)start FinishedTime:(NSDate*)finish TransportMode:(TransportModeEnum)mode TrackId:(NSString*)objectId{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_startTime = start;
		_finishedTime = finish;
		_transportMode = mode;
		_trackId = objectId;
		_openListFlag = NO;
		[self initValueProperty];
		[self initTimer];
	}
	return self;
}

- (instancetype)initWithStartTime:(NSDate*)start FinishedTime:(NSDate*)finish TransportMode:(TransportModeEnum)mode TrackId:(NSString*)objectId openList:(BOOL)open{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_startTime = start;
		_finishedTime = finish;
		_transportMode = mode;
		_trackId = objectId;
		_openListFlag = open;
		[self initValueProperty];
		[self initTimer];
	}
	return self;
}
	
- (void)initValueProperty{
	_locationArray = [[NSMutableArray alloc] init];
	_trackRecord = [AVObject new];
	_trackPoints = [[NSMutableArray alloc]init];
	_mfLocations = [[NSMutableArray alloc] init];
	_distance = 0;
	_coordinateArray = [[NSMutableArray alloc] init];
	_colorArray = [[NSMutableArray alloc]init];
	_colorIndexArray = [[NSMutableArray alloc] init];
	_sectionColorArray = [[NSMutableArray alloc] init];
	_drawStartPointFlag = NO;
	_drawTrackFlag = NO;
	_drawEndPointFlag = NO;
	_firstRendered = NO;
	_startIndex = 0;
	_endIndex = 0;
	_snapRect = CGRectZero;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"custom_map.json" ofType:@""];
	[BMKMapView customMapStyle:path];
}

-(void)initTimer{
	_timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(timerIsTicking) userInfo:nil repeats:YES];
}

#pragma mark - Life Circle
	
- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mainView.backgroundColor = [UIColor whiteColor];
	self.view = mainView;
}
	
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	
	[self initMapView];
	
	[self initBackBtn];
	
	[self initBottomContainerView];
	
	[self setUpTopInfoView];
	
	[self setUpBottomInfoView];
	
	[self getTrackRecord];
    // Do any additional setup after loading the view.
}
	
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[BMKMapView enableCustomMapStyle:YES];
	[_mapView viewWillAppear];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	if (_openListFlag){
		_openListFlag = NO;
		NSMutableArray *subViewControllers = [self.navigationController.viewControllers mutableCopy];
		if (subViewControllers != nil && subViewControllers.count > 1) {
			TrackListViewController *listVC = [[TrackListViewController alloc] init];
			CounterViewController *counterVC = subViewControllers[subViewControllers.count-2];
			if (counterVC != nil) {
				[subViewControllers removeObject:counterVC];
			}
			[subViewControllers insertObject:listVC atIndex:1];
			self.navigationController.viewControllers = subViewControllers;
		}
	}
}
	
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[_mapView viewWillDisappear];
	[BMKMapView enableCustomMapStyle:NO];
}

- (void)dealloc{
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}
	
#pragma mark - Init Views
	
- (void)initMapView{
	_mapView = [[BMKMapView alloc] initWithFrame: UIScreen.mainScreen.bounds];
	[self.view addSubview: _mapView];
	[_mapView setMapType:BMKMapTypeStandard];
	_mapView.delegate = self;
	_mapView.showsUserLocation = NO;
	_mapView.userTrackingMode = BMKUserTrackingModeNone;
	if ([[UIDevice currentDevice] fullScreen]) {
		_mapView.mapPadding = UIEdgeInsetsMake(10, 10, 210, 10);
	}
	else{
		_mapView.mapPadding = UIEdgeInsetsMake(10, 10, 200, 10);
	}
	
	_mapView.updateTargetScreenPtWhenMapPaddingChanged = YES;
	
	[_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

- (void)initBackBtn{
	_backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	_backBtn.layer.cornerRadius = 20;
	_backBtn.backgroundColor = [UIColor colorWithHexString:@"#d7d7d7"];
	[_backBtn setImage:[UIImage imageNamed:@"left_22#00"] forState:UIControlStateNormal];
	[_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
}
	
- (void)initBottomContainerView{
	CGFloat width = self.view.frame.size.width - 20;
	_bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 225)];
	_bottomContainerView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	_bottomContainerView.layer.cornerRadius = 5.0;
	_bottomContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_bottomContainerView];
	
	[_bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		if ([[UIDevice currentDevice] fullScreen]) {
			make.bottom.equalTo(self.view).offset(-25);
		}
		else{
			make.bottom.equalTo(self.view).offset(-10);
		}
		
		make.left.equalTo(self.view).offset(10);
		make.right.equalTo(self.view).offset(-10);
		make.height.equalTo(@225);
	}];
	
	_topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
	[_bottomContainerView addSubview:_topInfoView];
	[_topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.bottomContainerView.mas_top);
		make.left.right.equalTo(self.bottomContainerView);
		make.height.equalTo(@60);
	}];
	
	_separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
	_separatorView.backgroundColor = AppStyleSetting.sharedInstance.lightSeparatorColor;
	[_bottomContainerView addSubview:_separatorView];
	[_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.bottomContainerView).offset(60);
		make.left.right.equalTo(self.bottomContainerView);
		make.height.equalTo(@0.5);
	}];
	
	_bottomInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 165)];
	[_bottomContainerView addSubview:_bottomInfoView];
	[_bottomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.topInfoView.mas_bottom);
		make.left.bottom.right.equalTo(self.bottomContainerView);
	}];
}
	
- (void)setUpTopInfoView{
	_transportModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
	_transportModeLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_transportModeLabel.font = [UIFont systemFontOfSize:18];
	switch (_transportMode) {
		case TransportModeRunning:
		_transportModeLabel.text = @"跑步";
		break;
		case TransportModeWalking:
		_transportModeLabel.text = @"健走";
		break;
		case TransportModeRiding:
		_transportModeLabel.text = @"骑行";
		default:
		break;
	}
	[_topInfoView addSubview:_transportModeLabel];
	[_transportModeLabel sizeToFit];
	
	[_transportModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.topInfoView).offset(20);
		make.centerY.equalTo(self.topInfoView);
		make.height.equalTo(@20);
	}];
	
	_verticalSSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 12)];
	_verticalSSeparator.backgroundColor = AppStyleSetting.sharedInstance.separatorColor;
	[_topInfoView addSubview:_verticalSSeparator];
	
	[_verticalSSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.transportModeLabel.mas_right).offset(10);
		make.centerY.equalTo(self.topInfoView);
		make.width.equalTo(@0.5);
		make.height.equalTo(@12);
	}];
	
	_avgSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	_avgSpeedLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_avgSpeedLabel.font = [UIFont systemFontOfSize:16];
	_avgSpeedLabel.text = @"0km/h";
	[_topInfoView addSubview:_avgSpeedLabel];
	[_avgSpeedLabel sizeToFit];
	
	[_avgSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.verticalSSeparator.mas_right).offset(10);
		make.centerY.equalTo(self.topInfoView);
		make.height.equalTo(@20);
	}];
	
	_startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	_startTimeLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_startTimeLabel.font = [UIFont systemFontOfSize:14];
	_startTimeLabel.text = [NSString stringFromDate:_startTime];
	[_topInfoView addSubview:_startTimeLabel];
	[_startTimeLabel sizeToFit];
	
	[_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.topInfoView).offset(-20);
		make.centerY.equalTo(self.topInfoView);
		make.height.equalTo(@20);
	}];
}
	
- (void)setUpBottomInfoView{
	_distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
	_distanceLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_distanceLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
	_distanceLabel.text = @"0公里";
	[_bottomInfoView addSubview:_distanceLabel];
	
	[_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.bottomInfoView);
		make.top.equalTo(self.bottomInfoView).offset(30);
		make.height.equalTo(@40);
	}];
	
	CGFloat itemWidth = _bottomContainerView.frame.size.width / 3;
	_minKmView = [[FitnessItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 50)];
	[_minKmView setImage: [UIImage imageNamed:@"lightning_20#26da85"]];
	[_minKmView setItemName: @"平均配速"];
	[_minKmView setTitle:@"0'00\""];
	[_bottomInfoView addSubview:_minKmView];
	
	[_minKmView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.bottomInfoView);
		make.bottom.equalTo(self.bottomInfoView).offset(-30);
		make.width.equalTo(@(itemWidth));
		make.height.equalTo(@50);
	}];
	
	_durationView = [[FitnessItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 50)];
	[_durationView setImage: [UIImage imageNamed:@"clock_20#2e79fb"]];
	[_durationView setItemName: @"时长"];
	[_durationView setTitle:@"00:00"];
	[_durationView setSeparator];
	[_bottomInfoView addSubview:_durationView];
	
	[_durationView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.minKmView.mas_right);
		make.bottom.equalTo(self.bottomInfoView).offset(-30);
		make.width.equalTo(@(itemWidth));
		make.height.equalTo(@50);
	}];
	
	_calorieView = [[FitnessItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 50)];
	[_calorieView setImage: [UIImage imageNamed:@"fire_20#ec2c35"]];
	[_calorieView setItemName: @"卡路里"];
	[_calorieView setTitle:@"0"];
	[_bottomInfoView addSubview:_calorieView];
	
	[_calorieView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.durationView.mas_right);
		make.right.equalTo(self.bottomInfoView);
		make.bottom.equalTo(self.bottomInfoView).offset(-30);
		make.height.equalTo(@50);
	}];
}
	
#pragma mark - Request

// 从云平台获取保存的轨迹记录
- (void)getTrackRecord{
	AVQuery *query = [[AVQuery alloc] initWithClassName:@"TrackRecord"];
	[query includeKey:@"user"];
	[query includeKey:@"locationArray"];
	
	[query getObjectInBackgroundWithId:self.trackId block:^(AVObject * _Nullable object, NSError * _Nullable error) {
		if (error != nil) {
			[self.view makeToast:[NSString stringWithFormat:@"获取记录失败 ==> %@", error.localizedDescription]];
			return;
		}
		else{
			if (object == nil || object.objectId == nil) {
				[self.view makeToast:@"记录为空"];
				return;
			}
			
			NSArray *locations = [object objectForKey:@"locationArray"];
			self.trackRecord = object;
			
			// 更新轨迹的相关显示数据
			[self updateTopAndBottomInfoView];
			
			if (locations == nil || locations.count == 0) {
				[self queryHistoryTrack];
				return;
			}
			else{
				[locations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					NSDictionary *dic = obj;
					MFLocation *location = [MFLocation locationWithDictionary:dic];
					[self.mfLocations addObject:location];
					if (idx == 0) {
						CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitute, location.longitude);
						self.endLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude: location.altitude horizontalAccuracy:0 verticalAccuracy:0 course:location.course speed:location.speed timestamp: [NSDate dateFromString:location.timestamp]];
					}
					else if (idx == locations.count - 1) {
						CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitute, location.longitude);
						self.beginLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:location.altitude horizontalAccuracy:0 verticalAccuracy:0 course:location.course speed:location.speed timestamp:[NSDate dateFromString:location.timestamp]];
					}
				}];
				
				self.startIndex = self.mfLocations.count - 1;
				self.endIndex = self.mfLocations.count - 2;
				
				// 设置地图的显示范围
				[self mfLocationsToCoordinateArray];
				BMKCoordinateRegion region = [self minMaxRegionToCoordinateRegion];
				[self.mapView setRegion:region animated:YES];
			}
		}
	}];
}
	
- (void)queryHistoryTrack{
	BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
	// 不去噪
	option.denoise = NO;
	// 不绑路
	option.mapMatch = NO;
	// 不抽稀
	option.vacuate = NO;
	// 纠偏的定位精度阈值
	option.radiusThreshold = 5;
	// 设置运动方式
	switch (self.transportMode) {
		case TransportModeNone:
			option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;
			break;
		case TransportModeWalking:
			option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;
			break;
		case TransportModeRunning:
			option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;
			break;
		case TransportModeRiding:
			option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING;
			break;
	}
	
	// 使用以上选项同时不采用轨迹补偿的方式请求轨迹点
	BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:[AVUser currentUser].username startTime:[self.startTime timeIntervalSince1970] endTime:[self.finishedTime timeIntervalSince1970] isProcessed:YES processOption:option supplementMode:BTK_TRACK_PROCESS_OPTION_NO_SUPPLEMENT outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_DESC pageIndex:1 pageSize:300 serviceID:EagleEyeServiceID tag:2];
	
	[[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
}

// 插入从百度鹰眼轨迹获取的轨迹点数据
- (void)insertTrackPoints{
	if (_locationArray.count > 0) {
		
		if (_trackRecord == nil) {
			_trackRecord = [AVObject objectWithObjectId:self.trackId];
		}
		
		[_locationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			CLLocation *location = obj;
			AVObject *point = [AVObject objectWithClassName:@"MFLocation"];
			[point setObject:[AVUser currentUser] forKey:@"user"];
			[point setObject:self.trackRecord.objectId forKey:@"trackId"];
			[point setObject:[NSNumber numberWithDouble: location.coordinate.latitude] forKey:@"latitude"];
			[point setObject:[NSNumber numberWithDouble: location.coordinate.longitude] forKey:@"longitude"];
			[point setObject:[NSNumber numberWithDouble: location.altitude] forKey:@"altitude"];
			[point setObject:[NSNumber numberWithDouble: location.course] forKey:@"course"];
			[point setObject:[NSNumber numberWithDouble: location.speed] forKey:@"speed"];
			[point setObject:location.timestamp forKey:@"timestamp"];
			[self.trackPoints addObject:point];
		}];
		
		[AVObject saveAllInBackground:self.trackPoints block:^(BOOL succeeded, NSError * _Nullable error) {
			if (succeeded) {
				[self.view makeToast:@"插入轨迹点成功"];
				[self saveTrackRecordLocationArray];
			}
			else{
				if (error != nil) {
					[self.view makeToast:[NSString stringWithFormat:@"保存轨迹点失败 ==> %@", error.localizedDescription]];
					return;
				}
				
				[self.view makeToast:@"保存轨迹失败"];
			}
		}];
	}
}

// 更新轨迹记录和轨迹点的关联关系
- (void)saveTrackRecordLocationArray{
	[_trackRecord setObject:self.trackPoints forKey:@"locationArray"];
	[_trackRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
		if (succeeded) {
			[self.view makeToast:@"保存轨迹点关联成功"];
		}
		else{
			if (error != nil) {
				[self.view makeToast:[NSString stringWithFormat:@"保存轨迹点关联失败 ==> %@", error.localizedDescription]];
				return;
			}
			
			[self.view makeToast:@"保存轨迹点关联失败"];
		}
	}];
}
	
#pragma mark - Action

- (void)backBtnClicked:(UIButton*)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)calculateSnapRect{
	CGFloat height = 0;
	CGFloat width = self.view.frame.size.width;
	CGFloat y = 0;
	if ([[UIDevice currentDevice] fullScreen]){
		height = self.view.frame.size.height - 250;
		y = 44;
	}
	else{
		height = self.view.frame.size.height - 235;
		y = 20;
	}
	_snapRect = CGRectMake(0, y, width, height);
}

- (void)saveSnapImage{
	[self calculateSnapRect];
	
	UIImage *snapImage = [_mapView takeSnapshot:_snapRect];
	NSData *data = UIImageJPEGRepresentation(snapImage, 0.8);
	AVFile *file = [AVFile fileWithData:data];
	
	[file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
		if (error != nil) {
			[self.view makeToast:error.localizedDescription];
		}
		else{
			[self.trackRecord setObject:file.objectId forKey:@"imageId"];
			[self.trackRecord setObject:file.url forKey:@"imageUrl"];
			[self.trackRecord saveInBackground];
		}
	}];
}
	
- (void)locationArrayToCoordinateArray{
	if (self.locationArray != nil && self.locationArray.count > 0) {
		
		[self.locationArray enumerateObjectsUsingBlock:^(CLLocation * _Nonnull location, NSUInteger idx, BOOL * _Nonnull stop) {
			
			CGPoint point = CGPointMake(location.coordinate.latitude, location.coordinate.longitude);
			NSValue *value = [NSValue valueWithCGPoint:point];
			[self.coordinateArray addObject:value];
			
			CGFloat speed = location.speed;
			UIColor *speedColor = [UIColor colorWithRed:(speed*6.375f)/255 green:1.0 blue:70.f/255 alpha:1.0];
			[self.colorArray addObject:speedColor];
			
			[self.colorIndexArray addObject:[NSNumber numberWithInt:(int)idx]];
		}];
	}
}

- (void)mfLocationsToCoordinateArray{
	if (self.mfLocations != nil && self.mfLocations.count > 0) {
		
		[self.mfLocations enumerateObjectsUsingBlock:^(MFLocation * _Nonnull location, NSUInteger idx, BOOL * _Nonnull stop) {
			
			CGPoint point = CGPointMake(location.latitute, location.longitude);
			NSValue *value = [NSValue valueWithCGPoint:point];
			[self.coordinateArray addObject:value];
			
			CGFloat speed = location.speed;
			UIColor *speedColor = [UIColor colorWithRed:(speed*6.375f)/255 green:1.0 blue:70.f/255 alpha:1.0];
			[self.colorArray addObject:speedColor];
			
			[self.colorIndexArray addObject:[NSNumber numberWithInt:(int)idx]];
		}];
	}
}

- (RegionInsets)getMinMaxRegionCoordinate{
	if (self.coordinateArray != nil && self.coordinateArray.count > 0){
		CGFloat minLat, minLon, maxLat, maxLon;
		NSValue *beginValue = self.coordinateArray[0];
		CGPoint point = beginValue.CGPointValue;
		minLat = point.x;
		maxLat = point.x;
		minLon = point.y;
		maxLon = point.y;
		
		for (NSValue *value in self.coordinateArray) {
			CGPoint point = value.CGPointValue;
			CGFloat latitude = point.x;
			CGFloat longitude = point.y;
			
			if (latitude < minLat) {
				minLat = latitude;
			}
			if (latitude > maxLat) {
				maxLat = latitude;
			}
			if (longitude < minLon) {
				minLon = longitude;
			}
			if (longitude > maxLon) {
				maxLon = longitude;
			}
		}
		
		return RegionInsetsMake(minLat, minLon, maxLat, maxLon);
	}
	return RegionInsetsMake(0, 0, 0, 0);
}

- (BMKCoordinateRegion)minMaxRegionToCoordinateRegion{
	RegionInsets regionInsets = [self getMinMaxRegionCoordinate];
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake((regionInsets.maxLatitude + regionInsets.minLatitude)/2, (regionInsets.maxLongitude+regionInsets.minLongitude)/2);
	CLLocationDegrees latitudeOffset = fabs(center.latitude - regionInsets.minLatitude)*2 + 0.03;
	CLLocationDegrees longitudeOffset = fabs(center.longitude-regionInsets.minLongitude)*2 + 0.03;
	BMKCoordinateSpan span = {latitudeOffset, longitudeOffset};
	BMKCoordinateRegion region = {center, span};
	return region;
}

- (void)updateTopAndBottomInfoView{
	if (_trackRecord.objectId == nil || [_trackRecord.objectId isEqualToString:@""]){
		[self.view makeToast:@"没有轨迹的具体信息"];
		return;
	}
	
	double mileage = [[_trackRecord objectForKey:@"mileage"] doubleValue];
	double kmHSpeed = [[_trackRecord objectForKey:@"avgSpeed"] doubleValue];
	NSString *duration = [_trackRecord objectForKey:@"minuteString"];
	double calorie = [[_trackRecord objectForKey:@"calorie"] doubleValue];
	
	NSString *speedString = [NSString stringWithFormat:@"%.1fkm/h", kmHSpeed];
	NSString *distanceString = [NSString stringWithFormat:@"%.1f公里", mileage / 1000];
	NSString *minKmString = [_trackRecord objectForKey:@"paceString"];
	NSString *calorieString = [NSString stringWithFormat:@"%d", (int)calorie];
	
	_avgSpeedLabel.text = speedString;
	_distanceLabel.text = distanceString;
	[_minKmView setTitle:minKmString];
	[_durationView setTitle:duration];
	[_calorieView setTitle:calorieString];
}

- (void)timerIsTicking{
	if (!_drawStartPointFlag) {
		_drawStartPointFlag = YES;
		[self drawStartPoint];
		return;
	}
	if (!_drawTrackFlag) {
		if(_endIndex == 0 && _startIndex == 1){
			_drawTrackFlag = YES;
		}
		[self drawTrack];
		return;
	}
	if (!_drawEndPointFlag) {
		_drawEndPointFlag = YES;
		[self drawEndPoint];
		return;
	}
	if (_drawStartPointFlag && _drawTrackFlag && _drawEndPointFlag) {
		[self drawTrackLine];
		[_timer invalidate];
		_timer = nil;
	}
}

#pragma mark - Draw

- (void)drawStartPoint{
	if (self.beginLocation != nil) {
		BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
		annotation.coordinate = self.beginLocation.coordinate;
		annotation.title = @"起点";
		[self.mapView addAnnotation:annotation];
	}
}

- (void)drawTrack{
	CLLocationCoordinate2D array[2];
	CLLocationCoordinate2D startPoint = {};
	CLLocationCoordinate2D endPoint = {};
	UIColor *startColor = [UIColor new];
	UIColor *endColor = [UIColor new];
	
	if ( _mfLocations.count > 0) {
		MFLocation *startLoc = _mfLocations[self.startIndex];
		MFLocation *endLoc = _mfLocations[self.endIndex];
		
		startPoint = CLLocationCoordinate2DMake(startLoc.latitute, startLoc.longitude);
		endPoint = CLLocationCoordinate2DMake(endLoc.latitute, endLoc.longitude);
		
		startColor = [UIColor colorWithRed:(startLoc.speed*6.375)/255 green:1.0 blue:70.0/255 alpha:1.0];
		endColor = [UIColor colorWithRed:(endLoc.speed*6.375)/255 green:1.0 blue:70.0/255 alpha:1.0];
	}
	else if (_locationArray.count > 0) {
		CLLocation *startLoc = _locationArray[_startIndex];
		CLLocation *endLoc = _locationArray[_endIndex];
		
		startPoint = CLLocationCoordinate2DMake(startLoc.coordinate.latitude, startLoc.coordinate.longitude);
		endPoint = CLLocationCoordinate2DMake(endLoc.coordinate.latitude, endLoc.coordinate.longitude);
		
		startColor = [UIColor colorWithRed:(startLoc.speed*6.375)/255 green:1.0 blue:70.0/255 alpha:1.0];
		endColor = [UIColor colorWithRed:(endLoc.speed*6.375)/255 green:1.0 blue:70.0/255 alpha:1.0];
	}
	
	array[0] = startPoint;
	array[1] = endPoint;
	self.sectionColorArray = [NSMutableArray arrayWithObjects:startColor,endColor, nil];
	
	BMKPolyline *line = [BMKPolyline polylineWithCoordinates:array count:2 textureIndex:@[[NSNumber numberWithInt:0], [NSNumber numberWithInt:1]]];
	
	[self.mapView addOverlay:line];
	[self mapView:self.mapView viewForOverlay:line];
	
	self.endIndex--;
	self.startIndex--;
}

- (void)drawEndPoint{
	if (self.endLocation != nil) {
		BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
		annotation.coordinate = self.endLocation.coordinate;
		annotation.title = @"终点";
		[self.mapView addAnnotation:annotation];
	}
}

// 从鹰眼获取的轨迹点绘制轨迹
- (void)drawTrackLine{
	NSInteger count = 0;
	if (self.locationArray.count > 0){
		count = self.locationArray.count;
	}
	else if (self.mfLocations.count > 0) {
		count = self.mfLocations.count;
	}
	
	CLLocationCoordinate2D array[count];
	int index = 0;
	
	if(self.locationArray.count > 0){
		for (CLLocation *location in self.locationArray) {
			CLLocationCoordinate2D coordinate = location.coordinate;
			array[index] = coordinate;
			index++;
		}
	}
	else if (self.mfLocations.count > 0) {
		for (MFLocation* location in self.mfLocations) {
			CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitute, location.longitude);
			array[index] = coordinate;
			index++;
		}
	}
	
	if (self.trackLine != nil) {
		[self.mapView removeOverlay:self.trackLine];
	}
	
	self.trackLine = [BMKPolyline polylineWithCoordinates:array count:count textureIndex:self.colorIndexArray];
	[self.mapView addOverlay:self.trackLine];
	[self mapView:self.mapView viewForOverlay:self.trackLine];
}
	
#pragma mark - BMKMapViewDelegate

// 初次渲染完成之后就开始绘制起点，轨迹和终点
- (void)mapViewDidFinishRendering:(BMKMapView *)mapView{
	if (!_firstRendered && ((_mfLocations.count > 0) || (_locationArray.count > 0))) {
		
		_firstRendered = YES;
		// 开始绘制起点，轨迹和终点
		[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
	}
	else if (_mfLocations.count == 0 || _locationArray.count == 0){
		[_timer invalidate];
		_timer = nil;
	}
}

// 设置起点和终点标记的样式
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
	
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *annoView;
		if ([annotation.title isEqualToString:@"起点"]) {
			annoView = (BMKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:startLocIdentifier];
			
			if (annoView == nil) {
				annoView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:startLocIdentifier];
			}
			
			annoView.image = [UIImage imageNamed:@"start_34#blue"];
			annoView.canShowCallout = YES;
			annoView.draggable = NO;
		}
		else{
			annoView = (BMKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:stopLocIdentifier];
			
			if (annoView == nil) {
				annoView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:stopLocIdentifier];
			}
			
			annoView.image = [UIImage imageNamed:@"end_34#red"];
			annoView.canShowCallout = YES;
			annoView.draggable = NO;
		}
		return annoView;
	}
	return nil;
}

// 设置轨迹的样式
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
		BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
		// 设置路径颜色为单色
		// polylineView.strokeColor = [UIColor redColor];
		// 设置路径颜色为多色，分段绘制时采用分段的颜色，整体绘制时采用整体的颜色
		if (self.drawEndPointFlag) {
			polylineView.colors = self.colorArray;
		}
		else{
			polylineView.colors = self.sectionColorArray;
		}
		
		polylineView.lineWidth = 3.0;
		return polylineView;
	}
	return nil;
}

// 已经添加完轨迹的回调
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{
	if (_trackLine != nil) {
		NSString *urlString = [_trackRecord objectForKey:@"imageUrl"];
		
		if (urlString == nil || [urlString isEqualToString:@""]) {
			[self saveSnapImage];
		}
	}
}
	
#pragma mark - BTKTrackDelegate

- (void)onQueryHistoryTrack:(NSData *)response{
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
	
	if (dic == nil) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.view makeToast:@"Entity List查询格式转换出错"];
		});
		return;
	}
	
	if ([[dic objectForKey:@"status"] intValue]!= 0) {
		
		if ([dic objectForKey:@"message"] != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.view makeToast: (NSString*)[dic objectForKey:@"message"]];
			});
		}
		else{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.view makeToast:@"轨迹查询返回错误"];
			});
		}
		return;
	}
	
	NSArray *array = dic[@"points"];
	if (array == nil) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.view makeToast:@"没有获取到相关的轨迹定位点"];
		});
		return;
	}
	
	if (array.count < 5) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.view makeToast:@"没有足够的轨迹点可供绘制"];
		});
		return;
	}
	
	[array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		NSDictionary *point = obj;
		double latitude = [point[@"latitude"] doubleValue];
		double longitude = [point[@"longitude"] doubleValue];
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		double altitide = [point[@"height"] doubleValue];
		double horizontalAccuracy = [point[@"radius"] doubleValue];
		double course = [point[@"direction"] doubleValue];
		double speed = [point[@"speed"] doubleValue];
		double loctime = [point[@"loc_time"] doubleValue];
		NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:loctime];
		CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:altitide horizontalAccuracy:horizontalAccuracy verticalAccuracy:0 course: course speed:speed timestamp:timestamp];
		[self.locationArray addObject:location];
		
		if (idx == 0) {
			self.endLocation = location;
		}
		else if (idx == array.count - 1) {
			self.beginLocation = location;
		}
	}];
	
	self.startIndex = self.locationArray.count - 1;
	self.endIndex = self.locationArray.count - 2;
	// 插入轨迹点数组到云平台
	[self insertTrackPoints];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		// 设置地图的显示范围
		[self locationArrayToCoordinateArray];
		BMKCoordinateRegion region = [self minMaxRegionToCoordinateRegion];
		[self.mapView setRegion:region animated:YES];
	});
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
