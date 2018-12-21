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
	
	[self getLast7DaysTrackRecord];
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

#pragma mark - Action

- (void)constructTimeSpan{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_today];
	NSDate *todayEarly = [calendar dateFromComponents:components];
	_today = [todayEarly dateByAddingTimeInterval:(23*60*60+59*60+59)];
	_last7Day = [todayEarly dateByAddingTimeInterval:-(6*24*60*60)];
	for (int i=6; i>=1; i--) {
		@autoreleasepool {
			NSDate *date = [todayEarly dateByAddingTimeInterval:(-i * (24*60*60))];
			[_dayArray addObject:date];
		}
	}
	[_dayArray addObject:todayEarly];
}

#pragma mark - Request

- (void)getLast7DaysTrackRecord{
	AVQuery *query = [AVQuery queryWithClassName:@"TrackRecord"];
	[query whereKey:@"user" equalTo:[AVUser currentUser]];
	[query whereKey:@"startTime" greaterThanOrEqualTo:_last7Day];
	[query whereKey:@"finishedTime" lessThanOrEqualTo:_today];
	
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
