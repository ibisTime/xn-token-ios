//
//  TLTimeButton.m
//  实验22
//
//  Created by 田磊 on 16/3/17.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLTimeButton.h"
#import "AppColorMacro.h"

@implementation TLTimeButton
{

    NSInteger _time;
    NSInteger _totalTime;
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame totalTime:(NSInteger)total
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _time = total;
        _totalTime = total;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self setTitleColor:kAppCustomMainColor forState:UIControlStateNormal];

        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        self.titleLabel.font = Font(15.0);
        self.enabled = YES;

    }
    return self;
}

- (void)forbid
{

    self.enabled = NO;
}

- (void)available
{

    self.enabled = YES;

}



- (void)begin{

    self.enabled = NO;
    
    [self setTitle:[NSString stringWithFormat:@"重新发送(%ld)",_totalTime] forState:UIControlStateDisabled];
    
    self.backgroundColor = kTextColor2;
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)timeAction
{
    _time --;

    NSString *str = [NSString stringWithFormat:@"重新发送(%ld)",_time];
    
    [self setTitle:str forState:UIControlStateDisabled];

    if (_time == 0) {
        
        [_timer invalidate];
        _timer = nil;
        _time = _totalTime;
        self.backgroundColor = kAppCustomMainColor;
        self.enabled = YES;
    }
    
}
@end
