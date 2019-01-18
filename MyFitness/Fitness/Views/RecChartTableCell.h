//
//  RecChartTableCell.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/18.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundIndicatorView.h"
#import "TriangleRectView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecChartTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TriangleRectView *infoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UIView *chartWrapView;
@property (weak, nonatomic) IBOutlet RoundIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *belowLine;
@property (weak, nonatomic) IBOutlet UIView *aboveLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorLeading;

- (void)hideAboveLine;

- (void)hideBelowLine;

- (void)changeIndicatorSize:(CGSize)size;

- (void)setStartSpot;

@end

NS_ASSUME_NONNULL_END
