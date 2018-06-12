//
//  AddAccoutMoneyVc.h
//  Coin
//
//  Created by shaojianfei on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CurrencyModel.h"
typedef void(^currenSelect)(NSMutableArray * model) ;

@interface AddAccoutMoneyVc : TLBaseVC
@property (nonatomic ,copy) currenSelect select;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@end
