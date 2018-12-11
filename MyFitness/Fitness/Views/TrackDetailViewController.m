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
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduTraceSDK/BaiduTraceSDK.h>
#import "TransportModeEnum.h"
#import "AppStyleSetting.h"
#import "UIDevice+Type.h"
#import "NSString+NSDate.h"
#import "FitnessItemView.h"

@interface TrackDetailViewController ()<BMKMapViewDelegate, BTKTrackDelegate>
	
@property (nonatomic, strong) BMKMapView *mapView;
	
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
	
@property (nonatomic, strong) NSDate *finishTime;
	
@property (nonatomic, assign) TransportModeEnum transportMode;
	
@property (nonatomic, strong) NSString *trackId;

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
		_finishTime = [NSDate new];
		_transportMode = TransportModeRunning;
		_trackId = @"";
		[self initValueProperty];
	}
	return self;
}
	
- (instancetype)initWithStartTime:(NSDate*)start FinishTime:(NSDate*)finish TransportMode:(TransportModeEnum)mode TrackId:(NSString*)objectId{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_startTime = start;
		_finishTime = finish;
		_transportMode = mode;
		_trackId = objectId;
		[self initValueProperty];
	}
	return self;
}
	
- (void)initValueProperty{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"map_config.json" ofType:@""];
	[BMKMapView customMapStyle:path];
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
	
	[self initMapView];
	
	[self initBottomContainerView];
	
	[self setUpTopInfoView];
	
	[self setUpBottomInfoView];
    // Do any additional setup after loading the view.
}
	
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}
	
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}
	
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[BMKMapView enableCustomMapStyle:NO];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}
	
#pragma mark - Init Views
	
- (void)initMapView{
	_mapView = [[BMKMapView alloc] initWithFrame: UIScreen.mainScreen.bounds];
	[self.view addSubview: _mapView];
	[BMKMapView enableCustomMapStyle:YES];
	[_mapView setMapType:BMKMapTypeStandard];
	_mapView.delegate = self;
	_mapView.showsUserLocation = NO;
	_mapView.userTrackingMode = BMKUserTrackingModeNone;
	_mapView.mapPadding = UIEdgeInsetsMake(10, 10, 200, 10);
	_mapView.updateTargetScreenPtWhenMapPaddingChanged = YES;
	
	[_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}
	
- (void)initBottomContainerView{
	CGFloat width = self.view.frame.size.width - 20;
	_bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 225)];
	_bottomContainerView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	_bottomContainerView.layer.cornerRadius = 5.0;
	_bottomContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_bottomContainerView];
	
	[_bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-10);
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
	_avgSpeedLabel.text = @"10.1km/h";
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
	_distanceLabel.text = @"5.1公里";
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
	[_minKmView setTitle:@"5'35\""];
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
	[_durationView setTitle:@"28:35"];
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
	[_calorieView setTitle:@"310"];
	[_bottomInfoView addSubview:_calorieView];
	
	[_calorieView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.durationView.mas_right);
		make.right.equalTo(self.bottomInfoView);
		make.bottom.equalTo(self.bottomInfoView).offset(-30);
		make.height.equalTo(@50);
	}];
}
	
#pragma mark - Request
	
	
	
#pragma mark - Action
	
	
	
#pragma mark - BMKMapViewDelegate
	
#pragma mark - BTKTrackDelegate
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
