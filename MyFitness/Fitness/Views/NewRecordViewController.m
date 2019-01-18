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
#import "AppStyleSetting.h"
#import "UIImage+UIColor.h"
#import "TrackRecord.h"
#import "MFLocation.h"
#import "RecBaseInfoTableCell.h"
#import "UIDevice+Type.h"

@interface NewRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *recordTableView;

@property (nonatomic, strong) NSMutableDictionary *recordDic;

@property (nonatomic, strong) NSMutableArray *trackArray;

@end

@implementation NewRecordViewController

#pragma mark - Init

- (instancetype)init
{
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void)initValueProperty{
	_recordDic = [[NSMutableDictionary alloc] init];
	_trackArray = [[NSMutableArray alloc] init];
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
    // Do any additional setup after loading the view.
}

#pragma mark - Init View

- (void)initRecordTableView{
	_recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 500) style:UITableViewStyleGrouped];
	_recordTableView.backgroundColor = UIColor.clearColor;
	_recordTableView.backgroundView = nil;
	_recordTableView.delegate = self;
	_recordTableView.dataSource = self;
	_recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	if (@available(iOS 11.0, *)) {
		_recordTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	_recordTableView.rowHeight = 100;
	
	_recordTableView.estimatedRowHeight = 0;
	_recordTableView.estimatedSectionHeaderHeight = 0;
	_recordTableView.estimatedSectionFooterHeight = 0;
	_recordTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.0001)];
	_recordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	
	UINib *recInfoNib = [UINib nibWithNibName:@"RecBaseInfoTableCell" bundle:NSBundle.mainBundle];
	[_recordTableView registerNib:recInfoNib forCellReuseIdentifier:@"recInfoCell"];
	
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
			}
		}
	}];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	RecBaseInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recInfoCell" forIndexPath:indexPath];
	if (indexPath.row == 0) {
		cell.indicatorView.image = [UIImage imageNamed:@"startspot_35#ffe617"];
		[cell changeIndicatorSize:CGSizeMake(35, 35)];
		[cell hideAboveLine];
	}
	else if (indexPath.row == 9) {
		[cell hideBelowLine];
	}
	return cell;
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
