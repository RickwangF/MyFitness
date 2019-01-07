//
//  SFVerificationCodeView..h
//  RandomCode-Demo
//
//  Created by Jakey on 15/1/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SFVerificationCodeMode) {
    SFVerificationCodeModeLocal, //本地code随机生成
    SFVerificationCodeModeServer //服务器端返回code
};
typedef void(^SFVerificationCodeDidChange)(NSString *code);
typedef void(^SFVerificationCodeWillChange)(SFVerificationCodeMode mode);


@interface SFVerificationCodeView : UIView
{
    SFVerificationCodeDidChange _didChangeVerificationCode;
    SFVerificationCodeWillChange _willChangeVerificationCode;
    UITapGestureRecognizer *_tap;
}
-(void)didChangeVerificationCode:(SFVerificationCodeDidChange)didChangeVerificationCode;
-(void)willChangeVerificationCode:(SFVerificationCodeWillChange)willChangeVerificationCode;

///随机code长度 默认5位
@property (nonatomic)  NSUInteger length;
//手动设置code
@property (nonatomic,copy)  NSString *code;
//code生成方式
@property (nonatomic,assign) SFVerificationCodeMode  mode;
//手动触发生成code
- (void)generateVerificationCode;
@end
