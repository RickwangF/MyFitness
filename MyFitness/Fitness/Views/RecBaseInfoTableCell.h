//
//  RecBaseInfoTableCell.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/18.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TriangleRectView;

NS_ASSUME_NONNULL_BEGIN

@interface RecBaseInfoTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TriangleRectView *infoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *aboveLine;
@property (weak, nonatomic) IBOutlet UIView *belowLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorLeading;

- (void)hideAboveLine;

- (void)hideBelowLine;

- (void)changeIndicatorSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
