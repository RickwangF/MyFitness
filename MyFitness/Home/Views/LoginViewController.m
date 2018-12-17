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
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UITextField *loginNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;

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
    
    [self initSubViews];
	
	_backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
	[_backBtn setTitle:@"关闭" forState:UIControlStateNormal];
	[_backBtn setTitleColor:[UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1] forState:UIControlStateNormal];
	_backBtn.titleLabel.font = [UIFont systemFontOfSize:20];
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
    
    _loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    _loginLabel.text = @"登录";
    _loginLabel.textColor = [UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1];
    _loginLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:_loginLabel];
    
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(70);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideTop).offset(70);
        }
        make.centerX.equalTo(self.view);
        make.height.equalTo(@35);
    }];
    
    _loginNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    _loginNameTextField.placeholder = @"手机号";
    _loginNameTextField.keyboardType = UIKeyboardTypePhonePad;
    if (@available(iOS 10.0, *)) {
        _loginNameTextField.textContentType = UITextContentTypeTelephoneNumber;
    }
    _loginNameTextField.textColor = [UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1];
    _loginNameTextField.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [self.view addSubview:_loginNameTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    _passwordTextField.placeholder = @"密码";
    if (@available(iOS 11.0, *)) {
        _passwordTextField.textContentType = UITextContentTypePassword;
    }
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textColor = [UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1];
    _passwordTextField.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [self.view addSubview:_passwordTextField];
    
    [self.loginNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginLabel.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@45);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginNameTextField.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@45);
    }];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1]];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 5.0;
    _loginBtn.clipsToBounds = YES;
    [self.view addSubview:_loginBtn];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(35);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@45);
    }];
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [_registerBtn setTitle:@"没有账号，去注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@25);
    }];
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
