//
//  UILable+convience.m
//  WeRide
//
//  Created by  tianlei on 2016/12/5.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "UILable+convience.h"

@implementation UILabel (convience)

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

//+ (UILabel *)lableWithFrame:(CGRect)frame
//               textAligment:(NSTextAlignment)aligment
//            backgroundColor:(UIColor *)color
//                       font:(UIFont *)font
//                  textColor:(UIColor *)textColor
//{
//    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
//    lbl.textAlignment = aligment;
//    lbl.backgroundColor = color;
//    lbl.font = font;
//    lbl.textColor = textColor;
//    return lbl;
//
//}


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
@end
