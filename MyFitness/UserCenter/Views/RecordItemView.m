//
//  RecordItemView.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "RecordItemView.h"
#import <Masonry/Masonry.h>
#import "AppStyleSetting.h"

@implementation RecordItemView

#pragma mark - Init

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self initValueProperty];
		[self initSubViewWithFrame:CGRectNull];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initValueProperty];
		[self initSubViewWithFrame:frame];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self initValueProperty];
		[self initSubViewWithFrame:self.frame];
	}
	return self;
}

- (void)initValueProperty{
	_imageHeight = 35;
	_labelHeight = 20;
	_topOffset = (self.frame.size.height - _imageHeight - _labelHeight - 10)/2;
	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
	[self addGestureRecognizer:_tapGesture];
}

- (void)initSubViewWithFrame:(CGRect)frame{
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageHeight, _imageHeight)];
	_imageView.image = [UIImage imageNamed:@"sport_40#51"];
	[self addSubview:_imageView];
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _labelHeight)];
	_titleLabel.text = @"未设置";
	_titleLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_titleLabel.font = [UIFont systemFontOfSize:16];
	[self addSubview:_titleLabel];
	
	[_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(self).offset(self.topOffset);
		make.height.width.equalTo(@(self.imageHeight));
	}];
	
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.imageView.mas_bottom).offset(10);
		make.centerX.equalTo(self);
		make.height.equalTo(@(self.labelHeight));
	}];
}

#pragma mark - Action

- (void)setImage:(UIImage*)image{
	_imageView.image = image;
}

- (void)setTitle:(NSString*)title{
	_titleLabel.text = title;
}

- (void)setTitleColor:(UIColor*)color{
	_titleLabel.textColor = color;
}

- (void)setTitleFont:(UIFont*)font{
	_titleLabel.font = font;
}

- (void)tapGestureRecognized:(UITapGestureRecognizer*)sender{
	if (_actionBlock != nil) {
		self.actionBlock();
	}
}

@end
