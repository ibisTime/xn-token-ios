//
//  UIColor+theme.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/12.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "UIColor+theme.h"
#import "UIColor+Extension.h"
#import "AppColorMacro.h"

@implementation UIColor (theme)

+ (UIColor *)themeColor {
    
    return kThemeColor;
    
}

+ (UIColor *)textColor {

    return kTextColor;
    
}

+ (UIColor *)textColor2 {

    return kTextColor2;
}

+ (UIColor *)lineColor {
    
    return kLineColor;
    
}

+ (UIColor *)backgroundColor {

    return kBackgroundColor;
}


@end
