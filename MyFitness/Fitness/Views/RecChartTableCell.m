//
//  RecChartTableCell.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/18.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "RecChartTableCell.h"

@implementation RecChartTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	[self initAvgProgressBar];
	[self initFastestProgressBar];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse{
	[super prepareForReuse];
	_aboveLine.hidden = NO;
	_belowLine.hidden = NO;
	_indicatorWidth.constant = 15;
	_indicatorHeight.constant = 15;
	_indicatorLeading.constant = 23.5;
	if (_indicatorView.subviews.count > 0) {
		[_indicatorView.subviews[0] removeFromSuperview];
	}
	_avgProgressBar.progress = 0;
	_mostProgressBar.progress = 0;
	_firstInnerLabel.text = @"平均配速";
	_secondInnerLabel.text = @"本次配速";
}

#pragma mark - Action

- (void)hideAboveLine{
	_aboveLine.hidden = YES;
}

- (void)hideBelowLine{
	_belowLine.hidden = YES;
}

- (void)changeIndicatorSize:(CGSize)size{
	_indicatorWidth.constant = size.width;
	_indicatorHeight.constant = size.height;
	_indicatorLeading.constant = 23.5 - ((size.width - 15)/2);
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)setStartSpot{
	UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 18, 18)];
	startLabel.text = @"起";
	startLabel.textColor = UIColor.blackColor;
	startLabel.font = [UIFont systemFontOfSize:16];
	startLabel.textAlignment = NSTextAlignmentCenter;
	[_indicatorView addSubview:startLabel];
}

- (void)initAvgProgressBar{
	_avgProgressBar.type = YLProgressBarTypeRounded;
	_avgProgressBar.hideStripes = YES;
	_avgProgressBar.hideGloss = YES;
	_avgProgressBar.uniformTintColor = YES;
	_avgProgressBar.progressTintColor = [UIColor colorWithRed:254.0/255 green:182.0/255 blue:60.0/255 alpha:1.0];
	_avgProgressBar.cornerRadius = 10.0;
	_avgProgressBar.trackTintColor = UIColor.whiteColor;
	_avgProgressBar.hideInnerWhiteShadow = YES;
}

- (void)initFastestProgressBar{
	_mostProgressBar.type = YLProgressBarTypeRounded;
	_mostProgressBar.hideStripes = YES;
	_mostProgressBar.hideGloss = YES;
	_mostProgressBar.uniformTintColor = YES;
	_mostProgressBar.progressTintColor = [UIColor colorWithRed:39.0/255 green:217.0/255 blue:148.0/255 alpha:1.0];
	_mostProgressBar.cornerRadius = 10.0;
	_mostProgressBar.trackTintColor = UIColor.whiteColor;
	_mostProgressBar.hideInnerWhiteShadow = YES;
}

- (void)setAvgProgress:(CGFloat)progress{
	_avgProgressBar.progress = progress;
}

- (void)setMostProgress:(CGFloat)progress{
	_mostProgressBar.progress = progress;
}

@end
