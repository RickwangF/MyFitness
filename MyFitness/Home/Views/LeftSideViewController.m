//
//  LeftSideViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/12.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "LeftSideViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import <AVOSCloud/AVOSCloud.h>
#import "AppStyleSetting.h"
#import "UIDevice+Type.h"
#import "ButtonItemView.h"
#import "SubViewControllerDelegate.h"

@interface LeftSideViewController ()

@property (nonatomic, strong) UIView *topContainerView;

@property (nonatomic, strong) UIButton *userNameBtn;

@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, strong) ButtonItemView *mileageItemView;

@property (nonatomic, strong) ButtonItemView *recordItemView;

@property (nonatomic, strong) ButtonItemView *cooperateItemView;

@property (nonatomic, strong) ButtonItemView *settingItemView;

@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) ButtonItemView *privacyItemView;

@property (nonatomic, strong) UIButton *arrowBtn;

@end

@implementation LeftSideViewController

#pragma mark - Init

- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		
	}
	return self;
}

#pragma mark - Lift Circle

- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mainView.backgroundColor = [UIColor whiteColor];
	self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initTopContainerView];
	
	[self initButtonItemView];
	
	[self initBottomContainerView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Init Views

- (void)initTopContainerView{
	_topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
	_topContainerView.backgroundColor = AppStyleSetting.sharedInstance.leftSideVCBgColor;
	[self.view addSubview:_topContainerView];
	
	[_topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self.view);
		if ([[UIDevice currentDevice] fullScreen]){
			make.height.equalTo(@138);
		}
		else{
			make.height.equalTo(@114);
		}
	}];
	
	_avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
	_avatarBtn.backgroundColor = UIColor.whiteColor;
	_avatarBtn.layer.cornerRadius = 25;
	//_avatarBtn.layer.masksToBounds = YES;
	[_avatarBtn addTarget:self action:@selector(topContainerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	// 未设置用户头像
	[_avatarBtn setImage:[UIImage imageNamed:@"avatar_30#91"] forState:UIControlStateNormal];
	[_topContainerView addSubview:_avatarBtn];
	
	[_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.topContainerView).offset(20);
		make.width.height.equalTo(@50);
		make.bottom.equalTo(self.topContainerView).offset(-25);
	}];
	
	_userNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 26)];
	if ([AVUser currentUser] == nil) {
		[_userNameBtn setTitle:@"未登录" forState:UIControlStateNormal];
	}
	else{
		[_userNameBtn setTitle:[AVUser currentUser].username forState:UIControlStateNormal];
	}
	[_userNameBtn setTitleColor:AppStyleSetting.sharedInstance.textColor forState:UIControlStateNormal];
	_userNameBtn.titleLabel.font = [UIFont systemFontOfSize:20];
	[_userNameBtn addTarget:self action:@selector(topContainerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_topContainerView addSubview:_userNameBtn];
	
	[_userNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.avatarBtn.mas_right).offset(10);
		make.centerY.equalTo(self.avatarBtn);
		make.height.equalTo(@26);
	}];
}

- (void)initButtonItemView{
	_mileageItemView = [[ButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
	[_mileageItemView setImage:[UIImage imageNamed:@"mileage_25#00"]];
	[_mileageItemView setTitle:@"里程"];
	[_mileageItemView addTarget:self action:@selector(mileageItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_mileageItemView];
	
	[_mileageItemView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.topContainerView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(30);
		make.width.equalTo(@80);
		make.height.equalTo(@25);
	}];
	
	_recordItemView = [[ButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
	[_recordItemView setImage:[UIImage imageNamed:@"record_25#00"]];
	[_recordItemView setTitle:@"记录"];
	[_recordItemView addTarget:self action:@selector(recordItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_recordItemView];
	
	[_recordItemView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mileageItemView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(30);
		make.width.equalTo(@80);
		make.height.equalTo(@25);
	}];
	
	_cooperateItemView = [[ButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
	[_cooperateItemView setImage:[UIImage imageNamed:@"cooperate_25#00"]];
	[_cooperateItemView setTitle:@"合作"];
	[_cooperateItemView addTarget:self action:@selector(cooperateItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_cooperateItemView];
	
	[_cooperateItemView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.recordItemView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(30);
		make.width.equalTo(@80);
		make.height.equalTo(@25);
	}];
	
	_settingItemView = [[ButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
	[_settingItemView setImage:[UIImage imageNamed:@"setting_25#00"]];
	[_settingItemView setTitle:@"设置"];
	[_settingItemView addTarget:self action:@selector(settingItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_settingItemView];
	
	[_settingItemView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.cooperateItemView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(30);
		make.width.equalTo(@80);
		make.height.equalTo(@25);
	}];
}

- (void)initBottomContainerView{
	_bottomContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
	[self.view addSubview:_bottomContainerView];
	
	[_bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.right.equalTo(self.view);
		if ([[UIDevice currentDevice] fullScreen]) {
			make.height.equalTo(@75);
		}
		else{
			make.height.equalTo(@50);
		}
	}];
	
	UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
	separator.backgroundColor = AppStyleSetting.sharedInstance.lightSeparatorColor;
	[_bottomContainerView addSubview:separator];
	
	_privacyItemView = [[ButtonItemView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
	[_privacyItemView setTitle:@"隐私协议"];
	[_privacyItemView setImage:[UIImage imageNamed:@"privacy_16#00"]];
	[_privacyItemView setTitleFont:[UIFont systemFontOfSize:14]];
	[_privacyItemView addTarget:self action:@selector(privacyItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_bottomContainerView addSubview:_privacyItemView];
	
	[_privacyItemView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.bottomContainerView).offset(20);
		make.width.equalTo(@80);
		make.height.equalTo(@20);
		if ([[UIDevice currentDevice] fullScreen]) {
			make.centerY.equalTo(self.bottomContainerView).offset(-12.5);
		}
		else{
			make.centerY.equalTo(self.bottomContainerView);
		}
	}];
	
	_arrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
	[_arrowBtn setImage:[UIImage imageNamed:@"right_18#91"] forState:UIControlStateNormal];
	[_arrowBtn addTarget:self action:@selector(privacyItemViewClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_bottomContainerView addSubview:_arrowBtn];
	
	[_arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.bottomContainerView).offset(-15);
		make.width.height.equalTo(@25);
		make.centerY.equalTo(self.privacyItemView);
	}];
}

#pragma mark - Action

- (void)topContainerBtnClicked:(UIButton*)sender{
	
}

- (void)mileageItemViewClicked:(UIControl*)sender{
	[self dismissViewControllerAnimated:YES completion:^{
		if (self.delegate != nil) {
			[self.delegate leftSideViewControllerMakePushWithFlag:1];
		}
	}];
}

- (void)recordItemViewClicked:(UIControl*)sender{
	
}

- (void)cooperateItemViewClicked:(UIControl*)sender{
	
}

- (void)settingItemViewClicked:(UIControl*)sender{
	
}

- (void)privacyItemViewClicked:(UIControl*)sender{
	
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
