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
#import "ActionSheetPicker.h"

@interface BodyDataViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *dataTableView;

@property (nonatomic, strong) NSMutableArray *ageArray;

@property (nonatomic, strong) NSArray *genderArray;

@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, strong) NSMutableArray *weightArray;

@property (nonatomic, strong) NSMutableString *ageString;

@property (nonatomic, strong) NSMutableString *genderString;

@property (nonatomic, strong) NSMutableString *heightString;

@property (nonatomic, strong) NSMutableString *weightString;

@property (nonatomic, strong) AVUser *user;


@end

@implementation BodyDataViewController

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
	_ageArray = [[NSMutableArray alloc] init];
	_genderArray = @[@"男",@"女",];
	_heightArray = [[NSMutableArray alloc] init];
	_weightArray = [[NSMutableArray alloc] init];
	_ageString = [NSMutableString new];
	_genderString = [NSMutableString new];
	_heightString = [NSMutableString new];
	_weightString = [NSMutableString new];
	for (int i=4; i<120; i++) {
		@autoreleasepool {
			NSString *ageString = [NSString stringWithFormat:@"%d 岁", i];
			[_ageArray addObject:ageString];
		}
	}
	for (int i=90; i<226; i++) {
		@autoreleasepool {
			NSString *heightString = [NSString stringWithFormat:@"%d 厘米", i];
			[_heightArray addObject:heightString];
		}
	}
	for (int i=13; i<230; i++) {
		@autoreleasepool {
			NSString *weightString = [NSString stringWithFormat:@"%d 公斤", i];
			[_weightArray addObject:weightString];
		}
	}
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
	
	[self initDataTableView];
	
	[self getMyBodyData];
	
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

#pragma mark - Request

- (void)getMyBodyData{
	NSString *age = [_user objectForKey:@"age"];
	NSString *gender = [_user objectForKey:@"gender"];
	NSString *height = [_user  objectForKey:@"height"];
	NSString *weight = [_user objectForKey:@"weight"];
	
	if (age != nil && ![age isEqualToString:@""]) {
		_ageString = [NSMutableString stringWithString:age];
	}
	
	if (gender != nil && ![age isEqualToString:@""]) {
		_genderString = [NSMutableString stringWithString:gender];
	}
	
	if (height != nil && ![height isEqualToString:@""]) {
		_heightString = [NSMutableString stringWithString:height];
	}
	
	if (weight != nil && ![weight isEqualToString:@""]) {
		_weightString = [NSMutableString stringWithString:weight];
	}
	
	[_dataTableView reloadData];
}

#pragma mark - Action

