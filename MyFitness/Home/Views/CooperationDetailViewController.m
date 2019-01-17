//
//  CooperationDetailViewController.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "CooperationDetailViewController.h"
#import <Masonry/Masonry.h>
#import <Toast/Toast.h>
#import "Cooperation.h"
#import "AppStyleSetting.h"
#import <SDWebImage//UIImageView+WebCache.h>
#import "UIDevice+Type.h"
#import <Hero/Hero-Swift.h>
#import "TopDismissScrollView.h"
#import "HeroIDModel.h"

@interface CooperationDetailViewController ()

@property (nonatomic, strong) Cooperation *cooperation;

@property (nonatomic, strong) TopDismissScrollView *mainScrollView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat availableWidth;

@property (nonatomic, assign) CGFloat topOffset;

@property (nonatomic, strong) HeroIDModel *heroIdModel;

@end

@implementation CooperationDetailViewController

#pragma mark - Init

- (instancetype)initWithCooperation:(Cooperation*)cooperation HeroId:(HeroIDModel*)idModel{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_cooperation = cooperation;
		_heroIdModel = idModel;
		[self initValueProperty];
	}
	return self;
}

- (void)initValueProperty{
	_topOffset = 420;
}

#pragma mark - Lift Circle

- (void)loadView{
	UIView *mainView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	mainView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.heroID = _heroIdModel.containerId;
	_availableWidth = self.view.frame.size.width;
	[self initMainScrollView];
	
	if (_cooperation.content != nil && _cooperation.content.count > 0) {
		[_cooperation.content enumerateObjectsUsingBlock:^(NSString* content, NSUInteger idx, BOOL * _Nonnull stop) {
			if (content != nil || ![content isEqualToString:@""]) {
				[self createTextViewWithContent:content Index:idx];
			}
		}];
	}
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Init View

- (void)initMainScrollView{
	_mainScrollView = [[TopDismissScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 500)];
	_mainScrollView.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
	_mainScrollView.contentSize = CGSizeMake(_availableWidth, 1200);
	if (@available(iOS 11.0, *)) {
		_mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else{
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self.view addSubview:_mainScrollView];
	
	[_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _availableWidth, 400)];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[_imageView sd_setImageWithURL:[NSURL URLWithString:_cooperation.imageUrl]];
	_imageView.clipsToBounds = YES;
	_imageView.heroID = _heroIdModel.imageId;
	[_mainScrollView addSubview:_imageView];
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
	_titleLabel.numberOfLines = 0;
	_titleLabel.text = _cooperation.title;
	_titleLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	if (_cooperation.darkImage) {
		_titleLabel.textColor = UIColor.whiteColor;
	}
	_titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightSemibold];
	_titleLabel.heroID = _heroIdModel.titleId;
	[_imageView addSubview:_titleLabel];
	
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		if ([[UIDevice currentDevice] fullScreen]) {
			make.top.equalTo(self.imageView).offset(50);
		}
		else{
			make.top.equalTo(self.imageView).offset(40);
		}
		make.left.equalTo(self.imageView).offset(20);
		make.right.equalTo(self.imageView).offset(-20);
		make.height.greaterThanOrEqualTo(@28);
	}];
}

- (void)createTextViewWithContent:(NSString*)content Index:(NSInteger)index{
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, _topOffset, _availableWidth - 40, 100)];
	textView.editable = NO;
	NSMutableParagraphStyle *paragrah = [[NSMutableParagraphStyle alloc] init];
	paragrah.lineSpacing = 14;
	paragrah.firstLineHeadIndent = 20;
	NSDictionary *dic = @{
						  NSForegroundColorAttributeName: AppStyleSetting.sharedInstance.homeStepperColor,
						  NSFontAttributeName: [UIFont systemFontOfSize:14],
						  NSParagraphStyleAttributeName: paragrah
						  };
	textView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:dic];
	textView.frame = CGRectMake(20, _topOffset, _availableWidth - 40, textView.contentSize.height);
	[_mainScrollView addSubview:textView];
	
	_topOffset += textView.contentSize.height + 20;
	if (index == _cooperation.content.count - 1) {
		_mainScrollView.contentSize = CGSizeMake(_availableWidth, _topOffset);
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
