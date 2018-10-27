//
//  BTCPoundage.m
//  Coin
//
//  Created by 郑勤宝 on 2018/10/26.
//  Copyright © 2018 chengdai. All rights reserved.
//

#import "BTCPoundage.h"
#import "BTCBlockchainInfo.h"
#import "BTCTransactionOutput.h"
#import "BTCData.h"
#import "BTCKey.h"
#import "BTCScript.h"
#import "BTCScriptMachine.h"
#import "BTCAddress.h"
#import "BTCChainCom.h"
#import "BTCTransaction.h"
#import "BTCTransactionInput.h"
#import "BTCNetwork.h"
#import "BTCKeychain.h"
#import "BTCHashID.h"
#import "CoinUtil.h"

@implementation BTCPoundage


+(CGFloat)enterTheumber:(NSString *)number setFee:(NSString *)fee setUtxis:(NSMutableArray <utxoModel *>*)utxis
{
    if ([TLUser isBlankString:number] == YES) {
        number = @"0";
    }
    CoinModel *coin = [CoinUtil getCoinModel:@"BTC"];
    float mount = [[CoinUtil convertToSysCoin:number coin:coin.symbol] floatValue];
    BTCAmount btcValue = mount;
    BTCAmount sumIntputValue = 0;//Intput总额
    int sumIntputCount = 0;//Intput总个数
    BOOL isChange = NO;//是否需要找零
    BTCAmount changeValue = 0;//找零金额
    float btcFree = 0;//手续费
    NSMutableArray *IntputUtsos = [NSMutableArray array];
    
    //    计算服务费
    for (int i = 0; i < utxis.count; i ++) {
        utxoModel* txout = utxis[i];
        sumIntputCount ++;
        NSString *txoutCount = [CoinUtil convertToRealCoin:txout.count coin:@"BTC"];
        sumIntputValue = sumIntputValue + [[CoinUtil convertToSysCoin:txoutCount coin:@"BTC"] longLongValue];
        [IntputUtsos addObject:txout];
        btcFree = (148 * sumIntputCount + 34 * 1 + 10) * [fee floatValue];
        //       Intput总额 大于手续费+转账金额
        if (sumIntputValue >= (btcValue + btcFree)) {
            //       Intput总额 大于   手续费、找零手续费 + 转账金额
            if (sumIntputValue > (btcValue + (148 * sumIntputCount + 34 * 2 + 10) * [fee floatValue]))
            {
                btcFree = (148 * sumIntputCount + 34 * 2 + 10) * [fee floatValue];
                isChange = YES;
                changeValue = sumIntputValue - btcValue - (148 * sumIntputCount + 34 * 2 + 10) * [fee floatValue];
            }
            break;
        }
    }
//    btcFree = btcFree/100000000;
    return btcFree;
}


@end
