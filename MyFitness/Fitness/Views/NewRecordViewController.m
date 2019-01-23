//
//  NewRecordViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/18.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "NewRecordViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppStyleSetting.h"
#import "UIImage+UIColor.h"
#import "TrackRecord.h"
#import "MFLocation.h"
#import "RecBaseInfoTableCell.h"
#import "UIDevice+Type.h"
#import "YearHeaderView.h"
#import "RecMapTableCell.h"
#import "RecChartTableCell.h"
#import "MessageFooterView.h"
#import "RecordData.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface NewRecordViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *recordTableView;

// 键是年份字符串, 值是年份对应的记录数组
@property (nonatomic, strong) NSMutableDictionary *recordDictionary;

// 记录的年份数组
@property (nonatomic, strong) NSMutableArray *yearIndexArray;

@property (nonatomic, strong) NSMutableArray *trackArray;

// 历史平均速度
@property (nonatomic, assign) double avgSpeed;

// 历史平均用时
@property (nonatomic, assign) double avgDuration;

@end

@implementation NewRecordViewController

#pragma mark - Init

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (void)initValueProperty{
	_recordDictionary = [[NSMutableDictionary alloc] init];
	_yearIndexArray = [[NSMutableArray alloc] init];
	_trackArray = [[NSMutableArray alloc] init];
	_avgSpeed = 0;
}

#pragma mark - Lift Circle

- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mainView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
	self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:[UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
	self.title = @"我的记录";
	
	[self initRecordTableView];
	
	[self getAllMyTrackRecords];
    // Do any additional setup after loading the view.
}

#pragma mark - Init View

- (void)initRecordTableView{
	_recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 500) style:UITableViewStyleGrouped];
	_recordTableView.backgroundColor = UIColor.clearColor;
	_recordTableView.backgroundView = nil;
	_recordTableView.delegate = self;
	_recordTableView.dataSource = self;
	_recordTableView.emptyDataSetDelegate = self;
	_recordTableView.emptyDataSetSource = self;
	_recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	if (@available(iOS 11.0, *)) {
		_recordTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	_recordTableView.estimatedRowHeight = 0;
	_recordTableView.estimatedSectionHeaderHeight = 0;
	_recordTableView.estimatedSectionFooterHeight = 0;
	_recordTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.0001)];
	_recordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	
	UINib *yeadrNib = [UINib nibWithNibName:@"YearHeaderView" bundle:NSBundle.mainBundle];
	UINib *recInfoNib = [UINib nibWithNibName:@"RecBaseInfoTableCell" bundle:NSBundle.mainBundle];
	UINib *mapNib = [UINib nibWithNibName:@"RecMapTableCell" bundle:NSBundle.mainBundle];
	UINib *chartNib = [UINib nibWithNibName:@"RecChartTableCell" bundle:NSBundle.mainBundle];
	UINib *messageNib = [UINib nibWithNibName:@"MessageFooterView" bundle:NSBundle.mainBundle];
	
	[_recordTableView registerNib:yeadrNib forHeaderFooterViewReuseIdentifier:@"yearHeader"];
	[_recordTableView registerNib:recInfoNib forCellReuseIdentifier:@"recInfoCell"];
	[_recordTableView registerNib:mapNib forCellReuseIdentifier:@"recMapCell"];
	[_recordTableView registerNib:chartNib forCellReuseIdentifier:@"recChartCell"];
	[_recordTableView registerNib:messageNib forHeaderFooterViewReuseIdentifier:@"messageFooter"];
	
	[self.view addSubview:_recordTableView];
	[_recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)) {
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.bottom.right.equalTo(self.view);
	}];
}

#pragma mark - Method

- (void)constructYearIndexArray{
	
	if (_trackArray.count == 0) {
		return;
	}
	
	NSInteger maxYear = [[_trackArray valueForKeyPath:@"@max.year"] integerValue];
	NSInteger minYear = [[_trackArray valueForKeyPath:@"@min.year"] integerValue];
	
	if (maxYear == minYear) {
		[_yearIndexArray addObject:[NSString stringWithFormat:@"%ld", (long)maxYear]];
	}
	else if (maxYear > minYear) {
		for (NSInteger i = minYear; i<=maxYear; i++) {
			NSString *yearString = [NSString stringWithFormat:@"%ld", (long)i];
			[_yearIndexArray addObject: yearString];
		}
	}
	
}

- (void)initRecordDictionary{
	if (_yearIndexArray.count == 0) {
		return;
	}
	
	for (NSString *year in _yearIndexArray) {
		[_recordDictionary setObject:[NSMutableArray new] forKey: year];
	}
}

- (void)calculateAvgSpeed{
	if (_trackArray.count == 0) {
		return;
	}
	
	_avgSpeed = [[_trackArray valueForKeyPath:@"@avg.avgSpeed"] doubleValue];
}

