//
//  TLAlert.m
//  WeRide
//
//  Created by  蔡卓越 on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLAlert.h"
#import "MBProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation TLAlert

//info
+ (void)alertWithInfo:(NSString *)msg {
    
    [SVProgressHUD showInfoWithStatus:msg];
    [SVProgressHUD dismissWithDelay:2];
}

//error
+ (void)alertWithError:(NSString *)msg {
    
    [SVProgressHUD showErrorWithStatus:msg];
    [SVProgressHUD dismissWithDelay:2];
    
}

//success
+ (void)alertWithSucces:(NSString *)msg {
    
    [SVProgressHUD showSuccessWithStatus:msg];
    [SVProgressHUD dismissWithDelay:2];
    
}

//+ (void)alertHUDWithMsg:(NSString *)msg {
//
////    [TLProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [TLProgressHUD showInfoWithStatus:msg];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [TLProgressHUD dismissWithCompletion:^{
//
//        }];
//
//    });
//
//
//}
//
////+ (void)alertHUDWithMsg:(NSString *)msg maskType:(SVProgressHUDMaskType)maskType
//
//+ (void)alertWithHUDText:(NSString *)text {
//
//    [TLProgressHUD showInfoWithStatus:text];
//    [TLProgressHUD dismissWithDelay:2.0 completion:nil];
//
////   return [self alertWithHUDText:text duration:2.0 complection:nil];
//
//}
//
//+ (void)alertWithHUDText:(NSString *)text duration:(NSTimeInterval)sec complection:(void(^)())complection {
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
//    //    hud.bezelView.backgroundColor = [UIColor blackColor];
//    //    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    hud.animationType = MBProgressHUDAnimationZoomOut;
//    //    hud.bezelView.style =  MBProgressHUDBackgroundStyleSolidColor;
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = text;
//    //    hud.label.textColor = [UIColor whiteColor];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [hud hideAnimated:YES];
//        if (complection) {
//            complection();
//        }
//    });
//
////    return nil;
//
//
//}


#pragma mark- 基于系统的alertController
+ (void)alertWithMsg:(NSString * )message viewCtrl:(UIViewController *)vc {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action2];
    [vc presentViewController:alertController animated:YES completion:nil];
    
    
}

+ (void)alertWithMsg:(NSString * )message
{
    [self alertWithTitle:nil message:message confirmAction:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    [self alertWithTitle:title message:message confirmAction:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmAction:(void(^)())confirmAction;
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (confirmAction) {
            confirmAction();
        }
    }];
    
    
    [alertController addAction:action2];
    //rootViewController 展示
    
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController ;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        [tbc.selectedViewController  presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmMsg:(NSString *)confirmMsg confirmAction:(void(^)())confirmAction
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:confirmMsg style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (confirmAction) {
            confirmAction();
        }
    }];
    
    
    [alertController addAction:action2];
    //rootViewController 展示
    
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController ;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        [tbc.selectedViewController  presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                           confirmMsg:(NSString *)confirmMsg
                            cancleMsg:(NSString *)cancleMsg
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm {
    
    return  [self alertWithTitle:title msg:msg confirmMsg:confirmMsg cancleMsg:cancleMsg maker:nil cancle:cancle confirm:confirm];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                           confirmMsg:(NSString *)confirmMsg
                            cancleMsg:(NSString *)cancleMsg
                                maker:(UIViewController *)viewCtrl
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm{
    
    //
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancleMsg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(cancle){
            cancle(action);
        }
        
    }];
    
    
    //确认行为
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:confirmMsg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            confirm(action);
        }
    }];
    
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    //rootViewController 展示
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (viewCtrl) {
        [viewCtrl presentViewController:alertController animated:YES completion:nil];
        
        
    } else if([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        [tbc presentViewController:alertController animated:YES completion:nil];
        //        tbc.presentingViewController
        
    } else {
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    return alertController;
    
}

//带有 删除 和 确认的提示
+ (UIAlertController *)alertWithTitle:(NSString *)title
                              Message:(NSString *)message
                           confirmMsg:(NSString *)confirmMsg
                            CancleMsg:(NSString *)cancleMsg
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm
{
    
    return [self alertWithTitle:title msg:message confirmMsg:confirmMsg cancleMsg:cancleMsg cancle:cancle confirm:confirm];
    
    
}

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                           confirmMsg:(NSString *)confirmMsg
                            cancleMsg:(NSString *)cancleMsg
                          placeHolder:(NSString *)placeHolder
                                maker:(UIViewController *)viewCtrl
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action, UITextField *textField))confirm{
    
    //
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //取消行为
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancleMsg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(cancle){
            
            cancle(action);
        }
        
    }];
    
    //确认行为
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:confirmMsg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            
            confirm(action, alertController.textFields.firstObject);
        }
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = placeHolder;
        
        textField.secureTextEntry = YES;
        
    }];
    
    //rootViewController 展示
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (viewCtrl) {
        [viewCtrl presentViewController:alertController animated:YES completion:nil];
        
        
    } else if([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tbc = (UITabBarController *)rootViewController;
        [tbc presentViewController:alertController animated:YES completion:nil];
        //        tbc.presentingViewController
        
    } else {
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    return alertController;
    
}
@end
