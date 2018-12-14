//
//  TrackTableCell.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/14.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrackTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *trackImageView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

NS_ASSUME_NONNULL_END
