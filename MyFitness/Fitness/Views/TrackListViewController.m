//
//  TrackListViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/11.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "TrackListViewController.h"
#import <Masonry/Masonry.h>
#import <CoreLocation/CLLocation.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "TrackRecord.h"
#import "TransportModeEnum.h"
#import "TrackDetailViewController.h"
#import "SummaryTableCell.h"
#import "MonthSectionHeader.h"
#import "TrackTableCell.h"
#import "NSString+NSDate.h"

@interface TrackListViewController ()<UITableViewDelegate, UITableViewDataSource>
	
@property (nonatomic, strong) NSMutableArray *trackList;
	
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TrackListViewController
	
#pragma mark - Init

- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		
	}
	return self;
}
	
#pragma mark - Init Property
	
- (void)initValueProperty{
	_trackList = [[NSMutableArray alloc] init];
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
	
	self.title = @"里程";
	
	[self initValueProperty];
	
	[self initTrackTableView];
	
	[self getAllMyTrackRecords];
    // Do any additional setup after loading the view.
}
	
#pragma mark - Init Views
	
-(void) initTrackTableView{
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.backgroundColor = [UIColor whiteColor];
	_tableView.sectionFooterHeight = 0;
	_tableView.estimatedRowHeight = 0;
	_tableView.estimatedSectionHeaderHeight = 0;
	_tableView.estimatedSectionFooterHeight = 0;
	_tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
	_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.00001)];
	_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	UINib *summaryNib = [UINib nibWithNibName:@"SummaryTableCell" bundle:NSBundle.mainBundle];
	UINib *headerNib = [UINib nibWithNibName:@"MonthSectionHeader" bundle:NSBundle.mainBundle];
	UINib *trackNib = [UINib nibWithNibName:@"TrackTableCell" bundle:NSBundle.mainBundle];
	
	[_tableView registerNib:summaryNib forCellReuseIdentifier:@"summaryCell"];
	[_tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"monthHeader"];
	[_tableView registerNib:trackNib forCellReuseIdentifier:@"trackCell"];
	
	if (@available(iOS 11.0, *)) {
		_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self.view addSubview:_tableView];
	
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.bottom.right.equalTo(self.view);
	}];
}
	
#pragma mark - Request
	
-(void) getAllMyTrackRecords{
	AVQuery *query = [AVQuery queryWithClassName:@"TrackRecord"];
	[query whereKey:@"user" equalTo:[AVUser currentUser]];
	[query includeKey:@"user"];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		if (error != nil) {
			[self.view makeToast:[NSString stringWithFormat:@"获取记录失败 ==> %@", error.localizedDescription]];
			return;
		}
		else{
			if (objects == nil || objects.count == 0) {
				[self.view makeToast:@"记录为空"];
				return;
			}
			
			[objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				NSDictionary *object = obj;
				TrackRecord *trackRecord = [TrackRecord trackWithDictionary: object];
				[self.trackList addObject:trackRecord];
			}];
			
			[self.tableView reloadData];
		}
	}];
}

#pragma mark - Action

- (NSString*)calculateAllDistance{
	double allDistance = 0;
	
	if (_trackList.count == 0) {
		return @"0:00";
	}
	
	for (TrackRecord *record in _trackList) {
		allDistance += record.mileage;
	}
	
	NSString *distanceString = [NSString stringWithFormat:@"%.2f", allDistance / 1000];
	return distanceString;
}

- (NSString*)calculateAvgPaceSpeed{
	double allDistance = 0;
	double allInterval = 0;
	
	if (_trackList.count == 0) {
		return @"0'00\"";
	}
	
	for (TrackRecord *record in _trackList) {
		allDistance += record.mileage;
		allInterval += record.interval;
	}
	
	double minKmValue = allInterval / (allDistance / 1000);
	int floorMin = floor(minKmValue/60);
	int roundSec = round(minKmValue - (floorMin*60));
	
	NSMutableString *formatt = [NSMutableString stringWithString:@"%d':%d\""];
	if (roundSec < 10) {
		formatt = [NSMutableString stringWithString:@"%d':0%d\""];
	}
	
	NSString *avgPaceString = [NSString stringWithFormat:formatt, floorMin, roundSec];
	
	return avgPaceString;
}
	
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSInteger count = 0;
	switch (section) {
		case 0:
			count = 1;
			break;
		case 1:
			count = _trackList.count;
		default:
			break;
	}
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:
			return 210;
			break;
		case 1:
			return 100;
		default:
			return 100;
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 1) {
		return 50;
	}
	else{
		return 0;
	}
}
	
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	switch (indexPath.section) {
		case 0:{
			SummaryTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"summaryCell" forIndexPath:indexPath];
			cell.distanceLabel.text = [self calculateAllDistance];
			cell.timesLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_trackList.count];
			cell.paceSpeedLabel.text = [self calculateAvgPaceSpeed];
			return cell;
		}
		break;
		case 1:{
			TrackTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
			TrackRecord *record = _trackList[indexPath.row];
			cell.trackImageView.image = [UIImage imageNamed:@"default_track"];
			cell.startTimeLabel.text = record.startTimeString;
			cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f公里", record.mileage / 1000];
			int floorPaceMin = floor(record.paceSpeed/60);
			int roundPaceSec = round(record.paceSpeed - (floorPaceMin*60));
			NSMutableString *paceFormatt = [NSMutableString stringWithString:@"%d':%d\""];
			if (roundPaceSec < 10) {
				paceFormatt = [NSMutableString stringWithString:@"%d':0%d\""];
			}
			cell.paceSpeedLabel.text = [NSString stringWithFormat:paceFormatt, floorPaceMin, roundPaceSec];
			cell.durationLabel.text = record.minuteString;
			
			return cell;
		}
		default:
			return [UITableViewCell new];
			break;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section == 1) {
		MonthSectionHeader *header = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:@"monthHeader"];
		header.monthLabel.text = @"2018年12月";
		header.infoLabel.text = @"5次跑步 4'35\"配速";
		return header;
	}
	return nil;
}
	
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	TrackRecord *trackRecord = self.trackList[indexPath.row];
	TrackDetailViewController *detailVC = [[TrackDetailViewController alloc] initWithStartTime:trackRecord.startTime FinishedTime:trackRecord.finishedTime TransportMode:trackRecord.transportMode TrackId:trackRecord.objectId];
	[self.navigationController pushViewController:detailVC animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
