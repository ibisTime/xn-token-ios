//
//  ZMAuthResultVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLBaseVC.h"

@interface ZMAuthResultVC : TLBaseVC

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *idCard;

@property (nonatomic, assign) BOOL result;

@property (nonatomic, copy) NSString *failureReason;   //失败原因

@end