- (void)setAgeWithString:(NSString*)ageString{
	BodyTableCell *cell = [_dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	cell.valueLabel.text = ageString;
	[_user setObject:ageString forKey:@"age"];
	[_user saveInBackground];
}

- (void)setGenderWithString:(NSString*)genderString{
	BodyTableCell *cell = [_dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	cell.valueLabel.text = genderString;
	[_user setObject:genderString forKey:@"gender"];
	[_user saveInBackground];
}

- (void)setHeightWithString:(NSString*)heightString{
	BodyTableCell *cell = [_dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	cell.valueLabel.text = heightString;
	[_user setObject:heightString forKey:@"height"];
	[_user saveInBackground];
}

- (void)setWeightWithString:(NSString*)weightString{
	BodyTableCell *cell = [_dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	cell.valueLabel.text = weightString;
	[_user setObject:weightString forKey:@"weight"];
	[_user saveInBackground];
}

- (void)openAgePickerViewWithAgeString:(NSString*)string{
	NSInteger index = [_ageArray indexOfObject:string];
	ActionSheetStringPicker *agePicker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:_ageArray initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
		[self setAgeWithString:(NSString *)selectedValue];
	} cancelBlock:nil origin:_dataTableView];
	agePicker.tapDismissAction = TapActionCancel;
	
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[doneBtn setTitle:@"确定" forState:UIControlStateNormal];
	[doneBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	[agePicker setDoneButton:doneBarBtn];
	
	UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	[cancelBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
	[agePicker setCancelButton:cancelBarBtn];
	
	[agePicker showActionSheetPicker];
}

- (void)openGenderPickerViewWithGenderString:(NSString*)string{
	NSInteger index = [_genderArray indexOfObject:string];
	ActionSheetStringPicker *genderPicker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:_genderArray initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
		[self setGenderWithString:(NSString *)selectedValue];
	} cancelBlock:nil origin:_dataTableView];
	genderPicker.tapDismissAction = TapActionCancel;
	
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[doneBtn setTitle:@"确定" forState:UIControlStateNormal];
	[doneBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	[genderPicker setDoneButton:doneBarBtn];
	
	UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	[cancelBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
	[genderPicker setCancelButton:cancelBarBtn];
	
	[genderPicker showActionSheetPicker];
}

- (void)openHeightPickerViewWithHeightString:(NSString*)string{
	NSInteger index = [_heightArray indexOfObject:string];
	ActionSheetStringPicker *heightPicker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:_heightArray initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
		[self setHeightWithString:(NSString *)selectedValue];
	} cancelBlock:nil origin:_dataTableView];
	heightPicker.tapDismissAction = TapActionCancel;
	
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[doneBtn setTitle:@"确定" forState:UIControlStateNormal];
	[doneBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	[heightPicker setDoneButton:doneBarBtn];
	
	UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	[cancelBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
	[heightPicker setCancelButton:cancelBarBtn];
	
	[heightPicker showActionSheetPicker];
}

- (void)openWeightPickerViewWithWeightString:(NSString*)string{
	NSInteger index = [_weightArray indexOfObject:string];
	ActionSheetStringPicker *weightPicker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:_weightArray initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
		[self setWeightWithString:(NSString *)selectedValue];
	} cancelBlock:nil origin:_dataTableView];
	weightPicker.tapDismissAction = TapActionCancel;
	
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[doneBtn setTitle:@"确定" forState:UIControlStateNormal];
	[doneBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	[weightPicker setDoneButton:doneBarBtn];
	
	UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
	[cancelBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
	[weightPicker setCancelButton:cancelBarBtn];
	
	[weightPicker showActionSheetPicker];
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
			if (![_ageString isEqualToString:@""]) {
				cell.valueLabel.text = _ageString;
			}
		}
		else{
			cell.titleLabel.text = @"性别";
			if (![_genderString isEqualToString:@""]) {
				cell.valueLabel.text = _genderString;
			}
		}
	}
	else{
		if (indexPath.row == 0) {
			cell.titleLabel.text = @"身高";
			[cell showSeparator];
			if (![_heightString isEqualToString:@""]) {
				cell.valueLabel.text = _heightString;
			}
		}
		else{
			cell.titleLabel.text = @"体重";
			if (![_weightString isEqualToString:@""]) {
				cell.valueLabel.text = _weightString;
			}
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
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			BodyTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			NSString *ageString;
			if (![_ageArray containsObject: cell.valueLabel.text]) {
				ageString = @"4 岁";
			}
			else{
				ageString = cell.valueLabel.text;
			}
			[self openAgePickerViewWithAgeString:ageString];
		}
		else{
			BodyTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			NSString *genderString;
			if (![_genderArray containsObject: cell.valueLabel.text]) {
				genderString = @"男";
			}
			else{
				genderString = cell.valueLabel.text;
			}
			[self openGenderPickerViewWithGenderString:genderString];
		}
	}
	else{
		if (indexPath.row == 0) {
			BodyTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			NSString *heightString;
			if (![_ageArray containsObject: cell.valueLabel.text]) {
				heightString = @"175 厘米";
			}
			else{
				heightString = cell.valueLabel.text;
			}
			[self openHeightPickerViewWithHeightString:heightString];
		}
		else{
			BodyTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			NSString *weightString;
			if (![_ageArray containsObject: cell.valueLabel.text]) {
				weightString = @"65 公斤";
			}
			else{
				weightString = cell.valueLabel.text;
			}
			[self openWeightPickerViewWithWeightString:weightString];
		}
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
