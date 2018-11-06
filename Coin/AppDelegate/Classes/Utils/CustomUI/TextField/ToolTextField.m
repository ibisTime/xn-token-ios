//
//  ToolTextField.m
//  Coin
//
//  Created by 郑勤宝 on 2018/11/6.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "ToolTextField.h"

@interface ToolTextField()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}

@end
@implementation ToolTextField

-(instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font placeholder:(NSString *)placeholder placeholderFont:(CGFloat)placeholderfont
{
    if (self = [super init]) {
        self.font = [UIFont systemFontOfSize:font];
        self.frame = frame;
        self.placeholder = placeholder;
        [self setValue:[UIFont systemFontOfSize:placeholderfont] forKeyPath:@"_placeholderLabel.font"];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    
    }
    return self;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            if([textField.text length]==0){
                if(single == '.'){
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            return YES;
        }else{
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
    
}

#pragma mark --处理复制粘贴事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(self.isSecurity){
        
        return NO;
        
    } else{
        return [super canPerformAction:action withSender:sender];
    }
}

@end
