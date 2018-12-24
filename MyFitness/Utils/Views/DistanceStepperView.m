//
//  DistanceStepperView.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "DistanceStepperView.h"
#import <Masonry/Masonry.h>
#import "AppStyleSetting.h"

@interface DistanceStepperView ()

@property (nonatomic, strong) UIButton *minusBtn;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, assign) NSInteger distance;

@end

@implementation DistanceStepperView

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
		[self initAddButtonWithFrame:frame];
		[self initDistanceLabelWithFrame:frame];
		[self initUnitLabel];
	}
	return self;
}

- (void)initValueProperty{
	_distance = 0;
}

#pragma mark - Init View

- (void)initMinusButtonWithFrame:(CGRect)frame{
	_minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.2*frame.size.width, frame.size.height)];
	[_minusBtn setImage:[UIImage imageNamed:@"left_solid25#42"] forState:UIControlStateNormal];
	[_minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_minusBtn];
	
	[_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.2);
		make.height.equalTo(self);
	}];
}

- (void)initDistanceLabelWithFrame:(CGRect)frame{
	_distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.6*frame.size.width, 80)];
	_distanceLabel.textAlignment = NSTextAlignmentCenter;
	_distanceLabel.text = @"0";
	_distanceLabel.textColor = AppStyleSetting.sharedInstance.homeStepperColor;
	_distanceLabel.font = [UIFont systemFontOfSize:80 weight:UIFontWeightBold];
	[self addSubview:_distanceLabel];
	
	[_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.minusBtn);
		make.height.equalTo(@80);
		make.right.equalTo(self.addBtn);
		make.centerY.equalTo(self);
	}];
}

- (void)initAddButtonWithFrame:(CGRect)frame{
	_addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0.2*frame.size.width, frame.size.height)];
	[_addBtn setImage:[UIImage imageNamed:@"right_solid25#42"] forState:UIControlStateNormal];
	[_addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_addBtn];
	
	[_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.right.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.2);
		make.height.equalTo(self);
	}];
}

- (void)initUnitLabel{
	_unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
	_unitLabel.textAlignment = NSTextAlignmentCenter;
	_unitLabel.text = @"公里";
	_unitLabel.textColor = AppStyleSetting.sharedInstance.homeStepperColor;
	_unitLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
	[_unitLabel sizeToFit];
	[self addSubview:_unitLabel];
	
	[_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.distanceLabel.mas_bottom).offset(10);
		make.height.equalTo(@20);
		make.centerX.equalTo(self);
	}];
}

#pragma mark - Action

- (void)minusBtnClicked:(UIButton*)sender{
	_distance -= 1;
	if (_distance < 0) {
		_distance = 0;
	}
	
	_distanceLabel.text = [NSString stringWithFormat:@"%ld", (long)_distance];
}

- (void)addBtnClicked:(UIButton*)sender{
	_distance += 1;
	_distanceLabel.text = [NSString stringWithFormat:@"%ld", (long)_distance];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
