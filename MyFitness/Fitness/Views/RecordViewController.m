//
//  RecordViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/21.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "RecordViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <Charts/Charts-Swift.h>
#import "AppStyleSetting.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TrackRecord.h"
#import "NSString+NSDate.h"
#import "UIImage+UIColor.h"
#import "UIColor+UIColor_Hex.h"

@interface RecordViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIView *firstContainerView;

@property (nonatomic, strong) BarChartView *last7DaysView;

@property (nonatomic, strong) UIView *secondContainerView;

@property (nonatomic, strong) HorizontalBarChartView *longestView;

@property (nonatomic, strong) UIView *thirdContainerView;

@property (nonatomic, strong) HorizontalBarChartView *fastestView;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (nonatomic, strong) NSMutableArray *longestArray;

@property (nonatomic, strong) NSMutableArray *paceArray;

@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) NSDate *last7Day;

@property (nonatomic, strong) NSMutableArray *dayArray;

@end

@implementation RecordViewController

#pragma mark - Init

- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (void)initValueProperty{
	_trackArray = [NSMutableArray new];
	_longestArray = [NSMutableArray new];
	_paceArray = [NSMutableArray new];
	_today = [NSDate date];
	_last7Day = [NSDate new];
	_dayArray = [NSMutableArray new];
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
	self.title = @"我的记录";
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	
	[self initMainScrollView];
	
	[self constructTimeSpan];
	
	[self initLastSevenDaysView];
	
	[self initLongestView];
	
	[self initFastestView];
	
	[self getAllMyTrackRecords];
    // Do any additional setup after loading the view.
}

#pragma mark - Init View

- (void)initMainScrollView{
	_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
	_mainScrollView.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
	if (@available(iOS 11.0, *)) {
		_mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	_mainScrollView.directionalLockEnabled = YES;
	_mainScrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_mainScrollView];
	
	[_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)){
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.bottom.right.equalTo(self.view);
	}];
}

- (void)initLastSevenDaysView{
	_firstContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345, 260)];
	_firstContainerView.backgroundColor = UIColor.whiteColor;
	_firstContainerView.layer.cornerRadius = 5;
	_firstContainerView.layer.masksToBounds = YES;
	[self.mainScrollView addSubview:_firstContainerView];
	
	[_firstContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mainScrollView).offset(15);
		make.left.equalTo(self.mainScrollView).offset(15);
		make.right.equalTo(self.mainScrollView).offset(-15);
		make.width.equalTo(@(self.view.frame.size.width - 30));
		make.height.equalTo(@260);
	}];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
	titleLabel.text = @"最近7天";
	titleLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	titleLabel.font = [UIFont systemFontOfSize:15];
	[_firstContainerView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView).offset(15);
		make.centerX.equalTo(self.firstContainerView);
		make.height.equalTo(@18);
	}];
	
	_last7DaysView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, 315, 260)];
	_last7DaysView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	[_last7DaysView setNoDataText:@"正在飞速计算中，请稍后...."];
	_last7DaysView.chartDescription.enabled = NO;
	_last7DaysView.drawGridBackgroundEnabled = YES;
	[_last7DaysView setDrawGridBackgroundEnabled:NO];
	_last7DaysView.dragEnabled = NO;
	[_last7DaysView setScaleEnabled:NO];
	_last7DaysView.pinchZoomEnabled = NO;
	_last7DaysView.rightAxis.enabled = NO;
	_last7DaysView.drawBarShadowEnabled = NO;
	_last7DaysView.drawValueAboveBarEnabled = YES;
	_last7DaysView.maxVisibleCount = 7;
	
	NSNumberFormatter *yAxisFormatter = [[NSNumberFormatter alloc] init];
	yAxisFormatter.minimumFractionDigits = 0;
	yAxisFormatter.maximumFractionDigits = 0;
	yAxisFormatter.negativeSuffix = @"km";
	yAxisFormatter.positiveSuffix = @"km";
	
	ChartXAxis *xAxis = _last7DaysView.xAxis;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.labelFont = [UIFont systemFontOfSize:12];
	xAxis.drawGridLinesEnabled = YES;
	xAxis.gridColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	xAxis.granularity = 1;
	xAxis.labelCount = 7;
	xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithDecimals:0];
	
	ChartYAxis *yAxis = _last7DaysView.leftAxis;
	yAxis.enabled = YES;
	yAxis.drawGridLinesEnabled = YES;
	yAxis.gridColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	yAxis.labelFont = [UIFont systemFontOfSize:12];
	yAxis.labelCount = 6;
	yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:yAxisFormatter];
	yAxis.labelPosition = YAxisLabelPositionOutsideChart;
	yAxis.spaceTop = 0.1;
	yAxis.axisMinimum = 0;
	
	[_firstContainerView addSubview:_last7DaysView];
	[_last7DaysView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView).offset(40);
		make.left.equalTo(self.firstContainerView).offset(15);
		make.right.equalTo(self.firstContainerView).offset(-15);
		make.height.equalTo(@200);
	}];
	
	UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 12)];
	xAxisLabel.text = @"日期";
	xAxisLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	xAxisLabel.font = [UIFont systemFontOfSize:10];
	[_firstContainerView addSubview:xAxisLabel];
	[xAxisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.firstContainerView).offset(-45);
		make.bottom.equalTo(self.firstContainerView).offset(-27);
		make.height.equalTo(@12);
	}];
}

