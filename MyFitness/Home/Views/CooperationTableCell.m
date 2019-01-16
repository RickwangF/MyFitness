//
//  CooperationTableCell.m
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import "CooperationTableCell.h"

@implementation CooperationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
	_containerView.layer.cornerRadius = 10;
	_containerView.clipsToBounds = YES;
	_topImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
