//
//  RevisePassWordVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
typedef NS_ENUM(NSInteger, PassWprdType) {
    
    PassWprdTypeFirst = 0,   //第一次
    PassWprdTypeSecond = 1  //第二次
};

typedef void(^WalletBackBlock)(void);

@interface RevisePassWordVC : TLBaseVC
@property (nonatomic , copy) WalletBackBlock walletBlock;

@property (nonatomic, assign) PassWprdType Type;

@property (nonatomic, assign) BOOL IsImport;

@end