- (void)initLongestView{
	_secondContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345, 260)];
	_secondContainerView.backgroundColor = UIColor.whiteColor;
	_secondContainerView.layer.cornerRadius = 5;
	_secondContainerView.layer.masksToBounds = YES;
	[self.mainScrollView addSubview:_secondContainerView];
	
	[_secondContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView.mas_bottom).offset(15);
		make.left.equalTo(self.mainScrollView).offset(15);
		make.right.equalTo(self.mainScrollView).offset(-15);
		make.width.equalTo(@(self.view.frame.size.width - 30));
		make.height.equalTo(@260);
	}];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
	titleLabel.text = @"最远里程";
	titleLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	titleLabel.font = [UIFont systemFontOfSize:15];
	[_secondContainerView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.secondContainerView).offset(15);
		make.centerX.equalTo(self.secondContainerView);
		make.height.equalTo(@18);
	}];
	
	_longestView = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(0, 0, 315, 200)];
	_longestView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	[_longestView setNoDataText:@"正在飞速计算中，请稍后...."];
	_longestView.chartDescription.enabled = NO;
	_longestView.drawGridBackgroundEnabled = YES;
	[_longestView setDrawGridBackgroundEnabled:NO];
	_longestView.dragEnabled = NO;
	[_longestView setScaleEnabled:NO];
	_longestView.pinchZoomEnabled = NO;
	_longestView.rightAxis.enabled = NO;
	_longestView.drawBarShadowEnabled = NO;
	_longestView.drawValueAboveBarEnabled = YES;
	_longestView.maxVisibleCount = 5;
	
	NSNumberFormatter *yAxisFormatter = [[NSNumberFormatter alloc] init];
	yAxisFormatter.minimumFractionDigits = 0;
	yAxisFormatter.maximumFractionDigits = 0;
	yAxisFormatter.negativeSuffix = @"km";
	yAxisFormatter.positiveSuffix = @"km";
	
	ChartXAxis *xAxis = _longestView.xAxis;
	xAxis.drawLabelsEnabled = NO;
	xAxis.drawAxisLineEnabled = YES;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.drawGridLinesEnabled = YES;
	xAxis.gridColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	xAxis.granularity = 1;
	xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] init];
	
	ChartYAxis *leftAxis = _longestView.leftAxis;
	leftAxis.enabled = NO;
	
	ChartYAxis *yAxis = _longestView.rightAxis;
	yAxis.enabled = YES;
	yAxis.drawGridLinesEnabled = YES;
	yAxis.gridColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	yAxis.labelFont = [UIFont systemFontOfSize:12];
	yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:yAxisFormatter];
	yAxis.labelPosition = YAxisLabelPositionOutsideChart;
	yAxis.axisMinimum = 0;
	
	ChartLegend *legend = [_longestView legend];
	legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
	legend.verticalAlignment = ChartLegendVerticalAlignmentTop;
	legend.xOffset = -8;
	
	[_secondContainerView addSubview:_longestView];
	[_longestView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.secondContainerView).offset(40);
		make.left.equalTo(self.secondContainerView).offset(15);
		make.right.equalTo(self.secondContainerView).offset(-15);
		make.height.equalTo(@200);
	}];
}

