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
#import "AppStyleSetting.h"
#import "UIImage+UIColor.h"
#import "MyFitness-Swift.h"
#import "RightImageButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewRecordViewController.h"

/*
 里程页面的数据按照“年-月”组成的键分类，存储在字典中，有多少个“年-月”的组合就有多少个section
 “年-月”的组合存储在yearMonthArray中，在trackDic中“年-月”是键，值是该年改月的轨迹记录数组
 */

@interface TrackListViewController ()<UITableViewDelegate, UITableViewDataSource>
	
@property (nonatomic, strong) NSMutableArray<TrackRecord*> *trackList;
	
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) TransportModeEnum transportMode;

@property (nonatomic, strong) RightImageButton *dropdownBtn;

@property (nonatomic, strong) DropDownMenu *dropdownMenu;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, strong) NSMutableArray *yearMonthArray;

@property (nonatomic, strong) NSMutableDictionary *trackDic;

@property (nonatomic, strong) NSMutableString *avgPaceString;

@property (nonatomic, strong) NSMutableString *totalDistanceString;

@end

@implementation TrackListViewController
	
#pragma mark - Init

- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (instancetype)initWithTransportMode:(TransportModeEnum)mode{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
		_transportMode = mode;
	}
	return self;
}

#pragma mark - Init Property
	
- (void)initValueProperty{
	_transportMode = TransportModeNone;
	_trackList = [[NSMutableArray alloc] init];
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate:today];
	_year = components.year;
	_month = components.month;
	_yearMonthArray = [[NSMutableArray alloc] init];
	_trackDic = [[NSMutableDictionary alloc] init];
	_avgPaceString = [NSMutableString string];
	_totalDistanceString = [NSMutableString string];
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
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"record_25#00"] style:UIBarButtonItemStylePlain target:self action:@selector(openRecordView:)];
	
	self.navigationItem.backBarButtonItem = [UIBarButtonItem new];
	
	[self initDropdownMenu];
	
	[self initTrackTableView];
	
	[self getAllMyTrackRecords];
    // Do any additional setup after loading the view.
}
	
#pragma mark - Init Views

- (void)initDropdownMenu{
	_dropdownBtn = [[RightImageButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
	switch (_transportMode) {
		case TransportModeNone:
			[_dropdownBtn setTitle:@"所有运动"];
			break;
		case TransportModeWalking:
			[_dropdownBtn setTitle:@"健走"];
			break;
		case TransportModeRunning:
			[_dropdownBtn setTitle:@"跑步"];
			break;
		case TransportModeRiding:
			[_dropdownBtn setTitle:@"骑行"];
			break;
		default:
			break;
	}
	
	[_dropdownBtn setImage:[UIImage imageNamed:@"down_10#00"]];
	[_dropdownBtn setTitleColor:AppStyleSetting.sharedInstance.textColor];
	[_dropdownBtn addTarget:self action:@selector(dropdownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.titleView = _dropdownBtn;
	
	_dropdownMenu = [[DropDownMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)];
	[_dropdownMenu setAnchorView:_dropdownBtn];
	_dropdownMenu.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	[_dropdownMenu setDataSource:@[@"所有运动",@"健走",@"跑步",@"骑行"]];
	[_dropdownMenu setWidth: self.view.frame.size.width];
	[_dropdownMenu setDirectionBottom];
	[_dropdownMenu setBottomOffset:CGPointMake(0, 44)];
	switch (_transportMode) {
		case TransportModeNone:
			[_dropdownMenu selectRow:0 scrollPosition:UITableViewScrollPositionNone];
			break;
		case TransportModeWalking:
			[_dropdownMenu selectRow:1 scrollPosition:UITableViewScrollPositionNone];
			break;
		case TransportModeRunning:
			[_dropdownMenu selectRow:2 scrollPosition:UITableViewScrollPositionNone];
			break;
		case TransportModeRiding:
			[_dropdownMenu selectRow:3 scrollPosition:UITableViewScrollPositionNone];
			break;
		default:
			break;
	}
	__weak typeof(self) weakSelf = self;
	[_dropdownMenu setCancelCallback:^{
		[weakSelf.dropdownBtn cancelRotateImageView];
	}];
	[_dropdownMenu setSelectionCallback:^(NSInteger index,  NSString * _Nonnull textString){
		[weakSelf.dropdownBtn setTitle:textString];
		[weakSelf.dropdownBtn cancelRotateImageView];
		switch (index) {
			case 0:
				weakSelf.transportMode = TransportModeNone;
			break;
			case 1:
				weakSelf.transportMode = TransportModeWalking;
			break;
			case 2:
				weakSelf.transportMode = TransportModeRunning;
			break;
			case 3:
				weakSelf.transportMode = TransportModeRiding;
			break;
			default:
				break;
		}
		[weakSelf getAllMyTrackRecords];
	}];
}
	
- (void)initTrackTableView{
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
	switch (_transportMode) {
		case TransportModeWalking:
			[query whereKey:@"transportMode" equalTo:@(0)];
			break;
		case TransportModeRunning:
			[query whereKey:@"transportMode" equalTo:@(1)];
			break;
		case TransportModeRiding:
			[query whereKey:@"transportMode" equalTo:@(2)];
			break;
		default:
			break;
	}
	[query includeKey:@"user"];
	[query orderByDescending:@"startTime"];
	
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
			
			if (self.trackList.count > 0){
				[self.trackList removeAllObjects];
			}
			
			[objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				NSDictionary *object = obj;
				TrackRecord *trackRecord = [TrackRecord trackWithDictionary: object];
				[self.trackList addObject:trackRecord];
			}];
			
			[self constructTrackDictionary];
			[self.tableView reloadData];
		}
	}];
}

