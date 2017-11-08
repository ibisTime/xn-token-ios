//
//  UILabel+Custom.m
//  BS
//
//  Created by 蔡卓越 on 16/4/7.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "UILabel+Custom.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Custom)

+ (UILabel *)labelWithTitle:(NSString *)title {

    return [self labelWithTitle:title frame:CGRectMake(0, 0, 100, 30)];
}

+ (UILabel *)labelWithTitle:(NSString *)title frame:(CGRect)frame {

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = kTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = Font(kWidth(18.0));
    
    return label;
}

//调整行间距
- (void)labelWithTextString:(NSString *)textString lineSpace:(CGFloat)lineSpace {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    
    self.attributedText = attributedStr;
}


+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor textFont:(CGFloat)textFont {
    UILabel *label = [[UILabel alloc] init];
 
    label.text = text;
    label.textColor = textColor;
    label.font = Font(textFont);
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

- (void)labelWithString:(NSString *)string title:(NSString *)title font:(UIFont *)font color:(UIColor *)color {

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange range = [string rangeOfString:title];
    //字体
    [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    //颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedText = attributedStr;
    
}

+ (UILabel *)labelWithFrame:(CGRect)frame
               textAligment:(NSTextAlignment)aligment
            backgroundColor:(UIColor *)color
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.textAlignment = aligment;
    lbl.backgroundColor = color;
    lbl.font = font;
    lbl.textColor = textColor;
    return lbl;
    
}

- (instancetype)initWithFrame:(CGRect)frame
                 textAligment:(NSTextAlignment)aligment
              backgroundColor:(UIColor *)color
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor{
    
    if(self = [super initWithFrame:frame]){
        self.textAlignment = aligment;
        self.backgroundColor = color;
        self.textColor = textColor;
        self.font = font;
    }
    return self;
}

- (NSInteger)getLinesArrayOfStringInLabel {
    
    //计算label高度
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.maximumLineHeight = 20;
    style.minimumLineHeight = 20;
    
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(kScreenWidth - 2*15, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:style} context:nil];
    
    CGFloat labelH = rect.size.height;
    
    NSInteger lineCount = labelH/20;
    
    return lineCount;
}

@end
