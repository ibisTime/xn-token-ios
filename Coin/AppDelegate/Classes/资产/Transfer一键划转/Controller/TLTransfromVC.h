//
//  TLTransfromVC.h
//  Coin
//
//  Created by shaojianfei on 2018/7/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CurrencyModel.h"
@interface TLTransfromVC : TLBaseVC
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*centercurrencys;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*localcurrencys;

//  NO 个人钱包。  yes 私钥钱包currentModel
@property (nonatomic, assign) BOOL isLocal;




@end