- (void)initFastestView{
	_thirdContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345, 260)];
	_thirdContainerView.backgroundColor = UIColor.whiteColor;
	_thirdContainerView.layer.cornerRadius = 5;
	_thirdContainerView.layer.masksToBounds = YES;
	[self.mainScrollView addSubview:_thirdContainerView];
	
	[_thirdContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.secondContainerView.mas_bottom).offset(15);
		make.left.equalTo(self.mainScrollView).offset(15);
		make.right.equalTo(self.mainScrollView).offset(-15);
		make.width.equalTo(@(self.view.frame.size.width - 30));
		make.height.equalTo(@260);
		make.bottom.equalTo(self.mainScrollView).offset(-15);
	}];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
	titleLabel.text = @"最快配速";
	titleLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	titleLabel.font = [UIFont systemFontOfSize:15];
	[_thirdContainerView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.thirdContainerView).offset(15);
		make.centerX.equalTo(self.thirdContainerView);
		make.height.equalTo(@18);
	}];
	
	_fastestView = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(0, 0, 315, 200)];
	_fastestView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	[_fastestView setNoDataText:@"正在飞速计算中，请稍后...."];
	_fastestView.chartDescription.enabled = NO;
	_fastestView.drawGridBackgroundEnabled = YES;
	[_fastestView setDrawGridBackgroundEnabled:NO];
	_fastestView.dragEnabled = NO;
	[_fastestView setScaleEnabled:NO];
	_fastestView.pinchZoomEnabled = NO;
	_fastestView.rightAxis.enabled = NO;
	_fastestView.drawBarShadowEnabled = NO;
	_fastestView.drawValueAboveBarEnabled = YES;
	_fastestView.maxVisibleCount = 5;
	
	NSNumberFormatter *yAxisFormatter = [[NSNumberFormatter alloc] init];
	yAxisFormatter.minimumFractionDigits = 0;
	yAxisFormatter.maximumFractionDigits = 0;
	yAxisFormatter.negativeSuffix = @"km/h";
	yAxisFormatter.positiveSuffix = @"km/h";
	
	ChartXAxis *xAxis = _fastestView.xAxis;
	xAxis.drawLabelsEnabled = NO;
	xAxis.drawAxisLineEnabled = YES;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.drawGridLinesEnabled = YES;
	xAxis.gridColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	xAxis.granularity = 1;
	xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] init];
	
	ChartYAxis *leftAxis = _fastestView.leftAxis;
	leftAxis.enabled = NO;
	
	ChartYAxis *yAxis = _fastestView.rightAxis;
	yAxis.enabled = YES;
	yAxis.drawGridLinesEnabled = YES;
	yAxis.gridColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	yAxis.labelFont = [UIFont systemFontOfSize:12];
	yAxis.labelCount = 4;
	yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:yAxisFormatter];
	yAxis.labelPosition = YAxisLabelPositionOutsideChart;
	yAxis.axisMinimum = 0;
	
	ChartLegend *legend = [_fastestView legend];
	legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
	legend.verticalAlignment = ChartLegendVerticalAlignmentTop;
	legend.xOffset = -8;
	
	[_thirdContainerView addSubview:_fastestView];
	[_fastestView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.thirdContainerView).offset(40);
		make.left.equalTo(self.thirdContainerView).offset(15);
		make.right.equalTo(self.thirdContainerView).offset(-15);
		make.height.equalTo(@200);
	}];
}

#pragma mark - Action

- (void)constructTimeSpan{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_today];
	NSDate *todayEarly = [calendar dateFromComponents:components];
	_today = [todayEarly dateByAddingTimeInterval:(23*60*60+59*60+59)];
	_last7Day = [todayEarly dateByAddingTimeInterval:-(6*24*60*60)];
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	format.dateFormat = @"dd";
	for (int i=6; i>=0; i--) {
		@autoreleasepool {
			NSDate *date = [todayEarly dateByAddingTimeInterval:(-i * (24*60*60))];
			NSInteger day = [[format stringFromDate:date] integerValue];
			[_dayArray addObject:@(day)];
		}
	}
}

