//
//  PageItemViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "PageItemViewController.h"
#import <Masonry/Masonry.h>
#import "SubViewControllerDelegate.h"
#import "AppStyleSetting.h"

@interface PageItemViewController ()
	
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation PageItemViewController
	
#pragma  mark - Init
	
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
	mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self initStartBtn];
    // Do any additional setup after loading the view.
}
	
#pragma mark - Init View
	
- (void)initStartBtn{
	self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[self.startBtn setTitle:@"开始" forState:UIControlStateNormal];
	[self.startBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[self.startBtn setBackgroundColor: AppStyleSetting.sharedInstance.mainColor];
	[self.startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	self.startBtn.layer.cornerRadius = 50;
	self.startBtn.layer.masksToBounds = YES;
	
	[self.view addSubview:self.startBtn];
	
	[self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-40);
		make.centerX.equalTo(self.view);
		make.width.height.equalTo(@100);
	}];
}
	
#pragma mark - Action
	
- (void)startBtnClicked:(UIButton*)sender{
	if (self.delegate != nil) {
		[self.delegate subViewControllerMakePush];
	}
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
