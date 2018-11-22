//
//  WalletLocalWebVC.h
//  Coin
//
//  Created by shaojianfei on 2018/6/15.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLBaseVC.h"
#import "CurrencyModel.h"
@interface WalletLocalWebVC : TLBaseVC
@property (nonatomic ,copy) NSString *urlString;
@property (nonatomic ,strong) CurrencyModel *currentModel;

@end
