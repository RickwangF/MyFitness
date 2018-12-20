//
//  FounctionTableCell.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "FounctionTableCell.h"

@implementation FounctionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse{
	[super prepareForReuse];
	_leadingConstraint.constant = 20;
	_trailingConstraint.constant = 20;
	[_separator setHidden:NO];
}

- (void)setSeparatorEndSection{
	_leadingConstraint.constant = 0;
	_trailingConstraint.constant = 0;
}

- (void)hideSeparator{
	[_separator setHidden:YES];
}

@end
