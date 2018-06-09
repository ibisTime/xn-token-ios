//
//  ResiseTextFiled.m
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "ResiseTextFiled.h"
#import "AppColorMacro.h"
#import "AppMacro.h"
#import "AppConfig.h"
@interface ResiseTextFiled()<UITextFieldDelegate>

//金钱数量显示
@property (nonatomic, strong) UILabel *numLabel;
//密码输入
@property (nonatomic, strong) UITextField *passwordField;

//用于存放黑色的点点
@property (nonatomic, strong) NSMutableArray *dotArray;
@end
@implementation ResiseTextFiled

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    
    //金钱数量显示
    [self addSubview:self.numLabel];
    //密码输入
    [self addSubview:self.passwordField];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //金钱设置
    _numLabel.text = [NSString stringWithFormat:@"%@.00",@"100"];
    //金钱字体的设置
    NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:_numLabel.text];
    [name addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:15] range:NSMakeRange(_numLabel.text.length-2, 2)];
    _numLabel.attributedText = name;
    
    [self.passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //每个密码输入框的宽度
    CGFloat width;
    
    width = (self.frame.size.width-80) / 6;
    
    //生成分割线
    for (int i = 0; i < 6-1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passwordField.frame) + (i + 1) * width +(i*8), CGRectGetMinY(self.passwordField.frame), 8, 44)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < 6; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passwordField.frame) + (width-8) / 2 + i * width+(i*8), CGRectGetMinY(self.passwordField.frame) + (44 - 30) / 2, 20, 20)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = 14 / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
    
    
}
#pragma mark--UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 6) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.passwordField.text = @"";
    [self passwordFieldDidChange:self.passwordField];
}

/**
 *  重置显示的点
 */
- (void)passwordFieldDidChange:(UITextField *)textField
{
    
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == 6) {
        
    }
}

//金钱数量显示
-(UILabel *)numLabel
{
    if(!_numLabel){
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 109, self.frame.size.width, 32)];
        _numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:32];
        _numLabel.textColor = kTextColor;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _numLabel;
}

//密码输入
-(UITextField *)passwordField
{
    if(!_passwordField){
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.numLabel.frame)+32, self.frame.size.width-20, 44)];
        //输入框背景和字体都为灰色
        _passwordField.backgroundColor = kHexColor(@"#");
        _passwordField.textColor = kTextColor2;
        _passwordField.delegate = self;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        //输入框光标的颜色为灰色
        _passwordField.tintColor = kBlackColor;
        
        
        
    }
    return _passwordField;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

@end
