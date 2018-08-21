//
//  UILabel+Extension.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "UILabel+Extension.h"
#import "AppColorMacro.h"
#import <CDCommon/UIView+Frame.h>

@implementation UILabel (Extension)

//调整行间距
- (void)labelWithTextString:(NSString *)textString lineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    
    self.attributedText = attributedStr;
}

// 同一个string里不同的颜色和字体
- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange range = [string rangeOfString:title];
    //字体
    [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    //颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedText = attributedStr;
    
}

- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    NSRange range = [string rangeOfString:title];
    //字体
    [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    //颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedText = attributedStr;
}

- (NSInteger)getLinesArrayOfStringInLabel {
    
    //计算label高度
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.maximumLineHeight = 20;
    style.minimumLineHeight = 20;
    
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:style} context:nil];
    
    CGFloat labelH = rect.size.height;
    
    NSInteger lineCount = labelH/20;
    
    return lineCount;
}

@end