- (void)constructLastSevenDaysData{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.finishedTime <= %@ && SELF.startTime >= %@", _today, _last7Day];
	NSArray* last7DayRecords = [_trackArray filteredArrayUsingPredicate:predicate];
	NSDate *beginDate = _last7Day;
	NSMutableArray *sevenDaysRecord = [[NSMutableArray alloc] init];
	for (int i = 0; i<=6; i++) {
		@autoreleasepool {
			NSTimeInterval interval = 24*60*60;
			NSDate *endDate = [beginDate dateByAddingTimeInterval:interval];
			NSPredicate *predication = [NSPredicate predicateWithFormat:@"SELF.finishedTime <= %@ && SELF.startTime >= %@", endDate, beginDate];
			NSArray *recordArray = [last7DayRecords filteredArrayUsingPredicate:predication];
			double mileage = 0;
			if (recordArray != nil && recordArray.count > 0) {
				for (TrackRecord *record in recordArray) {
					mileage += record.mileage;
				}
			}
			mileage = [[NSString stringWithFormat:@"%.1f", mileage / 1000] doubleValue];
			BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:[_dayArray[i] doubleValue] y:mileage];
			[sevenDaysRecord addObject:entry];
			beginDate = endDate;
		}
	}
	
	BarChartDataSet *dataSet = [[BarChartDataSet alloc] initWithValues:sevenDaysRecord label:@"里程"];
	[dataSet setColor:AppStyleSetting.sharedInstance.last7DaysColor];
	dataSet.drawIconsEnabled = NO;
	
	NSMutableArray *dataSets = [[NSMutableArray alloc] initWithObjects:dataSet, nil];
	
	BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
	[data setValueFont: [UIFont systemFontOfSize:10]];
	data.barWidth = 0.5;
	_last7DaysView.data = data;
	[_last7DaysView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
}

