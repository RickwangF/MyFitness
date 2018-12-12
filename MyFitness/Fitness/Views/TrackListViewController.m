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
	
	[self initValueProperty];
	
	[self initTrackTableView];
	
	[self getAllMyTrackRecords];
    // Do any additional setup after loading the view.
}
	
#pragma mark - Init Views
	
-(void) initTrackTableView{
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.backgroundColor = [UIColor whiteColor];
	_tableView.rowHeight = 50;
	_tableView.estimatedRowHeight = 0;
	_tableView.estimatedSectionHeaderHeight = 0;
	_tableView.estimatedSectionFooterHeight = 0;
	_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	
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
	
#pragma mark - UITableViewDelegate
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _trackList.count;
}
	
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	TrackRecord *trackRecord = self.trackList[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"Record:%@  startTime:%@  finishedTime:%@",trackRecord.objectId, trackRecord.startTimeString, trackRecord.finishedTimeString];
	return cell;
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
