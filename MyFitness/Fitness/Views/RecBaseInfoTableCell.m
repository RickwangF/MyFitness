//
//  RecBaseInfoTableCell.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/18.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "RecBaseInfoTableCell.h"

@implementation RecBaseInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
	_indicatorView.image = [UIImage imageNamed:@"dot_15#87"];
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
	_indicatorLeading.constant = 16;
	_indicatorView.image = [UIImage imageNamed:@"dot_15#87"];
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
	_indicatorLeading.constant = 16 - ((size.width - 15) / 2);
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
