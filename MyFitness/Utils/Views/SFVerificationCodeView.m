//
//  SFVerificationCodeView..m
//  RandomCode-Demo
//
//  Created by Jakey on 15/1/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "SFVerificationCodeView.h"

@implementation SFVerificationCodeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self buidView];
}

-(void)buidView{
    self.userInteractionEnabled = YES;
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(generateCode:)];
    [self addGestureRecognizer:_tap];
    _length = 5;
    self.backgroundColor = [UIColor whiteColor];
}

- (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}
-(NSString*)randomCode{
    //数字: 48-57
    //小写字母: 97-122
    //大写字母: 65-90
    char chars[] = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ";
    char codes[self.length];
    
    for(int i=0;i<self.length; i++){
        codes[i]= chars[arc4random()%62];
    }
    
    NSString *text = [[NSString alloc] initWithBytes:codes
                                              length:self.length encoding:NSUTF8StringEncoding];
    return text;
}
- (void)generateVerificationCode{
    if (self.mode == SFVerificationCodeModeLocal) {
        self.code = [self randomCode];
    }
    if (_willChangeVerificationCode) {
        _willChangeVerificationCode(_mode);
    }
}
- (void)generateCode:(UITapGestureRecognizer *)tap{
    if (!self.userInteractionEnabled) {
        return;
    }
    [self generateVerificationCode];
}
-(void)setCode:(NSString *)code{
    _code = [code copy];
    [self setNeedsDisplay];
}
-(void)setMode:(SFVerificationCodeMode)mode{
    _mode = mode;
    [self setNeedsDisplay];
}
-(void)setLength:(NSUInteger)length{
    _length = length;
    if (self.mode == SFVerificationCodeModeLocal) {
        [self generateVerificationCode];
    }
}
-(void)didChangeVerificationCode:(SFVerificationCodeDidChange)didChangeVerificationCode{    _didChangeVerificationCode = [didChangeVerificationCode copy];
    [self setNeedsDisplay];
}
-(void)willChangeVerificationCode:(SFVerificationCodeWillChange)willChangeVerificationCode{
    _willChangeVerificationCode = [willChangeVerificationCode copy];
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
   [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([_code description].length == 0) {
        return;
    }
    if (_didChangeVerificationCode) {
        _didChangeVerificationCode(_code);
    }
    
    CGSize charSize =  [@"A" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0]}];
    
    CGPoint point;
    float pointX, pointY;

    
    int width = self.frame.size.width / _code.length - charSize.width;
    int height = self.frame.size.height - charSize.height;

    for (int i = 0; i < _code.length; i++) {
        pointX = arc4random() % width + self.frame.size.width / _code.length * i;
        pointY = arc4random() % height;
        
        point = CGPointMake(pointX, pointY);
        unichar c = [_code characterAtIndex:i];
        NSString *textChar = [NSString stringWithFormat:@"%C", c];
        CGContextSetLineWidth(context, 1.0);
        //[[UIColor blueColor] set];
        float fontSize = (arc4random() % 10) + 17;

        [textChar drawAtPoint:point withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],NSStrokeColorAttributeName:[UIColor redColor],NSForegroundColorAttributeName:[self randomColor]}];
    }
    
    //干扰线
    CGContextSetLineWidth(context, 1.0);
    for(int i = 0; i < self.code.length; i++) {
        CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pointX, pointY);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextAddLineToPoint(context, pointX, pointY);
        CGContextStrokePath(context);
    }
    //干扰点

    for(int i = 0;i < self.code.length*6;i++) {
        CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pointX, pointY);
        CGContextAddLineToPoint(context, pointX+1, pointY+1);
        
        //CGContextFillRect(context, CGRectMake(pointX,pointY,1,1));
        CGContextStrokePath(context);
        
    }
    
}
@end
