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

@interface RecordViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) BarChartView *last7DaysView;

@property (nonatomic, strong) HorizontalBarChartView *longestView;

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
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	
	[self initMainScrollView];
	
	[self constructTimeSpan];
	
	[self initLastSevenDaysView];
	
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
	_mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
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
	_last7DaysView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 0, 350, 260)];
	_last7DaysView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	_last7DaysView.chartDescription.enabled = NO;
	_last7DaysView.drawGridBackgroundEnabled = NO;
	_last7DaysView.dragEnabled = YES;
	[_last7DaysView setScaleEnabled:YES];
	_last7DaysView.pinchZoomEnabled = NO;
	_last7DaysView.rightAxis.enabled = NO;
	_last7DaysView.drawBarShadowEnabled = NO;
	_last7DaysView.drawValueAboveBarEnabled = YES;
	_last7DaysView.maxVisibleCount = 7;
	_last7DaysView.layer.cornerRadius = 5.0;
	_last7DaysView.layer.masksToBounds = YES;
	
	NSNumberFormatter *yAxisFormatter = [[NSNumberFormatter alloc] init];
	yAxisFormatter.minimumFractionDigits = 0;
	yAxisFormatter.maximumFractionDigits = 0;
	yAxisFormatter.negativeSuffix = @"km";
	yAxisFormatter.positiveSuffix = @"km";
	
	ChartXAxis *xAxis = _last7DaysView.xAxis;
	xAxis.labelPosition = XAxisLabelPositionBottom;
	xAxis.labelFont = [UIFont systemFontOfSize:12];
	xAxis.drawGridLinesEnabled = NO;
	xAxis.granularity = 1;
	xAxis.labelCount = 7;
	xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithDecimals:0];
	
	ChartYAxis *yAxis = _last7DaysView.leftAxis;
	yAxis.enabled = YES;
	yAxis.drawGridLinesEnabled = NO;
	yAxis.labelFont = [UIFont systemFontOfSize:12];
	yAxis.labelCount = 8;
	yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:yAxisFormatter];
	yAxis.labelPosition = YAxisLabelPositionOutsideChart;
	yAxis.spaceTop = 0.1;
	yAxis.axisMinimum = 0;
	
	[self.mainScrollView addSubview:_last7DaysView];
	[_last7DaysView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mainScrollView).offset(20);
		make.left.equalTo(self.mainScrollView).offset(20);
		make.right.equalTo(self.mainScrollView).offset(-20);
		make.width.equalTo(@(self.view.frame.size.width - 40));
		make.height.equalTo(@260);
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
