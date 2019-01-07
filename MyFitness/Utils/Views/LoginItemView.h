//
//  LoginItemView.h
//  MyFitness
//
//  Created by Rick Wang on 2019/1/7.
//  Copyright © 2019 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginItemView : UIView

@property (nonatomic, strong) UIButton *loginBtn;

- (void)setImage:(UIImage*)image;

- (void)setTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
