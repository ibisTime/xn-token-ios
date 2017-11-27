//
//  TLPlaceholderView.h
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/21.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLPlaceholderView : UIView

+ (instancetype)placeholderViewWithText:(NSString *)text;

+ (instancetype)placeholderViewWithText:(NSString *)text topMargin:(CGFloat)margin ;

@end
