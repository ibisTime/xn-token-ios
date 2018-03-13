//
//  TLProgressHUD.h
//  CityBBS
//
//  Created by  蔡卓越 on 2017/3/27.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
#import <SVProgressHUD/SVProgressHUD.h>
@interface TLProgressHUD : SVProgressHUD

//加载进度-eg: 网路请求，进度提示
+ (void)showWithStatus:(NSString *)msg;

//用于除进度外其它提示
+ (void)showInfoWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status;

//show with mask
//+ (void)showWithMask:(NSString *)msg;
//+ (void)showInfoWithMask:(NSString *)msg;
//+ (void)showSuccessWithMask:(NSString *)msg;
//+ (void)showErrorWithMask:(NSString *)msg;

//dismiss
+ (void)dismiss;

//autoDismss
+ (void)showErrorWithStatusAutoDismiss:(NSString *)msg;
+ (void)showWithStatusAutoDismiss:(NSString *)msg;
+ (void)showWithStatusAutoDismiss:(NSString *)msg delay:(NSInteger)delayTime;
+ (void)showWithStatusAutoDismiss:(NSString *)msg delay:(NSInteger)delayTime completion:(void(^)())completion;

@end
