//
//  BillVC.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseVC.h"

typedef NS_ENUM(NSInteger, BillType) {
    
    BillTypeRecharge = 0,       //充值
    BillTypeWithdraw,           //提币
    BillTypeAutofill,           //自动补给
    BillTypeAll,                //全部
    BillTypeFrozen,             //冻结
    
};

@interface BillVC : TLBaseVC

@property (nonatomic,copy) NSString *accountNumber;

@property (nonatomic, assign) BillType billType;

@end
