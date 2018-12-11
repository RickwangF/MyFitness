//
//  FitnessItemView.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/11.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "FitnessItemView.h"
#import <Masonry/Masonry.h>
#import "AppStyleSetting.h"

@interface FitnessItemView ()
	
@property (nonatomic, strong) UIView *topItemView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *topItemLabel;

@property (nonatomic, strong) UILabel *itemNameLabel;

@property (nonatomic, strong) UIView *leftSeparator;

@property (nonatomic, strong) UIView *rightSeparator;
	
@property (nonatomic, assign) CGFloat itemViewHeight;
	
@property (nonatomic, assign) CGFloat itemWidth;
	
@property (nonatomic, assign) CGFloat imgOriginX;
	
@property (nonatomic, assign) CGFloat nameLabelHeight;

@end


@implementation FitnessItemView

#pragma mark - Init
	
- (instancetype)init{
	self = [super init];
	if (self) {
		_topItemView = [UIView new];
		_imageView = [UIImageView new];
		_topItemLabel = [UILabel new];
		_itemNameLabel = [UILabel new];
	}
	return self;
}
	
- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self){
		[self initTopItemViewWithRect:frame];
		[self initImageView];
		[self initTopItemLabel];
		[self layoutTopItemViewContent];
		[self initItemNameLabel:frame];
//		self.layer.borderWidth = 1.0;
//		self.layer.borderColor = UIColor.blueColor.CGColor;
	}
	return self;
}

#pragma mark - Init View
	
- (void)initTopItemViewWithRect:(CGRect)frame{
	_itemViewHeight = frame.size.height * 0.4;
	_topItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _itemViewHeight)];
	[self addSubview:_topItemView];
	[_topItemView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self);
		make.height.equalTo(@(self.itemViewHeight));
	}];
}
	
- (void)initImageView{
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemViewHeight, _itemViewHeight)];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[_topItemView addSubview:_imageView];
}

- (void)initTopItemLabel{
	_topItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(_itemViewHeight, 0, 80, _itemViewHeight)];
	_topItemLabel.textColor = AppStyleSetting.sharedInstance.textColor;
	_topItemLabel.textAlignment = NSTextAlignmentCenter;
	_topItemLabel.font = [UIFont systemFontOfSize:20];
	_topItemLabel.text = @"加载中";
	[_topItemLabel sizeToFit];
	[_topItemView addSubview:_topItemLabel];
}
	
- (void)layoutTopItemViewContent{
	CGSize oldFrame = _topItemLabel.frame.size;
	CGFloat itemWidth = oldFrame.width + _imageView.frame.size.width + 5;
	_imgOriginX = (self.frame.size.width - itemWidth) / 2;
	_imageView.frame = CGRectMake(_imgOriginX, 0, _itemViewHeight, _itemViewHeight);
	_topItemLabel.frame = CGRectMake(_imgOriginX + _itemViewHeight + 5, 0, oldFrame.width, _itemViewHeight);
}
	
- (void)initItemNameLabel:(CGRect)frame{
	_nameLabelHeight = 0.3 * frame.size.height;
	_itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, _nameLabelHeight)];
	_itemNameLabel.textColor = AppStyleSetting.sharedInstance.smallTextColor;
	_itemNameLabel.textAlignment = NSTextAlignmentCenter;
	_itemNameLabel.font = [UIFont systemFontOfSize:16];
	_itemNameLabel.text = @"加载中";
	
	[self addSubview:_itemNameLabel];
	
	[_itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.right.equalTo(self);
		make.height.equalTo(@(self.nameLabelHeight));
	}];
}
	
- (void)initSeparator{
	
}
	
#pragma mark - Action
	
- (void)setImage:(UIImage *)image{
	_imageView.image = image;
}
	
- (void)setItemName:(NSString *)name{
	_itemNameLabel.text = name;
}
	
- (void)setTitle:(NSString *)text{
	_topItemLabel.text = text;
	[_topItemLabel sizeToFit];
	[self layoutTopItemViewContent];
}
	
- (void)setSeparator{
	CGSize size = self.frame.size;
	_leftSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0.2 * size.height, 0.5, 0.6 * size.height)];
	_leftSeparator.backgroundColor = AppStyleSetting.sharedInstance.separatorColor;
	[self addSubview:_leftSeparator];
	
	_rightSeparator = [[UIView alloc] initWithFrame:CGRectMake(size.width, 0.2 * size.height, 0.5, 0.6 * size.height)];
	_rightSeparator.backgroundColor = AppStyleSetting.sharedInstance.separatorColor;
	[self addSubview:_rightSeparator];
}
	
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