#pragma mark - Action
	 
- (void)dropdownBtnClicked:(UIButton*)sender{
	[_dropdownBtn rotateImageView];
	[_dropdownMenu showMenu];
}

- (void)openRecordView:(UIBarButtonItem*)sender{
	NewRecordViewController *recordVC = [[NewRecordViewController alloc] init];
	[self.navigationController pushViewController:recordVC animated:YES];
}

- (void)constructTrackDictionary{
	if (_trackList.count == 0) {
		return;
	}
	
	if (_yearMonthArray.count > 0) {
		[_yearMonthArray removeAllObjects];
	}
	
	if (_trackDic.count > 0) {
		[_trackDic removeAllObjects];
	}
	
	__block double totalDistance = 0;
	__block double totalInterval = 0;
	// 构造“年-月”的键数组
	[_trackList enumerateObjectsUsingBlock:^(TrackRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
		totalDistance += record.mileage;
		totalInterval += record.interval;
		NSString *monthKey = [NSString stringWithFormat:@"%ld-%ld", (long)record.year, (long)record.month];
		if (![self.yearMonthArray containsObject:monthKey]) {
			[self.yearMonthArray addObject:monthKey];
		}
	}];
	// 转换总里程为NSString
	[self totalDistanceToNSString:totalDistance];
	// 计算平均配速
	[self calculateAvgPaceSpeedWithTime:totalInterval Distance:totalDistance];
	// 遍历键数组组成键值对
	for (NSMutableString *monthKey in _yearMonthArray) {
		NSArray *keyArray = [monthKey componentsSeparatedByString:@"-"];
		NSInteger intYear = [keyArray[0] integerValue];
		NSInteger intMon = [keyArray[1] integerValue];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.year == %ld && SELF.month == %ld", intYear, intMon];
		NSMutableArray<TrackRecord*> *monthTrackArray = [[_trackList filteredArrayUsingPredicate:predicate] mutableCopy];
		[_trackDic setObject:monthTrackArray forKey:monthKey];
	}
}

- (void)updateTableViewSummaryCell{
	__weak typeof(self) weakSelf = self;
	__block double totalDistance = 0;
	__block double totalInterval = 0;
	// 构造“年-月”的键数组
	[weakSelf.trackList enumerateObjectsUsingBlock:^(TrackRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
		totalDistance += record.mileage;
		totalInterval += record.interval;
	}];
	// 转换总里程为NSString
	[weakSelf totalDistanceToNSString:totalDistance];
	// 计算平均配速
	[weakSelf calculateAvgPaceSpeedWithTime:totalInterval Distance:totalDistance];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	SummaryTableCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
	cell.distanceLabel.text = weakSelf.totalDistanceString;
	cell.timesLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_trackList.count];
	cell.paceSpeedLabel.text = weakSelf.avgPaceString;
}

- (void)totalDistanceToNSString:(double)distance{
	
	if (distance == 0) {
		_totalDistanceString = [NSMutableString stringWithString:@"0:00"];
	}
	
	_totalDistanceString = [NSMutableString stringWithFormat:@"%.2f", distance / 1000];
}

- (void)calculateAvgPaceSpeedWithTime:(double)interval Distance:(double)distance{
	
	if (interval == 0) {
		_avgPaceString = [NSMutableString stringWithString:@"0'00\""];
	}
	
	double minKmValue = interval / (distance / 1000);
	int floorMin = floor(minKmValue/60);
	int roundSec = round(minKmValue - (floorMin*60));
	if (roundSec == 60){
		floorMin += 1;
		roundSec = 0;
	}
	
	NSMutableString *formatt = [NSMutableString stringWithString:@"%d':%d\""];
	if (roundSec < 10) {
		formatt = [NSMutableString stringWithString:@"%d':0%d\""];
	}
	
	_avgPaceString = [NSMutableString stringWithFormat:formatt, floorMin, roundSec];
}

