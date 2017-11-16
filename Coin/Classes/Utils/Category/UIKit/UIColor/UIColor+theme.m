//
//  UIColor+theme.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "UIColor+theme.h"
#import "UIColor+Extension.h"

@implementation UIColor (theme)

+ (UIColor *)themeColor {
    return [self colorWithHexString:@"#f15353"];
    
//    return [self colorWithHexString:@"#062745"];
}

+ (UIColor *)textColor {

    return [self colorWithHexString:@"#484848"];
}

+ (UIColor *)textColor2 {

    return [self colorWithHexString:@""];
}

+ (UIColor *)lineColor {
    
    return [self colorWithHexString:@"#eeeeee"];
    
}

+ (UIColor *)backgroundColor {

    return [self colorWithHexString:@"#fafafa"];
}

+ (UIColor *)customYellowColor {
    
//    colorWithHexString:@"#dab616"
//    return [UIColor colorWithHexString:@"#beb098"];
    return [UIColor colorWithHexString:@"#dab616"];
    
}





@end
