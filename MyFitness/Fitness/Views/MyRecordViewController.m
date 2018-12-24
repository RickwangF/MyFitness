//
//  MyRecordViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "MyRecordViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import "AppStyleSetting.h"
#import <AVOSCloud/AVOSCloud.h>
#import "TrackRecord.h"
#import "NSString+NSDate.h"
#import "UIImage+UIColor.h"
#import "UIColor+UIColor_Hex.h"
#import "AAChartKit.h"

@interface MyRecordViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIView *firstContainerView;

@property (nonatomic, strong) AAChartView *last7DaysView;

@property (nonatomic, strong) UIView *secondContainerView;

@property (nonatomic, strong) AAChartView *longestView;

@property (nonatomic, strong) UIView *thirdContainerView;

@property (nonatomic, strong) AAChartView *fastestView;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) NSDate *last7Day;

@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSArray *walkArray;

@property (nonatomic, strong) NSArray *runArray;

@property (nonatomic, strong) NSArray *rideArray;

@end

@implementation MyRecordViewController

#pragma mark - Init

- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
		[self constructTimeSpan];
	}
	return self;
}

- (void)initValueProperty{
	_trackArray = [NSMutableArray new];
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
	
	_last7DaysView = [[AAChartView alloc] initWithFrame:CGRectMake(0, 0, 315, 200)];
	_last7DaysView.scrollEnabled = NO;
	_last7DaysView.backgroundColor = UIColor.clearColor;
	_last7DaysView.isClearBackgroundColor = YES;
	[_firstContainerView addSubview:_last7DaysView];
	[_last7DaysView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView).offset(30);
		make.left.equalTo(self.firstContainerView).offset(15);
		make.right.equalTo(self.firstContainerView).offset(-15);
		make.bottom.equalTo(self.firstContainerView);
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
	
	_longestView = [[AAChartView alloc] initWithFrame:CGRectMake(0, 0, 315, 200)];
	_longestView.scrollEnabled = NO;
	_longestView.backgroundColor = UIColor.clearColor;
	_longestView.isClearBackgroundColor = YES;
	[_secondContainerView addSubview:_longestView];
	
	[_longestView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.secondContainerView).offset(30);
		make.left.equalTo(self.secondContainerView).offset(15);
		make.right.equalTo(self.secondContainerView).offset(-15);
		make.bottom.equalTo(self.secondContainerView);
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
	
	_fastestView = [[AAChartView alloc] initWithFrame:CGRectMake(0, 0, 315, 200)];
	_fastestView.scrollEnabled = NO;
	_fastestView.backgroundColor = UIColor.clearColor;
	_fastestView.isClearBackgroundColor = YES;
	[_thirdContainerView addSubview:_fastestView];
	
	[_fastestView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.thirdContainerView).offset(30);
		make.left.equalTo(self.thirdContainerView).offset(15);
		make.right.equalTo(self.thirdContainerView).offset(-15);
		make.bottom.equalTo(self.thirdContainerView);
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
			NSString *day = [NSString stringWithFormat:@"%@日", [format stringFromDate:date]];
			[_dayArray addObject:day];
		}
	}
}

- (void)constructTransportArray{
	NSPredicate *walkPredicate = [NSPredicate predicateWithFormat:@"SELF.transportMode == %d", 0];
	NSPredicate *runPredicate = [NSPredicate predicateWithFormat:@"SELF.transportMode == %d", 1];
	NSPredicate *ridePredicate = [NSPredicate predicateWithFormat:@"SELF.transportMode == %d", 2];
	_walkArray = [_trackArray filteredArrayUsingPredicate:walkPredicate];
	_runArray = [_trackArray filteredArrayUsingPredicate:runPredicate];
	_rideArray = [_trackArray filteredArrayUsingPredicate:ridePredicate];
}

- (double)removeExtraFractionDigits:(double)value{
	return round(value*100)/100;
}

- (void)configLastSevenDaysView{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.finishedTime <= %@ && SELF.startTime >= %@", _today, _last7Day];
	NSArray* last7DayRecords = [_trackArray filteredArrayUsingPredicate:predicate];
	NSMutableArray *mileageArray = [[NSMutableArray alloc] init];
	NSDate *beginDate = _last7Day;
	AASeriesElement *element = [AASeriesElement new];
	element.name = @"里程";
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
			[mileageArray addObject:@(mileage)];
			beginDate = endDate;
		}
	}
	element.data = mileageArray;
	
	AAChartModel *model = AAChartModel.new
	.chartTypeSet(AAChartTypeColumn)
	.titleSet(@"")
	.subtitleSet(@"公里")
	.subtitleFontSizeSet(@12)
	.subtitleFontWeightSet(@"600")
	.yAxisLineWidthSet(@1)
	.yAxisTitleSet(@"")
	.yAxisTickIntervalSet(@5)
	.colorsThemeSet(@[@"#32d882"])
	.tooltipValueSuffixSet(@"公里")
	.backgroundColorSet(@"#f1f1f1")
	.yAxisGridLineWidthSet(@0.5)
	.seriesSet(@[element])
	.categoriesSet(_dayArray)
	.xAxisLabelsEnabledSet(YES)
	.xAxisTickIntervalSet(@1)
	.xAxisGridLineWidthSet(@0.5)
	.animationTypeSet(AAChartAnimationEaseTo)
	.animationDurationSet(@2000);
	
	[_last7DaysView aa_drawChartWithChartModel:model];
}

