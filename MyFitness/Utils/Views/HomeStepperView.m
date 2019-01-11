//
//  DistanceStepperView.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "HomeStepperView.h"
#import <Masonry/Masonry.h>
#import "AppStyleSetting.h"

@interface HomeStepperView ()

@property (nonatomic, strong) UIButton *minusBtn;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) AlertTypeEnum alertType;

@end

@implementation HomeStepperView

#pragma mark - Init

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initValueProperty];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self initValueProperty];
		[self initMinusButtonWithFrame:frame];
		[self initCenterViewWithFrame:frame];
		[self initAddButtonWithFrame:frame];
		[self initTitleLabel];
		[self initUnitLabel];
		[self initNumberLabel];
	}
	return self;
}

- (void)initValueProperty{
	_number = 0;
	_alertType = AlertTypeEnumDistance;
}

#pragma mark - Init View

- (void)initMinusButtonWithFrame:(CGRect)frame{
	_minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.2*frame.size.width, frame.size.height)];
	[_minusBtn setImage:[UIImage imageNamed:@"left_solid25#87"] forState:UIControlStateNormal];
	[_minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_minusBtn];
	
	[_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.2);
		make.height.equalTo(self);
	}];
}

- (void)initCenterViewWithFrame:(CGRect)frame{
	_centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6 * frame.size.width, frame.size.height)];
	[self addSubview:_centerView];
	
	[_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(self);
		make.left.equalTo(self.minusBtn.mas_right);
		make.width.equalTo(self).multipliedBy(0.6);
		make.height.equalTo(self);
	}];
}

- (void)initAddButtonWithFrame:(CGRect)frame{
	_addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.2*frame.size.width, frame.size.height)];
	[_addBtn setImage:[UIImage imageNamed:@"right_solid25#87"] forState:UIControlStateNormal];
	[_addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_addBtn];
	
	[_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.right.equalTo(self);
		make.left.equalTo(self.centerView.mas_right);
		make.height.equalTo(self);
	}];
}

- (void)initTitleLabel{
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_titleLabel.font = [UIFont systemFontOfSize:20];
	[_centerView addSubview:_titleLabel];
	
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self.centerView);
		make.height.equalTo(@20);
	}];
}

- (void)initUnitLabel{
	_unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 15)];
	_unitLabel.textAlignment = NSTextAlignmentCenter;
	_unitLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_unitLabel.font = [UIFont systemFontOfSize:15];
	[_centerView addSubview:_unitLabel];
	
	[_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.right.equalTo(self.centerView);
		make.height.equalTo(@20);
	}];
}

- (void)initNumberLabel{
	_numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
	_numberLabel.text = @"0";
	_numberLabel.textColor = AppStyleSetting.sharedInstance.homeStepperColor;
	_numberLabel.font = [UIFont systemFontOfSize:60 weight:UIFontWeightBold];
	_numberLabel.textAlignment = NSTextAlignmentCenter;
	[_centerView addSubview:_numberLabel];
	
	[_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.titleLabel.mas_bottom);
		make.left.right.equalTo(self.centerView);
		make.bottom.equalTo(self.unitLabel.mas_top);
	}];
}

#pragma mark - Action

- (void)minusBtnClicked:(UIButton*)sender{
	
	if (_alertType == AlertTypeEnumDistance) {
		_number -= 1;
	}
	else{
		_number -= 5;
	}
	
	if (_number < 0) {
		_number = 0;
	}
	
	_numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
}

- (void)addBtnClicked:(UIButton*)sender{
	if (_alertType == AlertTypeEnumDistance) {
		_number += 1;
	}
	else{
		_number += 5;
	}
	_numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
}

- (void)setTitleWithString:(NSString *)title{
	_titleLabel.text = title;
}

- (void)setUnitWithString:(NSString *)unit{
	_unitLabel.text = unit;
}

- (void)setAlertType:(AlertTypeEnum)type{
	_alertType = type;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