- (void)calculateAvgDuration{
	if (_trackArray.count == 0) {
		return;
	}
	
	_avgDuration = [[_trackArray valueForKeyPath:@"@avg.interval"] doubleValue];
}

- (void)constructFirstSport{
	if (_trackArray.count == 0) {
		return;
	}
	
	TrackRecord *firstRecord = _trackArray[0];
	RecordData *data = [[RecordData alloc] initFirstSportWithTrackRecord:firstRecord];
	[self insertRecordData:data];
}

- (void)constructLongestSport{
	if (_trackArray.count == 0) {
		return;
	}
	
	double mile = [[_trackArray valueForKeyPath:@"@max.mileage"] doubleValue];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.mileage >= %f", mile - 0.001];
	TrackRecord *longestRecord = [_trackArray filteredArrayUsingPredicate:predicate].firstObject;
	if (longestRecord == nil) {
		return;
	}
	
	RecordData *data = [[RecordData alloc] initLongestSportWithTrackRecord:longestRecord];
	[self insertRecordData:data];
}

- (void)constructFastestSport{
	if (_trackArray.count == 0) {
		return;
	}
	
	double maxSpeed = [[_trackArray valueForKeyPath:@"@max.avgSpeed"] doubleValue];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.avgSpeed >= %f", maxSpeed - 0.001];
	TrackRecord *fastestRecord = [_trackArray filteredArrayUsingPredicate:predicate].firstObject;
	if (fastestRecord == nil) {
		return;
	}
	
	RecordData *data = [[RecordData alloc] initFastestSportWithTrackRecord:fastestRecord AvgSpeed:_avgSpeed];
	[self insertRecordData:data];
}

- (void)constructDurationSport{
	if (_trackArray.count == 0) {
		return;
	}
	
	double maxDuration = [[_trackArray valueForKeyPath:@"@max.interval"] doubleValue];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.interval >= %f", maxDuration - 0.001];
	TrackRecord *durationRecord = [_trackArray filteredArrayUsingPredicate:predicate].firstObject;
	if (durationRecord == nil) {
		return;
	}
	
	RecordData *data = [[RecordData alloc] initDurationSportWithTrackRecord:durationRecord AvgDuration:_avgDuration];
	[self insertRecordData:data];
}

- (void)constructLastSport{
	if (_trackArray.count == 0) {
		return;
	}
	
	TrackRecord *lastRecord = [_trackArray lastObject];
	if (lastRecord == nil) {
		return;
	}
	
	RecordData *data = [[RecordData alloc] initLastSportWithTrackRecord:lastRecord];
	[self insertRecordData:data];
}

- (void)insertRecordData:(RecordData*)recordData{
	if (_yearIndexArray.count == 0){
		return;
	}
	
	NSString *year = recordData.year;
	if (year == nil || [year isEqualToString:@""]) {
		return;
	}
	
	NSMutableArray *yearRecArray = [_recordDictionary objectForKey:year];
	[yearRecArray addObject:recordData];
	
	if (yearRecArray.count > 1) {
		[yearRecArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
			RecordData *data1 = obj1;
			RecordData *data2 = obj2;
			
			return [data1.startTime compare:data2.startTime];
		}];
	}
}


#pragma mark - Request

- (void)getAllMyTrackRecords{
	AVQuery *query = [AVQuery queryWithClassName:@"TrackRecord"];
	[query whereKey:@"user" equalTo:[AVUser currentUser]];
	[query orderByAscending:@"startTime"];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		if (error != nil) {
			[self.view makeToast:error.localizedDescription];
		}
		else{
			if (objects == nil || objects.count == 0) {
				[self.recordTableView reloadData];
				return;
			}
			
			for (NSDictionary *dic in objects) {
				TrackRecord *track = [TrackRecord trackWithDictionary:dic];
				[self.trackArray addObject:track];
			}
			
			[self constructYearIndexArray];
			[self initRecordDictionary];
			[self calculateAvgSpeed];
			[self calculateAvgDuration];
			[self constructFirstSport];
			[self constructLongestSport];
			[self constructFastestSport];
			[self constructDurationSport];
			[self constructLastSport];
			[self.recordTableView reloadData];
		}
	}];
}

#pragma mark - Cell For Row

- (RecBaseInfoTableCell*)baseInfoCellData:(RecordData*)data WithTable:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath{
	RecBaseInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recInfoCell" forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0 && indexPath.row == 0){
		[cell hideAboveLine];
		[cell changeIndicatorSize:CGSizeMake(30, 30)];
		[cell setStartSpot];
	}
	cell.dateLabel.text = data.dateString;
	cell.timeLabel.text = data.timeString;
	cell.infoLabel.text = data.info;
	cell.modeLabel.text = data.modeString;
	cell.minuteNumLabel.text = data.minute;
	cell.kmNumLabel.text = data.kiloMeter;
	cell.paceLabel.text = data.pace;
	return cell;
}

