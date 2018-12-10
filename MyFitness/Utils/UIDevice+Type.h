//
//  UIDevice+Type.h
//  MyFitness
//
//  Created by Rick Wang on 2018/12/10.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Type)
    
-(NSString*)type;
    
-(BOOL)fullScreen;

@end

NS_ASSUME_NONNULL_END
