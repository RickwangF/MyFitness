//
//  AvatarTableCell.m
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "AvatarTableCell.h"

@implementation AvatarTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
	_avatarImageView.layer.cornerRadius = 35;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
