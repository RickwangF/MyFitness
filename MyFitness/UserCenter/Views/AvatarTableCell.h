//
//  AvatarTableCell.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginNameLabel;

@end

NS_ASSUME_NONNULL_END
