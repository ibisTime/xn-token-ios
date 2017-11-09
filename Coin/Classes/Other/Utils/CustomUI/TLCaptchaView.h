//
//  TLCaptchaView.h
//  WeRide
//
//  Created by  蔡卓越 on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTimeButton.h"
#import "TLTextField.h"

@interface TLCaptchaView : UIView

@property (nonatomic,strong) TLTextField *captchaTf;
@property (nonatomic,strong) TLTimeButton *captchaBtn;

@end
