//
//  FitnessItemView.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/11.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FitnessItemView : UIView
	
- (void)setImage:(UIImage*)image;
	
- (void)setItemName:(NSString*)name;
	
- (void)setTitle:(NSString*)text;
	
- (void)setSeparator;

@end

NS_ASSUME_NONNULL_END
