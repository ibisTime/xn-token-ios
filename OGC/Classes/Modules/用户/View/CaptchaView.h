//
//  CaptchaView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLTimeButton.h"
#import "TLTextField.h"

@interface CaptchaView : UIView

- (instancetype)initWithFrame:(CGRect)frame leftTitleWidth:(CGFloat)width;

@property (nonatomic,strong) TLTextField *captchaTf;

@property (nonatomic,strong) TLTimeButton *captchaBtn;

@end
