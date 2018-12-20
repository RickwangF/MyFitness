//
//  RecordTableCell.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/19.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RecordItemView *walkingRecView;
@property (weak, nonatomic) IBOutlet RecordItemView *runRecView;
@property (weak, nonatomic) IBOutlet RecordItemView *rideRecView;

@end

NS_ASSUME_NONNULL_END