- (RecMapTableCell*)mapCellData:(RecordData*)data WithTable:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath{
	RecMapTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recMapCell" forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0 && indexPath.row == 0){
		[cell hideAboveLine];
		[cell changeIndicatorSize:CGSizeMake(30, 30)];
		[cell setStartSpot];
	}
	cell.dateLabel.text = data.dateString;
	cell.timeLabel.text = data.timeString;
	cell.infoLabel.text = data.info;
	cell.modeLabel.text = data.modeString;
	cell.minuteNumLabel.text = data.minute;
	cell.kmNumLabel.text = data.kiloMeter;
	cell.paceLabel.text = data.pace;
	[cell.trackImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl]];
	return cell;
}

- (RecChartTableCell*)chartCellData:(RecordData*)data WithTable:(UITableView*)tableView IndexPath:(NSIndexPath*)indexPath{
	RecChartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recChartCell" forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0 && indexPath.row == 0){
		[cell hideAboveLine];
		[cell changeIndicatorSize:CGSizeMake(30, 30)];
		[cell setStartSpot];
	}
	cell.dateLabel.text = data.dateString;
	cell.timeLabel.text = data.timeString;
	cell.infoLabel.text = data.info;
	cell.modeLabel.text = data.modeString;
	cell.minuteNumLabel.text = data.minute;
	cell.kmNumLabel.text = data.kiloMeter;
	cell.paceLabel.text = data.pace;
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return _yearIndexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (_yearIndexArray.count > 0) {
		NSString *year = _yearIndexArray[section];
		NSMutableArray *yearRecArray = [_recordDictionary objectForKey:year];
		return yearRecArray.count;
	}
	else{
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *year = _yearIndexArray[indexPath.section];
	NSMutableArray *yearRecArray = [_recordDictionary objectForKey:year];
	RecordData *data = yearRecArray[indexPath.row];
	switch (data.type) {
		case RecordTypeEnumFirstSport:
			return 100;
			break;
		case RecordTypeEnumLongestSport:
			return 365;
			break;
		case RecordTypeEnumFastestPace:
			return 200;
			break;
		case RecordTypeEnumDurationSport:
			return 200;
			break;
		case RecordTypeEnumLastSport:
			return 100;
			break;
		default:
			return 100;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *year = _yearIndexArray[indexPath.section];
	NSMutableArray *yearRecArray = [_recordDictionary objectForKey:year];
	RecordData *data = yearRecArray[indexPath.row];
	
	switch (data.type) {
		case RecordTypeEnumFirstSport:{
			RecBaseInfoTableCell *cell = [self baseInfoCellData:data WithTable:tableView IndexPath:indexPath];
			return cell;
		}
		break;
		case RecordTypeEnumLongestSport:{
			RecMapTableCell *cell = [self mapCellData:data WithTable:tableView IndexPath:indexPath];
			return cell;
		}
		break;
		case RecordTypeEnumFastestPace:{
			RecChartTableCell *cell = [self chartCellData:data WithTable:tableView IndexPath:indexPath];
			CGFloat avgProgress = (CGFloat)_avgSpeed / 20;
			CGFloat fastProgress = (CGFloat)data.speed / 20;
			[cell setAvgProgress:avgProgress];
			[cell setMostProgress:fastProgress];
			return cell;
		}
		break;
		case RecordTypeEnumDurationSport:{
			RecChartTableCell *cell = [self chartCellData:data WithTable:tableView IndexPath:indexPath];
			cell.firstInnerLabel.text = @"平均时长";
			cell.secondInnerLabel.text = @"本次时长";
			CGFloat avgProgress = (CGFloat)_avgDuration / 4000;
			CGFloat longestProgress = (CGFloat)data.duration / 4000;
			[cell setAvgProgress:avgProgress];
			[cell setMostProgress:longestProgress];
			return cell;
		}
		case RecordTypeEnumLastSport:{
			RecBaseInfoTableCell *cell = [self baseInfoCellData:data WithTable:tableView IndexPath:indexPath];
			[cell hideBelowLine];
			return cell;
		}
		break;
		default:
			return nil;
		break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	YearHeaderView *yearHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"yearHeader"];
	NSString *year = _yearIndexArray[section];
	yearHeader.yearLabel.text = year;
	return yearHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if (section == _yearIndexArray.count - 1) {
		return 80;
	}
	else{
		return 0.0001;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if (section == _yearIndexArray.count - 1) {
		MessageFooterView *messageFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"messageFooter"];
		return messageFooter;
	}
	else{
		return nil;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
	return [UIImage imageNamed:@"nodata_150#bf"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
	NSString *title = @"暂时没有你的记录数据";
	
	NSDictionary *attributedDic = @{
									NSFontAttributeName: [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold],
									NSForegroundColorAttributeName: [UIColor colorWithRed:191.0/255 green:191.0/255 blue:191.0/255 alpha:1.0]
									};
	
	return [[NSAttributedString alloc] initWithString:title attributes:attributedDic];
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
