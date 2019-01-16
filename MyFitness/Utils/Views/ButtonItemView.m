//
//  ButtonItemView.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/12.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "ButtonItemView.h"
#import "AppStyleSetting.h"
#import <Masonry/Masonry.h>

@interface ButtonItemView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat imageViewMarginLeft;

@property (nonatomic, assign) CGFloat imageViewMarginRight;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) CGFloat textOriginX;

@end

@implementation ButtonItemView

#pragma mark - Init

- (instancetype)init
{
	self = [super init];
	if (self) {
		_itemHeight = 25;
		_imageViewMarginLeft = 30;
		_imageViewMarginRight = 30;
		_imageView = [UIImageView new];
		_textLabel = [UILabel new];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_itemHeight = 25;
		_imageViewMarginLeft = 30;
		_imageViewMarginRight = 30;
		[self initImageView];
		[self initTextLabel];
	}
	return self;
}

#pragma mark - Init View

- (void)initImageView{
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageViewMarginLeft, 0, _itemHeight, _itemHeight)];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:_imageView];
	
	[_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(self.imageViewMarginLeft);
		make.centerY.equalTo(self);
		make.width.equalTo(@(self.itemHeight));
	}];
}

- (void)initTextLabel{
	_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageViewMarginLeft + _imageViewMarginRight + _itemHeight, 0, 100, _itemHeight)];
	_textLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_textLabel.font = [UIFont systemFontOfSize:16];
	_textLabel.textAlignment = NSTextAlignmentRight;
	[self addSubview:_textLabel];
	
	[_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self.imageView.mas_right).offset(self.imageViewMarginRight);
		make.height.equalTo(@(self.itemHeight));
	}];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	self.backgroundColor = AppStyleSetting.sharedInstance.lightGrayViewBgColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	self.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[super touchesCancelled:touches withEvent:event];
	self.backgroundColor = AppStyleSetting.sharedInstance.viewBgColor;
}

#pragma mark - Action

- (void)setImage:(UIImage *)image{
	_imageView.image = image;
}

- (void)setTitle:(NSString *)title{
	_textLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color{
	_textLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font{
	_textLabel.font = font;
}

- (void)setImageViewMarginLeft:(CGFloat)left{
	_imageViewMarginLeft = left;
	[_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(self.imageViewMarginLeft);
	}];
}

- (void)setImageViewMarginRight:(CGFloat)right{
	_imageViewMarginRight = right;
	[_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.imageView.mas_right).offset(self.imageViewMarginRight);
	}];
}

- (void)setItemHeight:(CGFloat)height{
	_itemHeight = height;
	[_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.width.equalTo(@(self.itemHeight));
	}];
	[_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@(self.itemHeight));
	}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
