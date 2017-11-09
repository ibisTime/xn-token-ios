//
//  TLAlert.h
//  WeRide
//
//  Created by  蔡卓越 on 2016/11/25.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class SVProgressHUD;

@interface TLAlert : NSObject

@property (nonatomic, assign) CGFloat infoSecond;     //警告停留的时间

@property (nonatomic, assign) CGFloat errorSecond;    //失败停留的时间

@property (nonatomic, assign) CGFloat successSecond;  //成功停留的时间

//SVProgressHUD新版
//+ (void)alertHUDWithMsg:(NSString *)msg;

//info
+ (void)alertWithInfo:(NSString *)msg;
//error
+ (void)alertWithError:(NSString *)msg;
//success
+ (void)alertWithSucces:(NSString *)msg;


//设置延迟时间
//+ (void)alertWithHUDText:(NSString *)text duration:(NSTimeInterval)sec complection:(void(^)())complection;

//--//基于系统的alertController
+ (void)alertWithMsg:(NSString * )message;
+ (void)alertWithMsg:(NSString * )message viewCtrl:(UIViewController *)vc;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message;


+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
         confirmAction:(void(^)())confirmAction;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmMsg:(NSString *)confirmMsg confirmAction:(void(^)())confirmAction;

//+ (void)alertWithTitle:(NSString *)title
//                message:(NSString *)message
//             controller:(UIViewController *)controller
//             completion:(void (^)(void))completion;

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                           confirmMsg:(NSString *)confirmMsg
                            cancleMsg:(NSString *)cancleMsg
                                maker:(UIViewController *)viewCtrl
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm;


+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                           confirmMsg:(NSString *)confirmMsg
                            cancleMsg:(NSString *)msg
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action))confirm;

////带有 删除 和 确认 的提示
//+ (UIAlertController *)alertWithTitle:(NSString *)title
//                              Message:(NSString *)message
//                           confirmMsg:(NSString *)confirmMsg
//                            CancleMsg:(NSString *)msg
//                               cancle:(void(^)(UIAlertAction *action))cancle
//                              confirm:(void(^)(UIAlertAction *action))confirm;

//带输入框
+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                           confirmMsg:(NSString *)confirmMsg
                            cancleMsg:(NSString *)msg
                          placeHolder:(NSString *)placeHolder
                                maker:(UIViewController *)viewCtrl
                               cancle:(void(^)(UIAlertAction *action))cancle
                              confirm:(void(^)(UIAlertAction *action, UITextField *textField))confirm;
@end