- (void)presentDeleteComfirmDialogWithIndexPath:(NSIndexPath*)indexPath{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请确认删除" message:@"删除记录将无法恢复" preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
	__weak typeof(self) weakSelf = self;
	UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		NSMutableArray *monthTrackArray = weakSelf.trackDic[weakSelf.yearMonthArray[indexPath.section - 1]];
		TrackRecord *record = monthTrackArray[indexPath.row];
		[weakSelf.trackList removeObject:record];
		
		AVObject *recordObj = [AVObject objectWithClassName:@"TrackRecord" objectId:record.objectId];
		[recordObj deleteInBackground];
		
		AVObject *imageObj = [AVObject objectWithClassName:@"_File" objectId:record.imageId];
		AVFile *file = [AVFile fileWithAVObject:imageObj];
		[file deleteWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
			
		}];
		
		AVQuery *query = [AVQuery queryWithClassName:@"MFLocation"];
		[query whereKey:@"trackId" equalTo:record.objectId];
		[query deleteAllInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
			
		}];
		[monthTrackArray removeObjectAtIndex:indexPath.row];
		[weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
		[weakSelf updateTableViewSummaryCell];
	}];
	
	[alertController addAction:cancel];
	[alertController addAction:delete];
	
	[self presentViewController:alertController animated:YES completion:nil];
}
	
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1 + _yearMonthArray.count;
}
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0){
		return 1;
	}
	else{
		NSString *key = _yearMonthArray[section - 1];
		NSArray *array = _trackDic[key];
		return array.count;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:
			return 210;
			break;
		default:
			return 100;
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 0;
	}
	else{
		return 50;
	}
}
	
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 0){
		SummaryTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"summaryCell" forIndexPath:indexPath];
		cell.distanceLabel.text = _totalDistanceString;
		cell.timesLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_trackList.count];
		cell.paceSpeedLabel.text = _avgPaceString;
		return cell;
	}
	else{
		NSString *key = _yearMonthArray[indexPath.section - 1];
		NSArray *array = _trackDic[key];
		TrackRecord *record = array[indexPath.row];
		TrackTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
		if (record.imageUrl == nil) {
			cell.trackImageView.image = [UIImage imageNamed:@"default_track"];
		}
		else{
			[cell.trackImageView sd_setImageWithURL:[NSURL URLWithString:record.imageUrl] placeholderImage:[UIImage imageNamed:@"default_track"]];
		}
		
		cell.startTimeLabel.text = record.startTimeString;
		cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f公里", record.mileage / 1000];
		cell.paceSpeedLabel.text = record.paceString;
		cell.durationLabel.text = record.minuteString;
		return cell;
	}
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	__weak typeof(self) weakSelf = self;
	UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf presentDeleteComfirmDialogWithIndexPath:indexPath];
	}];
	
	return @[delete];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section > 0) {
		MonthSectionHeader *header = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:@"monthHeader"];
		NSString *key = _yearMonthArray[section - 1];
		NSArray *keyArray = [key componentsSeparatedByString:@"-"];
		NSArray *recordArray = _trackDic[key];
		NSString *monthString = [NSString stringWithFormat:@"%@年%@月",keyArray[0], keyArray[1]];
		
		header.monthLabel.text = monthString;
		
		double distance = 0;
		double interval = 0;
		for (TrackRecord *record in recordArray) {
			distance += record.mileage;
			interval += record.interval;
		}
		
		if (interval == 0) {
			header.infoLabel.text = [NSString stringWithFormat:@"%lu次运动 0':00\"配速", (unsigned long)recordArray.count];
		}
		
		double minKmValue = interval / (distance / 1000);
		int floorMin = floor(minKmValue/60);
		int roundSec = round(minKmValue - (floorMin*60));
		if (roundSec == 60){
			floorMin += 1;
			roundSec = 0;
		}
		NSMutableString *formatt = [NSMutableString stringWithString:@"%d':%d\""];
		if (roundSec < 10) {
			formatt = [NSMutableString stringWithString:@"%d':0%d\""];
		}
		
		NSString *paceString = [NSString stringWithFormat:formatt, floorMin, roundSec];
		header.infoLabel.text = [NSString stringWithFormat:@"%lu次运动 %@配速", (unsigned long)recordArray.count, paceString];
		return header;
	}
	return nil;
}
	
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section > 0) {
		TrackRecord *trackRecord = self.trackList[indexPath.row];
		TrackDetailViewController *detailVC = [[TrackDetailViewController alloc] initWithStartTime:trackRecord.startTime FinishedTime:trackRecord.finishedTime TransportMode:trackRecord.transportMode TrackId:trackRecord.objectId];
		[self.navigationController pushViewController:detailVC animated:YES];
	}
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
