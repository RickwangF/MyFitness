//
//  RecordTableCell.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "RecordTableCell.h"

@implementation RecordTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	[_walkingRecView setImage:[UIImage imageNamed:@"walk_40#51"]];
	[_runRecView setImage:[UIImage imageNamed:@"run_40#51"]];
	[_rideRecView setImage:[UIImage imageNamed:@"ride_40#51"]];
	
	[_walkingRecView setTitle:@"健走里程"];
	[_runRecView setTitle:@"跑步里程"];
	[_rideRecView setTitle:@"骑行里程"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
