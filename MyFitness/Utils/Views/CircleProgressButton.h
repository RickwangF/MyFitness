//
//  CircleProgressButton.h
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/12/6.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleProgressButton : UIView

@property (nonatomic, strong) MBCircularProgressBarView *progressView;

@property (nonatomic, strong) UIButton *textBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) void(^longPressedBlock)(void);

-(void)setProgressBtnBackgroundColor:(UIColor*)color;

-(void)setProgressColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
