//
//  CircleProgressButton.m
//  EagleEyeTest
//
//  Created by Rick Wang on 2018/12/6.
//  Copyright © 2018 KMZJ. All rights reserved.
//

#import "CircleProgressButton.h"
#import <MBCircularProgressBar/MBCircularProgressBarView.h>
#import <Masonry/Masonry.h>

@implementation CircleProgressButton

BOOL triggerFlag = NO;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.layer.cornerRadius = frame.size.width / 2;
		self.backgroundColor = UIColor.blueColor;
        [self initProgressViewWithFrame:frame];
        [self initTextBtnWithFrame:frame];
        [self initTimer];
		
        [_textBtn addTarget:self action:@selector(progressBtnTouchedDown:) forControlEvents:UIControlEventTouchDown];
        [_textBtn addTarget:self action:@selector(progressBtnTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)initTextBtnWithFrame:(CGRect)frame{
    _textBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
    _textBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
	[_textBtn setImage:[UIImage imageNamed:@"stop_25#ff"] forState:UIControlStateNormal];
    _textBtn.layer.cornerRadius = (frame.size.width - 20) / 2;
    _textBtn.layer.masksToBounds = YES;
    [self addSubview:_textBtn];
    
    [_textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

-(void)initProgressViewWithFrame:(CGRect)frame{
	
    _progressView = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
    _progressView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    _progressView.progressAngle = 100;
    _progressView.progressRotationAngle = 50;
    _progressView.progressCapType = kCGLineCapRound;
    _progressView.emptyCapType = kCGLineCapRound;
    _progressView.progressColor = UIColor.greenColor;
    _progressView.progressStrokeColor = UIColor.cyanColor;
    _progressView.emptyLineColor = [UIColor colorWithWhite:1.0 alpha:0];
    _progressView.emptyLineStrokeColor = [UIColor colorWithWhite:1.0 alpha:0];
    _progressView.progressLineWidth = 1.0;
	_progressView.emptyLineWidth = 0.5;
    _progressView.value = 0;
    _progressView.maxValue = 100;
    _progressView.showValueString = NO;
    _progressView.showUnitString = NO;
    [self addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}

-(void)initTimer{
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerIsTicking) userInfo:nil repeats:YES];
}

-(void)addTimer{
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)resetTimer{
    _count = 0;
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerIsTicking) userInfo:nil repeats:YES];
}

-(void)timerIsTicking{
    _count++;
	_progressView.emptyLineColor = _progressView.progressColor;
    if (_count >= 20) {
        _count = 20;
        if (triggerFlag == NO) {
            triggerFlag = YES;
        }
    }
    
    [UIView animateWithDuration:0.1 animations:^{
       self.progressView.value = self.count * 5;
    }];
}

-(void)progressBtnTouchedDown:(UIControl*)sender{
    [self addTimer];
}

-(void)progressBtnTouchedUp:(UIControl*)sender{
    _progressView.value = 0;
	_progressView.emptyLineColor = [UIColor colorWithWhite:1.0 alpha:0];
	if (triggerFlag == YES) {
		triggerFlag = NO;
		if (_longPressedBlock != NULL) {
			self.longPressedBlock();
		}
	}
    [_timer invalidate];
	_timer = nil;
    [self resetTimer];
}

-(void)setProgressBtnBackgroundColor:(UIColor *)color{
    self.backgroundColor = color;
}

-(void)setProgressColor:(UIColor *)color{
    _progressView.progressColor = color;
    _progressView.progressStrokeColor = color;
}

- (void)dealloc
{
	[_timer invalidate];
	_timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
