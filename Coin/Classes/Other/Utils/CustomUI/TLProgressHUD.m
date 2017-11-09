//
//  TLProgressHUD.m
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/27.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLProgressHUD.h"

@implementation TLProgressHUD

+ (void)showWithStatus:(NSString *)msg {
    
    [super setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [super showWithStatus:msg];
    
}

+ (void)showInfoWithStatus:(NSString *)status {

    [super showInfoWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)status {

    [super showSuccessWithStatus:status];

}


+ (void)showErrorWithStatus:(NSString *)status {

    [super showErrorWithStatus:status];

}


+ (void)dismiss {
    
    [super dismiss];
}


+ (void)showErrorWithStatusAutoDismiss:(NSString *)msg {

    [super showErrorWithStatus:msg];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super dismiss];
    });

}


+ (void)showWithStatusAutoDismiss:(NSString *)msg {

    [self showWithStatusAutoDismiss:msg delay:3 completion:nil];

}

+ (void)showWithStatusAutoDismiss:(NSString *)msg delay:(NSInteger)delayTime  {
    
    [self showWithStatusAutoDismiss:msg delay:delayTime completion:nil];
    
}

+ (void)showWithStatusAutoDismiss:(NSString *)msg delay:(NSInteger)delayTime  completion:(void(^)())completion {

    [self showWithStatus:msg];
    [self setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [self dismissWithDelay:delayTime completion:completion];
    
}


@end
