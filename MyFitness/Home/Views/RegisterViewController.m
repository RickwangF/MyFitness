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

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *registerLabel;
@property (nonatomic, strong) UITextField *loginNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation RegisterViewController
	
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
    
    _registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    _registerLabel.text = @"注册";
    _registerLabel.textColor = [UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1];
    _registerLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:_registerLabel];
    
    [self.registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(self.registerLabel.mas_bottom).offset(40);
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
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setBackgroundColor:[UIColor colorWithRed:32.0/255 green:38.0/255 blue:45.0/255 alpha:1]];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _registerBtn.layer.cornerRadius = 5.0;
    _registerBtn.clipsToBounds = YES;
    [self.view addSubview:_registerBtn];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(35);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@45);
    }];
}

#pragma mark - Actions

- (void)backBtnClicked:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerBtnClicked:(UIButton*)sender{
    
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
