//
//  WallAccountVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CurrencyModel.h"
typedef NS_ENUM(NSInteger, CurrentType) {
    
    CurrentTypeRecharge = 0,       //充值
    CurrentTypeWithdraw,           //提币
   CurrentTypeAll,                //全部
   CurrentTypeFrozen,             //冻结
    
};

@interface WallAccountVC : TLBaseVC
@property (nonatomic, strong) CurrencyModel *currency;
@property (nonatomic, assign) CurrentType billType;

@end
