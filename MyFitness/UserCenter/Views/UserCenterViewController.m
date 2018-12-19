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
#import <AVOSCloud/AVOSCloud.h>
#import "AvatarTableCell.h"
#import "FounctionTableCell.h"
#import "RecordTableCell.h"
#import "RecordItemView.h"
#import "UIDevice+Type.h"
#import "AppStyleSetting.h"

@interface UserCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *infoTableView;

@end

@implementation UserCenterViewController

#pragma mark - Init

- (instancetype)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		
	}
	return self;
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return 2;
	}
	else{
		return 4;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return 180;
		}
		else{
			return 100;
		}
	}
	else{
		return 50;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			AvatarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatarCell" forIndexPath:indexPath];
			return cell;
		}
		else{
			RecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
			return cell;
		}
	}
	else{
		FounctionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"founctionCell" forIndexPath:indexPath];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 1){
		return 10;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section == 1) {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
		headerView.backgroundColor = AppStyleSetting.sharedInstance.lightSeparatorColor;
		return headerView;
	}
	return nil;
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