- (void)configLongestView{
	double walkLongest = 0;
	double runLongest = 0;
	double rideLongest = 0;
	
	walkLongest = [[_walkArray valueForKeyPath:@"@max.mileage"] doubleValue] / 1000;
	runLongest = [[_runArray valueForKeyPath:@"@max.mileage"] doubleValue] / 1000;
	rideLongest = [[_rideArray valueForKeyPath:@"@max.mileage"] doubleValue] / 1000;
	
	walkLongest = [self removeExtraFractionDigits:walkLongest];
	runLongest = [self removeExtraFractionDigits:runLongest];
	rideLongest = [self removeExtraFractionDigits:rideLongest];
	
	AASeriesElement *walkElement = [AASeriesElement new];
	walkElement.name = @"健走";
	walkElement.data = @[@(walkLongest)];
	
	AASeriesElement *runElement = [AASeriesElement new];
	runElement.name = @"跑步";
	runElement.data = @[@(runLongest)];
	
	AASeriesElement *rideElement = [AASeriesElement new];
	rideElement.name = @"骑行";
	rideElement.data = @[@(rideLongest)];
	
	AAChartModel *model = AAChartModel.new
	.chartTypeSet(AAChartTypeBar)
	.titleSet(@"")
	.subtitleSet(@"运动")
	.subtitleFontSizeSet(@12)
	.subtitleFontWeightSet(@"600")
	.yAxisLineWidthSet(@1)
	.yAxisTitleSet(@"公里")
	.yAxisTickIntervalSet(@5)
	.colorsThemeSet(@[@"#5387EF", @"#FF981F" ,@"#0DCC8F"])
	.tooltipValueSuffixSet(@"公里")
	.backgroundColorSet(@"#f1f1f1")
	.yAxisGridLineWidthSet(@0.5)
	.seriesSet(@[walkElement, runElement, rideElement])
	.categoriesSet(@[@"运动"])
	.xAxisLabelsEnabledSet(NO)
	.xAxisTickIntervalSet(@1)
	.xAxisGridLineWidthSet(@0.5)
	.xAxisCrosshairColorSet(@"#ffffff")
	.dataLabelEnabledSet(YES)
	.animationTypeSet(AAChartAnimationEaseTo)
	.animationDurationSet(@2000);
	
	[_longestView aa_drawChartWithChartModel:model];
}

- (void)configFastestView{
	double walkFastest = 0;
	double runFastest = 0;
	double rideFastest = 0;
	
	walkFastest = [[_walkArray valueForKeyPath:@"@min.paceSpeed"] doubleValue];
	runFastest = [[_runArray valueForKeyPath:@"@min.paceSpeed"] doubleValue];
	rideFastest = [[_rideArray valueForKeyPath:@"@min.paceSpeed"] doubleValue];
	
	double walkKmH = walkFastest > 0 ? 3600 / walkFastest : 0;
	double runKmH = runFastest > 0 ? 3600 / runFastest : 0;
	double rideKmH = rideFastest > 0 ? 3600 / rideFastest : 0;

	walkKmH = [self removeExtraFractionDigits:walkKmH];
	runKmH = [self removeExtraFractionDigits:runKmH];
	rideKmH = [self removeExtraFractionDigits:rideKmH];
	
	AASeriesElement *walkElement = [AASeriesElement new];
	walkElement.name = @"健走";
	walkElement.data = @[@(walkKmH)];
	
	AASeriesElement *runElement = [AASeriesElement new];
	runElement.name = @"跑步";
	runElement.data = @[@(runKmH)];
	
	AASeriesElement *rideElement = [AASeriesElement new];
	rideElement.name = @"骑行";
	rideElement.data = @[@(rideKmH)];
	
	AAChartModel *model = AAChartModel.new
	.chartTypeSet(AAChartTypeBar)
	.titleSet(@"")
	.subtitleSet(@"运动")
	.subtitleFontSizeSet(@12)
	.subtitleFontWeightSet(@"600")
	.yAxisLineWidthSet(@1)
	.yAxisTitleSet(@"km/h")
	.yAxisTickIntervalSet(@5)
	.colorsThemeSet(@[@"#5387EF", @"#FF981F" ,@"#0DCC8F"])
	.tooltipValueSuffixSet(@"km/h")
	.backgroundColorSet(@"#f1f1f1")
	.yAxisGridLineWidthSet(@0.5)
	.seriesSet(@[walkElement, runElement, rideElement])
	.categoriesSet(@[@"运动"])
	.xAxisLabelsEnabledSet(NO)
	.xAxisTickIntervalSet(@1)
	.xAxisGridLineWidthSet(@0.5)
	.xAxisCrosshairColorSet(@"#ffffff")
	.dataLabelEnabledSet(YES)
	.animationTypeSet(AAChartAnimationEaseTo)
	.animationDurationSet(@2000);
	
	[_fastestView aa_drawChartWithChartModel:model];
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
				[self constructTransportArray];
				[self configLastSevenDaysView];
				[self configLongestView];
				[self configFastestView];
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