- (void)constructLongestAndFastestData{
	double longestWalk = 0;
	double longestRun = 0;
	double longestRide = 0;
	
	double fastestWalk = 0;
	double fastestRun = 0;
	double fastestRide = 0;
	
	NSPredicate *walkPredicate = [NSPredicate predicateWithFormat:@"SELF.transportMode == %d", 0];
	NSPredicate *runPredicate = [NSPredicate predicateWithFormat:@"SELF.transportMode == %d", 1];
	NSPredicate *ridePredicate = [NSPredicate predicateWithFormat:@"SELF.transportMode == %d", 2];
	NSArray *walkRecords = [_trackArray filteredArrayUsingPredicate:walkPredicate];
	NSArray *runRecords = [_trackArray filteredArrayUsingPredicate:runPredicate];
	NSArray *rideRecords = [_trackArray filteredArrayUsingPredicate:ridePredicate];
	
	longestWalk = [[walkRecords valueForKeyPath:@"@max.mileage"] doubleValue] / 1000;
	fastestWalk = [[walkRecords valueForKeyPath:@"@min.paceSpeed"] doubleValue];
	
	longestRun = [[runRecords valueForKeyPath:@"@max.mileage"] doubleValue] / 1000;
	fastestRun = [[runRecords valueForKeyPath:@"@min.paceSpeed"] doubleValue];
	
	longestRide = [[rideRecords valueForKeyPath:@"@max.mileage"] doubleValue] / 1000;
	fastestRide = [[rideRecords valueForKeyPath:@"@min.paceSpeed"] doubleValue];
	
	double walkKmH = fastestWalk > 0 ? 3600 / fastestWalk : 0;
	double runKmH = fastestRun > 0 ? 3600 / fastestRun : 0;
	double rideKmH = fastestRide > 0 ? 3600 / fastestRide : 0;
	
	longestWalk = [self removeExtraFractionDigits:longestWalk];
	walkKmH = [self removeExtraFractionDigits:walkKmH];
	longestRun = [self removeExtraFractionDigits:longestRun];
	runKmH = [self removeExtraFractionDigits:runKmH];
	longestRide = [self removeExtraFractionDigits:longestRide];
	rideKmH = [self removeExtraFractionDigits:rideKmH];
	
	NSMutableArray *longestWalkVal = [NSMutableArray arrayWithObjects:[[BarChartDataEntry alloc]initWithX:0 y:longestWalk], nil];
	NSMutableArray *longestRunVal = [NSMutableArray arrayWithObjects:[[BarChartDataEntry alloc]initWithX:1 y:longestRun], nil];
	NSMutableArray *longestRideVal = [NSMutableArray arrayWithObjects:[[BarChartDataEntry alloc]initWithX:2 y:longestRide], nil];
	
	NSMutableArray *fastestWalkVal = [NSMutableArray arrayWithObjects:[[BarChartDataEntry alloc]initWithX:0 y:walkKmH], nil];
	NSMutableArray *fastestRunVal = [NSMutableArray arrayWithObjects:[[BarChartDataEntry alloc]initWithX:1 y:runKmH], nil];
	NSMutableArray *fastestRideVal = [NSMutableArray arrayWithObjects:[[BarChartDataEntry alloc]initWithX:2 y:rideKmH], nil];
	
	BarChartDataSet *longestWalkSet = [[BarChartDataSet alloc] initWithValues:longestWalkVal label:@"健走"];
	[longestWalkSet setColor:[UIColor colorWithHexString:@"#5387EF"]];
	longestWalkSet.drawValuesEnabled = YES;
	BarChartDataSet *longestRunSet = [[BarChartDataSet alloc]initWithValues:longestRunVal label:@"跑步"];
	[longestRunSet setColor:[UIColor colorWithHexString:@"FF981F"]];
	longestRunSet.drawValuesEnabled = YES;
	BarChartDataSet *longestRideSet = [[BarChartDataSet alloc]initWithValues:longestRideVal label:@"骑行"];
	[longestRideSet setColor:[UIColor colorWithHexString:@"0DCC8F"]];
	longestRideSet.drawValuesEnabled = YES;
	
	BarChartDataSet *fastestWalkSet = [[BarChartDataSet alloc] initWithValues:fastestWalkVal label:@"健走"];
	[fastestWalkSet setColor:[UIColor colorWithHexString:@"#5387EF"]];
	BarChartDataSet *fastestRunSet = [[BarChartDataSet alloc]initWithValues:fastestRunVal label:@"跑步"];
	[fastestRunSet setColor:[UIColor colorWithHexString:@"FF981F"]];
	BarChartDataSet *fastestRideSet = [[BarChartDataSet alloc]initWithValues:fastestRideVal label:@"骑行"];
	[fastestRideSet setColor:[UIColor colorWithHexString:@"0DCC8F"]];
	
	BarChartData *longestData = [[BarChartData alloc] initWithDataSets:[NSMutableArray arrayWithObjects:longestWalkSet, longestRunSet, longestRideSet, nil]];
	[longestData setDrawValues:YES];
	[longestData setValueFont:[UIFont systemFontOfSize:10]];
	[longestData setValueFormatter:[[ChartDefaultValueFormatter alloc]initWithDecimals:1]];
	longestData.barWidth = 0.5;
	_longestView.data = longestData;
	[_longestView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
	
	BarChartData *fastestData = [[BarChartData alloc] initWithDataSets:[NSMutableArray arrayWithObjects:fastestWalkSet, fastestRunSet, fastestRideSet, nil]];
	[fastestData setValueFont:[UIFont systemFontOfSize:10]];
	fastestData.barWidth = 0.5;
	_fastestView.data = fastestData;
	[_fastestView animateWithXAxisDuration:2.0 yAxisDuration:2.0];
}

- (double)removeExtraFractionDigits:(double)value{
	return round(value*100)/100;
}

#pragma mark - Request

- (void)getAllMyTrackRecords{
	AVQuery *query = [AVQuery queryWithClassName:@"TrackRecord"];
	[query whereKey:@"user" equalTo:[AVUser currentUser]];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		if (error != nil) {
			[self.view makeToast:error.localizedDescription];
		}
		else{
			if (objects == nil) {
				[self.view makeToast:@"您最近7天都没有运动了"];
				return;
			}
			
			if (objects.count > 0) {
				for (NSDictionary *dic in objects) {
					TrackRecord *track = [TrackRecord trackWithDictionary:dic];
					[self.trackArray addObject:track];
				}
				
				[self constructLastSevenDaysData];
				[self constructLongestAndFastestData];
			}
		}
	}];
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
