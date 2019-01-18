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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
