//
//  MonthSectionHeader.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/14.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthSectionHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

NS_ASSUME_NONNULL_END
