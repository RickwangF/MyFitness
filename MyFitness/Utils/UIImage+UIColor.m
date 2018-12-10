//
//  UIImage+UIColor.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/11/24.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "UIImage+UIColor.h"

@implementation UIImage (UIColor)

+(UIImage *)imageWithUIColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
