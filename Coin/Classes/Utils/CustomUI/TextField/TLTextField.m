//
//  TLTextField.m
//  WeRide
//
//  Created by  蔡卓越 on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLTextField.h"
#import "AppColorMacro.h"
#import "UIColor+Extension.h"

@interface TLTextField()<UITextFieldDelegate>


@end
@implementation TLTextField

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder
{
    
    if (self = [super init]) {
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleWidth, frame.size.height)];
        
        UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleWidth - 18, frame.size.height)];
        leftLbl.text = leftTitle;
        leftLbl.textAlignment = NSTextAlignmentLeft;
        leftLbl.font = Font(13.0);
        leftLbl.textColor = [UIColor colorWithHexString:@"#484848"];
        [leftBgView addSubview:leftLbl];
        leftLbl.numberOfLines = 0;
        self.leftLbl = leftLbl;
        
        self.leftView = leftBgView;

        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.placeholder = placeholder;
        //    [tf addAction];
        self.font = [UIFont systemFontOfSize:13];

    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
//        self.textAlignment = NSTextAlignmentRight;
        self.font = [UIFont systemFontOfSize:13];
        self.delegate = self;
    }
    
    return self;

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (!self.maxCount) {
        NSLog(@"%@  %@",textField.text,string);

        return YES;
    }
        if (textField.text.length >= self.maxCount) {
            return NO;
        }else{
            NSLog(@"%@  %@",textField.text,string);
        return YES;
        }
        
        
    }


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSLog(@"%@ end",textField.text);

    
}
#pragma mark --处理复制粘贴事件
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if(self.isSecurity){
//
//        return NO;
//
//    } else{
//        return [super canPerformAction:action withSender:sender];
//    }
//    //    if (action == @selector(paste:))//禁止粘贴
//    //        return NO;
//    //    if (action == @selector(select:))// 禁止选择
//    //        return NO;
//    //    if (action == @selector(selectAll:))// 禁止全选
//    //        return NO;
//}


@end
