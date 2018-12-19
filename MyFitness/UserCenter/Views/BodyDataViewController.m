//
//  BodyDataViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "BodyDataViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "AvatarTableCell.h"
#import "FounctionTableCell.h"
#import "RecordTableCell.h"
#import "RecordItemView.h"
#import "AppStyleSetting.h"
#import "BodyTableCell.h"
#import "DescriptionHeaderView.h"
#import "UIImage+UIColor.h"

@interface BodyDataViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *dataTableView;

@end

@implementation BodyDataViewController

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
	
	self.title = @"身体数据";
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithUIColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
	
	[self initDataTableView];
    // Do any additional setup after loading the view.
}

#pragma mark - Init View

- (void)initDataTableView{
	_dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 300) style:UITableViewStyleGrouped];
	_dataTableView.delegate = self;
	_dataTableView.dataSource = self;
	_dataTableView.backgroundColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
	_dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	_dataTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.00001)];
	_dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_dataTableView.estimatedRowHeight = 0;
	_dataTableView.estimatedSectionHeaderHeight = 0;
	_dataTableView.estimatedSectionFooterHeight = 0;
	_dataTableView.sectionFooterHeight = 0;
	if (@available(iOS 11.0, *)) {
		_dataTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	UINib *bodyNib = [UINib nibWithNibName:@"BodyTableCell" bundle:NSBundle.mainBundle];
	UINib *descNib = [UINib nibWithNibName:@"DescriptionHeaderView" bundle:NSBundle.mainBundle];
	[_dataTableView registerNib:bodyNib forCellReuseIdentifier:@"bodyCell"];
	[_dataTableView registerNib:descNib forHeaderFooterViewReuseIdentifier:@"descHeader"];
	
	[self.view addSubview:_dataTableView];
	[_dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		if (@available(iOS 11.0, *)){
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
		}
		else{
			make.top.equalTo(self.mas_topLayoutGuideTop);
		}
		make.left.bottom.right.equalTo(self.view);
	}];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return 2;
	}
	else{
		return 2;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	BodyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bodyCell" forIndexPath:indexPath];
	if (indexPath.section == 0){
		if (indexPath.row == 0) {
			cell.titleLabel.text = @"年龄";
			[cell showSeparator];
		}
		else{
			cell.titleLabel.text = @"性别";
		}
	}
	else{
		if (indexPath.row == 0) {
			cell.titleLabel.text = @"身高";
			[cell showSeparator];
		}
		else{
			cell.titleLabel.text = @"体重";
		}
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0){
		return 130;
	}
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		DescriptionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"descHeader"];
		return header;
	}
	else{
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
		headerView.backgroundColor = AppStyleSetting.sharedInstance.wideSeparatorColor;
		return headerView;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
