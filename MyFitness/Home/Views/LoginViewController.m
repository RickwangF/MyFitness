//
//  LoginViewController.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/23.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import <AVOSCloud/AVOSCloud.h>
#import <Toast/Toast.h>
#import "AppStyleSetting.h"
#import "RegisterViewController.h"
#import "LoginItemView.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UIView *firstContainerView;
@property (nonatomic, strong) UITextField *loginNameTextField;
@property (nonatomic, strong) UIView *secondContainerView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) LoginItemView *weiboView;
@property (nonatomic, strong) LoginItemView *weChatView;
@property (nonatomic, strong) LoginItemView *qqView;


@end

@implementation LoginViewController
	
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
    mainView.backgroundColor = UIColor.whiteColor;
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	
	[self initBackBtn];
    
    [self initSubViews];
	
	[self initThirdPartyLoginView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - Init Views

- (void)initBackBtn{
	_backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
	[_backBtn setImage:[UIImage imageNamed:@"close_22#42"] forState:UIControlStateNormal];
	[_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _backBtn];
}

- (void)initSubViews{
    
    _loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    _loginLabel.text = @"登录";
    _loginLabel.textColor = AppStyleSetting.sharedInstance.userCenterBgColor;
    _loginLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    [self.view addSubview:_loginLabel];
    
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(65);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideTop).offset(65);
        }
		make.left.equalTo(self.view).offset(30);
        make.height.equalTo(@30);
    }];
	
	_registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	[_registerBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
	[_registerBtn setTitleColor:[UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1] forState:UIControlStateNormal];
	_registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
	[_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_registerBtn];
	
	[_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.loginLabel);
		make.right.equalTo(self.view).offset(-30);
		make.height.equalTo(@20);
	}];
	
	_firstContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
	_firstContainerView.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
	_firstContainerView.layer.cornerRadius = 5.0;
	_firstContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_firstContainerView];
	
	[_firstContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.loginLabel.mas_bottom).offset(45);
		make.left.equalTo(self.view).offset(35);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@40);
	}];
    
    _loginNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    _loginNameTextField.placeholder = @"手机号或邮箱";
    _loginNameTextField.keyboardType = UIKeyboardTypeDefault;
    _loginNameTextField.textColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1];
    _loginNameTextField.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [_firstContainerView addSubview:_loginNameTextField];
	
	[_loginNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.firstContainerView);
		make.left.equalTo(self.firstContainerView).offset(15);
		make.right.equalTo(self.firstContainerView).offset(-15);
	}];
	
	_secondContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
	_secondContainerView.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
	_secondContainerView.layer.cornerRadius = 5.0;
	_secondContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_secondContainerView];
	
	[_secondContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(35);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@40);
	}];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    _passwordTextField.placeholder = @"输入密码";
    if (@available(iOS 11.0, *)) {
        _passwordTextField.textContentType = UITextContentTypePassword;
    }
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1];
    _passwordTextField.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [_secondContainerView addSubview:_passwordTextField];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.secondContainerView);
		make.left.equalTo(self.secondContainerView).offset(15);
		make.right.equalTo(self.secondContainerView).offset(-15);
    }];
	
	_forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
	[_forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
	[_forgetBtn setTitleColor:[UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1] forState:UIControlStateNormal];
	_forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:_forgetBtn];
	
	[_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.secondContainerView.mas_bottom).offset(15);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@30);
	}];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1] forState:UIControlStateNormal];
	_loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
	[_loginBtn setBackgroundColor: AppStyleSetting.sharedInstance.mainColor];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 5.0;
    _loginBtn.layer.shadowColor = AppStyleSetting.sharedInstance.mainColor.CGColor;
	_loginBtn.layer.shadowOpacity = 0.8;
	_loginBtn.layer.shadowOffset = CGSizeMake(0, 5);
	_loginBtn.layer.shadowRadius = 5.0;
    [self.view addSubview:_loginBtn];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondContainerView.mas_bottom).offset(75);
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.height.equalTo(@50);
    }];
}

- (void)initThirdPartyLoginView{
	CGFloat padding = (self.view.bounds.size.width - 135) / 4;
	_weiboView = [[LoginItemView alloc] initWithFrame:CGRectMake(0, 0, 45, 72)];
	[_weiboView setTitle:@"微博"];
	[_weiboView setImage:[UIImage imageNamed:@"weibo"]];
	[self.view addSubview:_weiboView];
	
	_weChatView = [[LoginItemView alloc] initWithFrame:CGRectMake(0, 0, 45, 72)];
	[_weChatView setTitle:@"微信"];
	[_weChatView setImage:[UIImage imageNamed:@"wechat"]];
	[self.view addSubview:_weChatView];
	
	_qqView = [[LoginItemView alloc] initWithFrame:CGRectMake(0, 0, 45, 72)];
	[_qqView setTitle:@"QQ"];
	[_qqView setImage:[UIImage imageNamed:@"qq"]];
	[self.view addSubview:_qqView];
	
	[@[_weiboView, _weChatView, _qqView] mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.loginBtn.mas_bottom).offset(75);
		make.height.equalTo(@72);
	}];
	
	[@[_weiboView, _weChatView, _qqView] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
}

#pragma mark - Actions

- (void)backBtnClicked:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerBtnClicked:(UIButton*)sender{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginBtnClicked:(UIButton*)sender{
    [self.view endEditing:YES];
    
    NSString *loginName = self.loginNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (loginName.length == 0 || [loginName isEqualToString:@""]) {
        [self.view makeToast:@"登录名不能为空"];
        return;
    }
    
    if (password.length == 0 || [password isEqualToString:@""]) {
        [self.view makeToast:@"密码不能为空"];
        return;
    }
    
    [AVUser logInWithUsernameInBackground:loginName password:password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (user != nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            if (error == nil) {
                [self.view makeToast:@"注册失败"];
                return;
            }
            
            [self.view makeToast:[NSString stringWithFormat:@"注册失败，%@", error.localizedDescription]];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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
