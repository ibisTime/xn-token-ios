//
//  EditVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "TLBaseVC.h"

typedef  NS_ENUM(NSInteger,UserEditType) {
    
    UserEditTypeNickName = 0,
    UserEditTypeEmail
    
};

@interface EditVC : TLBaseVC

@property (nonatomic, copy) void (^done)(NSString *content);

@property (nonatomic, assign) UserEditType type;

@property (nonatomic, copy) NSString *text;

@end
