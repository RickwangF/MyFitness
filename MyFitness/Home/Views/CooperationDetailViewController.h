//
//  CooperationDetailViewController.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/16.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cooperation, HeroIDModel;

NS_ASSUME_NONNULL_BEGIN

@interface CooperationDetailViewController : UIViewController

- (instancetype)initWithCooperation:(Cooperation*)cooperation HeroId:(HeroIDModel*)idModel;

@end

NS_ASSUME_NONNULL_END
