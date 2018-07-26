//
//  ZLGestureLockViewController.h
//  GestureLockDemo
//
//  Created by ZL on 2017/4/5.
//  Copyright © 2017年 ZL. All rights reserved.
//  手势密码界面 控制器

#import <UIKit/UIKit.h>
#import "TLBaseVC.h"
typedef NS_ENUM(NSInteger,ZLUnlockType) {
    ZLUnlockTypeCreatePsw, // 创建手势密码
    ZLUnlockTypeValidatePsw // 校验手势密码
};

@interface ZLGestureLockViewController : TLBaseVC
@property (nonatomic ,assign) BOOL isCheck;
+ (void)deleteGesturesPassword;//删除手势密码
+ (NSString *)gesturesPassword;//获取手势密码

- (instancetype)initWithUnlockType:(ZLUnlockType)unlockType;

@end
