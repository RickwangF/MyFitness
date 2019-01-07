//
//  LoginItemView.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/7.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "LoginItemView.h"
#import <Masonry/Masonry.h>

@interface LoginItemView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LoginItemView

#pragma mark - Init

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self initLoginBtnWithRect:CGRectZero];
		[self initTitleLabelWithRect:CGRectZero];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initLoginBtnWithRect:frame];
		[self initTitleLabelWithRect:frame];
	}
	return self;
}

#pragma mark - Init View

- (void)initLoginBtnWithRect:(CGRect)frame{
	_loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
	[self addSubview:_loginBtn];
	
	[_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self);
		make.height.width.equalTo(@(frame.size.width));
	}];
}

- (void)initTitleLabelWithRect:(CGRect)frame{
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 17)];
	_titleLabel.textColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
	_titleLabel.font = [UIFont systemFontOfSize:15];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:_titleLabel];
	
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.right.equalTo(self);
		make.height.equalTo(@17);
	}];
}

#pragma mark - Action

- (void)setImage:(UIImage *)image{
	[_loginBtn setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title{
	_titleLabel.text = title;
}


@end
