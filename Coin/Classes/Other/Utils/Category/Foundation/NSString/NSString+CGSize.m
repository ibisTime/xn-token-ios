//
//  NSString+CGSize.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSString+CGSize.h"
#import <CDCommon/UIView+Frame.h>

@implementation NSString (CGSize)

- (CGSize)calculateStringSize:(CGSize)size font:(UIFont *)font
{
    CGSize stringSize;
    NSDictionary *dict = @{
                           NSFontAttributeName:font
                           };
    stringSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return stringSize;
}

+ (CGFloat)getWidthWithString:(NSString *)string font:(CGFloat)font {
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]}];
    //获取宽高
    CGSize statuseStrSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return statuseStrSize.width;
}

@end
