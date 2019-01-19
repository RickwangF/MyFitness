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
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;

@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorLeading;

@property (weak, nonatomic) IBOutlet UIView *aboveLine;
@property (weak, nonatomic) IBOutlet UIView *belowLine;

- (void)hideAboveLine;

- (void)hideBelowLine;

- (void)changeIndicatorSize:(CGSize)size;

- (void)setStartSpot;

@end

NS_ASSUME_NONNULL_END
