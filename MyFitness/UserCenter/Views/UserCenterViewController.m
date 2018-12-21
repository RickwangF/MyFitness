//
//  UserCenterViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "UserCenterViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <SDWebImage/UIView+WebCache.h>
#import <AVOSCloud/AVOSCloud.h>
#import "AvatarTableCell.h"
#import "FounctionTableCell.h"
#import "RecordTableCell.h"
#import "RecordItemView.h"
#import "UIDevice+Type.h"
#import "AppStyleSetting.h"
#import "BodyDataViewController.h"
#import "TransportModeEnum.h"
#import "TrackListViewController.h"
#import "RecordViewController.h"

@interface UserCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) AVUser *user;

@end

@implementation UserCenterViewController

#pragma mark - Init

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (void)initValueProperty{
	_user = [AVUser currentUser];
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
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	
	[self initInfoTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	[self.navigationController.navigationBar setTintColor:UIColor.whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
	[self.navigationController.navigationBar setTintColor:AppStyleSetting.sharedInstance.textColor];
}

#pragma mark - Init View

- (void)initInfoTableView{
	_infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 300) style:UITableViewStyleGrouped];
	_infoTableView.delegate = self;
	_infoTableView.dataSource = self;
	_infoTableView.backgroundColor = UIColor.whiteColor;
	_infoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	_infoTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.00001)];
	_infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_infoTableView.estimatedRowHeight = 0;
	_infoTableView.estimatedSectionHeaderHeight = 0;
	_infoTableView.estimatedSectionFooterHeight = 0;
	_infoTableView.sectionFooterHeight = 0;
	if (@available(iOS 11.0, *)) {
		_infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	UINib *avatarNib = [UINib nibWithNibName:@"AvatarTableCell" bundle:NSBundle.mainBundle];
	UINib *recordNib = [UINib nibWithNibName:@"RecordTableCell" bundle:NSBundle.mainBundle];
	UINib *founctionNib = [UINib nibWithNibName:@"FounctionTableCell" bundle:NSBundle.mainBundle];
	
	[_infoTableView registerNib:avatarNib forCellReuseIdentifier:@"avatarCell"];
	[_infoTableView registerNib:recordNib forCellReuseIdentifier:@"recordCell"];
	[_infoTableView registerNib:founctionNib forCellReuseIdentifier:@"founctionCell"];
	
	[self.view addSubview:_infoTableView];
	[_infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

#pragma mark - Request

#pragma mark - Action

- (void)openTrackListViewWithMode:(TransportModeEnum)mode{
	TrackListViewController *listVC = [[TrackListViewController alloc] initWithTransportMode:mode];
	[self.navigationController pushViewController:listVC animated:YES];
}

- (void)openRecordView{
	RecordViewController *recordVC = [[RecordViewController alloc] init];
	[self.navigationController pushViewController:recordVC animated:YES];
}

- (void)openBodyDataView{
	BodyDataViewController *bodyVC = [[BodyDataViewController alloc] init];
	[self.navigationController pushViewController:bodyVC animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	switch (section) {
		case 0:
			return 2;
		break;
		case 1:
			return 3;
		break;
		case 2:
			return 1;
		break;
		default:
			return 0;
		break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			if ([[UIDevice currentDevice] fullScreen]){
				return 240;
			}
			return 200;
		}
		else{
			return 110;
		}
	}
	else{
		return 55;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			AvatarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatarCell" forIndexPath:indexPath];
			cell.avatarImageView.image = [UIImage imageNamed:@"user_65#ff"];
			cell.loginNameLabel.text = _user.username;
			return cell;
		}
		else{
			RecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
			__weak typeof(self) weakSelf = self;
			cell.walkingRecView.actionBlock = ^{
				[weakSelf openTrackListViewWithMode:TransportModeWalking];
			};
			cell.runRecView.actionBlock = ^{
				[weakSelf openTrackListViewWithMode:TransportModeRunning];
			};
			cell.rideRecView.actionBlock = ^{
				[weakSelf openTrackListViewWithMode:TransportModeRiding];
			};
			return cell;
		}
	}
	else if (indexPath.section == 1){
		FounctionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"founctionCell" forIndexPath:indexPath];
		switch (indexPath.row) {
			case 0:
				cell.titleLabel.text = @"运动记录";
			break;
			case 1:
				cell.titleLabel.text = @"身体数据";
			break;
			case 2:
				cell.titleLabel.text = @"个人资料";
				[cell hideSeparator];
			break;
			default:
				break;
		}
		return cell;
	}
	else{
		FounctionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"founctionCell" forIndexPath:indexPath];
		cell.titleLabel.text = @"关于我们";
		[cell hideSeparator];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section != 0){
		return 10;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section != 0) {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
		headerView.backgroundColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
		return headerView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if (section == 2) {
		return 10;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if (section == 2) {
		UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
		footerView.backgroundColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
		return footerView;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		
	}
	else if (indexPath.section == 1){
		switch (indexPath.row) {
			case 0:
			[self openRecordView];
			break;
			case 1:
			[self openBodyDataView];
			break;
				
			default:
			break;
		}
	}
	else{
		
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
