//
//  WalletLocalVc.h
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CurrencyModel.h"
typedef NS_ENUM(NSInteger, LocalType) {
    
    LocalTypeRecharge = 0,       //充值
    LocalTypeWithdraw,           //提币
    LocalTypeAll,                //全部
    LocalTypeFrozen,             //冻结
    
};
@interface WalletLocalVc : TLBaseVC
@property (nonatomic, strong) CurrencyModel *currency;
@property (nonatomic, assign) LocalType billType;
@end
