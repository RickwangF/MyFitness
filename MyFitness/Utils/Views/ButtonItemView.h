//
//  ButtonItemView.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/12.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonItemView : UIControl

- (void)setImage:(UIImage*)image;

- (void)setTitle:(NSString*)title;

- (void)setTitleColor:(UIColor*)color;

- (void)setTitleFont:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
