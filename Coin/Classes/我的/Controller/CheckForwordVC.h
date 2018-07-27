//
//  CheckForwordVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/12.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
typedef NS_ENUM(NSInteger, PassWprdType) {
    
    PassWprdTypeFirst = 0,   //第一次
    PassWprdTypeSecond = 1  //第二次
};

typedef NS_ENUM(NSInteger, WalletWordType) {
    
    WalletWordTypeFirst = 0,   //修改密码验证
    WalletWordTypeSecond = 1,  //备份钱包验证
    WalletWordTypeThree = 2  //备份钱包验证

};

@interface CheckForwordVC : TLBaseVC
@property (nonatomic, assign) PassWprdType Type;

@property (nonatomic, assign) WalletWordType WalletType;

@property (nonatomic, assign) BOOL IsImport;
@property (nonatomic, assign) BOOL IsCopy;

@end
