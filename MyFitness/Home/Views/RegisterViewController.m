//
//  RegisterViewController.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/23.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "RegisterViewController.h"
#import <Masonry/Masonry.h>
#import <AVOSCloud/AVOSCloud.h>
#import <Toast/Toast.h>
#import "AppStyleSetting.h"
#import "SFVerificationCodeView.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *registerLabel;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *firstContainerView;
@property (nonatomic, strong) UITextField *loginNameTextField;
@property (nonatomic, strong) UIView *secondContainerView;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) SFVerificationCodeView *veriCodeView;
@property (nonatomic, strong) UIView *thirdContainerView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation RegisterViewController
	
#pragma mark - Init
	
- (instancetype)init{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		
	}
	return self;
}

- (void)initTapGesture{
	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UIViewTapped:)];
	[self.view addGestureRecognizer:_tapGesture];
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
	
	[self initTapGesture];
	
    [self initSubViews];
	
	_backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[_backBtn setImage:[UIImage imageNamed:@"left_22#00"] forState:UIControlStateNormal];
	[_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
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

- (void)initSubViews{
    
    _registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    _registerLabel.text = @"注册";
    _registerLabel.textColor = AppStyleSetting.sharedInstance.userCenterBgColor;
    _registerLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    [self.view addSubview:_registerLabel];
    
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(65);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideTop).offset(65);
        }
        make.left.equalTo(self.view).offset(30);
        make.height.equalTo(@30);
    }];
	
	_loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
	[_loginBtn setTitle:@"已有账号去登录" forState:UIControlStateNormal];
	[_loginBtn setTitleColor:[UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1] forState:UIControlStateNormal];
	_loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
	[_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_loginBtn];
	
	[_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.registerLabel);
		make.right.equalTo(self.view).offset(-30);
		make.height.equalTo(@20);
	}];
	
	_firstContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
	_firstContainerView.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
	_firstContainerView.layer.cornerRadius = 5.0;
	_firstContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_firstContainerView];
	
	[_firstContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.registerLabel.mas_bottom).offset(40);
		make.left.equalTo(self.view).offset(35);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@40);
	}];
    
	_loginNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	_loginNameTextField.delegate = self;
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
	
	_veriCodeView = [[SFVerificationCodeView alloc] initWithFrame:CGRectMake(0, 0, 105, 40)];
	_veriCodeView.mode = SFVerificationCodeModeLocal;
	_veriCodeView.length = 4;
	[_veriCodeView generateVerificationCode];
	[self.view addSubview:_veriCodeView];
	
	[_veriCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView.mas_bottom).offset(30);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@40);
		make.width.equalTo(@105);
	}];
	
	_secondContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	_secondContainerView.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
	_secondContainerView.layer.cornerRadius = 5.0;
	_secondContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_secondContainerView];
	
	[_secondContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.firstContainerView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(35);
		make.right.equalTo(self.veriCodeView.mas_left).offset(-10);
		make.height.equalTo(@40);
	}];
	
	_codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	_codeTextField.delegate = self;
	_codeTextField.placeholder = @"输入验证码";
	_codeTextField.keyboardType = UIKeyboardTypeDefault;
	_codeTextField.textColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1];
	_codeTextField.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
	[_secondContainerView addSubview:_codeTextField];
	
	[_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.secondContainerView);
		make.left.equalTo(self.secondContainerView).offset(15);
		make.right.equalTo(self.secondContainerView).offset(-15);
	}];
	
	_thirdContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
	_thirdContainerView.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
	_thirdContainerView.layer.cornerRadius = 5.0;
	_thirdContainerView.layer.masksToBounds = YES;
	[self.view addSubview:_thirdContainerView];
	
	[_thirdContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.secondContainerView.mas_bottom).offset(30);
		make.left.equalTo(self.view).offset(35);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@40);
	}];
    
	_passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
	_passwordTextField.delegate = self;
	_passwordTextField.placeholder = @"输入密码";
	if (@available(iOS 11.0, *)) {
		_passwordTextField.textContentType = UITextContentTypePassword;
	}
	_passwordTextField.secureTextEntry = YES;
	_passwordTextField.textColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1];
	_passwordTextField.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
	[_thirdContainerView addSubview:_passwordTextField];
	
	[self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self.thirdContainerView);
		make.left.equalTo(self.thirdContainerView).offset(15);
		make.right.equalTo(self.thirdContainerView).offset(-15);
	}];
    
	_registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
	[_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
	[_registerBtn setTitleColor:[UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1] forState:UIControlStateNormal];
	_registerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
	[_registerBtn setBackgroundColor: AppStyleSetting.sharedInstance.mainColor];
	[_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	_registerBtn.layer.cornerRadius = 5.0;
	_registerBtn.layer.shadowColor = AppStyleSetting.sharedInstance.mainColor.CGColor;
	_registerBtn.layer.shadowOpacity = 0.8;
	_registerBtn.layer.shadowOffset = CGSizeMake(0, 5);
	_registerBtn.layer.shadowRadius = 5.0;
	[self.view addSubview:_registerBtn];
	
	[_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.thirdContainerView.mas_bottom).offset(50);
		make.left.equalTo(self.view).offset(35);
		make.right.equalTo(self.view).offset(-35);
		make.height.equalTo(@50);
	}];
	
	_noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 17)];
	_noticeLabel.text = @"注册即同意";
	_noticeLabel.textColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
	_noticeLabel.font = [UIFont systemFontOfSize:15];
	[_noticeLabel sizeToFit];
	[self.view addSubview:_noticeLabel];
	
	[_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.registerBtn.mas_bottom).offset(30);
		make.right.equalTo(self.view.mas_centerX);
		make.height.equalTo(@17);
	}];
	
	_agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 17)];
	[_agreementBtn setTitle:@"< 用户协议 >" forState:UIControlStateNormal];
	[_agreementBtn setTitleColor:[UIColor colorWithRed:31.0/255 green:108.0/255 blue:249.0/255 alpha:1.0] forState:UIControlStateNormal];
	_agreementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
	[_agreementBtn sizeToFit];
	[self.view addSubview:_agreementBtn];
	
	[_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.registerBtn.mas_bottom).offset(30);
		make.left.equalTo(self.view.mas_centerX);
		make.height.equalTo(@17);
	}];
}

#pragma mark - Actions

- (void)UIViewTapped:(UITapGestureRecognizer*)sender{
	[self.view endEditing:YES];
}

- (void)backBtnClicked:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginBtnClicked:(UIButton*)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)registerBtnClicked:(UIButton*)sender{
    
    [self.view endEditing:YES];
    
    NSString *loginName = [_loginNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *veriCode = [[_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	
    if (loginName.length == 0 || [loginName isEqualToString:@""]) {
        [self.view makeToast:@"登录名不能为空"];
        return;
    }
    
    if (password.length == 0 || [password isEqualToString:@""]) {
        [self.view makeToast:@"密码不能为空"];
        return;
    }
	
	if (veriCode.length == 0 || [veriCode isEqualToString:@""]) {
		[self.view makeToast:@"验证码不能为空"];
		return;
	}
	
	if (![veriCode isEqualToString: [_veriCodeView.code lowercaseString]]) {
		[self.view makeToast:@"验证码错误"];
		return;
	}
    
    AVUser *user = [AVUser user];
    user.username = loginName;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.view makeToast:@"注册成功"];
            if ([AVUser currentUser] == nil) {
				[self.view makeToast:@"没有获取到当前用户"];
				return;
            }
			
			[self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
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
