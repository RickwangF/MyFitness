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
		_imageView = [UIImageView new];
		_textLabel = [UILabel new];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self initImageViewWithFrame:frame];
		[self initTextLabelWithFrame:frame];
	}
	return self;
}

#pragma mark - Init View

- (void)initImageViewWithFrame:(CGRect)frame{
	_itemHeight = frame.size.height;
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemHeight, _itemHeight)];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:_imageView];
	
	[_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.equalTo(self);
		make.width.equalTo(@(self.itemHeight));
	}];
}

- (void)initTextLabelWithFrame:(CGRect)frame{
	_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - _itemHeight, _itemHeight)];
	_textLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_textLabel.font = [UIFont systemFontOfSize:16];
	_textLabel.textAlignment = NSTextAlignmentRight;
	[self addSubview:_textLabel];
	
	[_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.right.equalTo(self);
		make.left.equalTo(self.imageView.mas_right);
	}];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
