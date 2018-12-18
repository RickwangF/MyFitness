//
//  RightImageButton.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/18.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "RightImageButton.h"
#import <Masonry/Masonry.h>

@interface RightImageButton ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat leftOffset;

@property (nonatomic, assign) CGFloat imageWidth;

@end

@implementation RightImageButton

static CGFloat width = 0;

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_leftOffset = 5;
		_imageWidth = 8;
		[self initTitleLabelWithFrame:frame];
		[self initImageViewWithFrame:frame];
	}
	return self;
}

- (void)initTitleLabelWithFrame:(CGRect)frame{
	width = frame.size.width - ((2*_leftOffset) + 3 + _imageWidth);
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftOffset, 0, width, frame.size.height)];
	_titleLabel.text = @"未设置";
	_titleLabel.textColor = UIColor.blackColor;
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
	[self addSubview:_titleLabel];
}

- (void)initImageViewWithFrame:(CGRect)frame{
	CGFloat originX = _leftOffset + width + 3;
	CGFloat originY = (frame.size.height - 8)/2;
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, _imageWidth, _imageWidth)];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:_imageView];
}

#pragma mark - Layout

- (void)layoutContent{
	CGRect titleFrame = _titleLabel.frame;
	CGFloat oriTitleX = (self.frame.size.width - titleFrame.size.width - (2*_leftOffset)) / 2;
	CGFloat oriTitleY = (self.frame.size.height - titleFrame.size.height) / 2;
	CGFloat oriImageX = oriTitleX + titleFrame.size.width + 3;
	CGFloat oriImageY = (self.frame.size.height - 8)/2;
	_titleLabel.frame = CGRectMake(oriTitleX, oriTitleY, titleFrame.size.width, titleFrame.size.height);
	_imageView.frame = CGRectMake(oriImageX, oriImageY, 8, 8);
}

#pragma mark - Action

- (void)setImage:(UIImage *)image{
	_imageView.image = image;
}

- (void)setTitle:(NSString *)string{
	_titleLabel.text = string;
	[_titleLabel sizeToFit];
	[self layoutContent];
}

- (void)setTitleFont:(UIFont *)font{
	_titleLabel.font = font;
}

- (void)setTitleColor:(UIColor *)color{
	_titleLabel.textColor = color;
}

- (void)rotateImageView{
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
	} completion:^(BOOL finished) {
		
	}];
}

- (void)cancelRotateImageView{
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.imageView.transform = CGAffineTransformMakeRotation(0);
	} completion:^(BOOL finished) {
		
	}];
}

@end
