//
//  UsdtClient.m
//  Coin
//
//  Created by haiqingzheng on 2018/10/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "UsdtClient.h"



@implementation UsdtClient

//USDT基于比特币网络协议omni

//currencyID   2测试 omni  31正式 ustd
+ (BTCTransaction *)createSignedSimpleSend:(BTCPublicKeyAddress *)from
                    privateKey:(BTCKey *)privateKey
                            to:(BTCPublicKeyAddress *)to
                    currencyID:(NSString *)currencyID
                        amount:(NSString *)amount
                      utxoList:(NSMutableArray <utxoModel*>*)utxoList
                        setFee:(NSString *)sat
                      btcValue:(NSString *)number
//                   uxtoInValue:(BTCAmount)uxtoInValue
{
    
    //omni交易签名字符串，拿着这个字符串广播至BTC网络中即可转账
//    NSString *raxTx = @"";
    
    //omni交易，必须转移的最小的btc数量，固定不用变
    
//    btcValue = 546;
    
    //Todo 手续费默认为1个输入，3个输出了， 费率默认为10sat/kb
//    BTCAmount fee = (148 * 1 + 34 * 2 + 10) * [sat floatValue];
    
    //构造来去方地址
//    BTCPublicKeyAddress *fromAddress = [BTCPublicKeyAddress addressWithString:from];
//    BTCPublicKeyAddress *toAddress = [BTCPublicKeyAddress addressWithString:to];
    
    //Todo demo这里直接取第一个output作为输出了，需要计算utxo金额是否足够
    utxoModel *utxoIn = [utxoList objectAtIndex:0];
    
    //输入总金额
//    BTCAmount uxtoInValue = [utxoIn.count intValue];
    
    //找零金额
//    BTCAmount changeValue = uxtoInValue - btcValue - fee;
    
    
    
    
    CoinModel *coin = [CoinUtil getCoinModel:@"USDT"];
//    float mount = [[CoinUtil convertToSysCoin:number coin:coin.symbol] floatValue];
//    BTCAmount btcValue = mount;
//    BTCAmount usdtValue = mount;
//    if (btcValue < 546) {
//        [TLProgressHUD showInfoWithStatus:@"金额过低"];
//        return nil;
//    }
    
    BTCAmount sumIntputValue = 0;//Intput总额
    int sumIntputCount = 0;//Intput总个数
    BOOL isChange = NO;//是否需要找零
    BTCAmount changeValue = 0;//找零金额
    BTCAmount btcFree = 0;
//    float btcFree = 0;//手续费
    NSMutableArray *IntputUtsos = [NSMutableArray array];
    
    //    计算服务费
    for (int i = 0; i < utxoList.count; i ++) {
        utxoModel* txout = utxoList[i];
        sumIntputCount ++;
        NSString *txoutCount = [CoinUtil convertToRealCoin:txout.count coin:@"BTC"];
        sumIntputValue = sumIntputValue + [[CoinUtil convertToSysCoin:txoutCount coin:@"BTC"] longLongValue];
        [IntputUtsos addObject:txout];
        
        btcFree = (148 * sumIntputCount + 34 * 2 + 10) * [sat floatValue];
        
        //       Intput总额 大于手续费+转账金额
        if (sumIntputValue >= btcFree) {
            //       Intput总额 大于   手续费、找零手续费 + 转账金额
            if (sumIntputValue > (148 * sumIntputCount + 34 * 3 + 10) * [sat floatValue])
            {
                btcFree = (148 * sumIntputCount + 34 * 3 + 10) * [sat floatValue];
                isChange = YES;
                changeValue = sumIntputValue - btcFree;
            }
            break;
        }
    }
    
//    if (btcFree > sumIntputValue) {
//        [TLProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"BTC%@",[LangSwitcher switchLang:@"余额不足" key:nil]]];
//        return nil;
//    }

    //构造交易
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    
    //构造输入
    BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
    txin.previousHash =  BTCHashFromID(utxoIn.txid);
    txin.previousIndex = [utxoIn.vout intValue];
    [tx addInput:txin];
    
    
    BTCScript *omniScript = [[BTCScript alloc] init];
    // 构建payload，创建opretrun，作为交易的一个特殊输出，就可以被识别为omni交易
    
    
    
    NSString *txHex = [self createSimpleSendHex:currencyID amount:[CoinUtil convertToSysCoin:number coin:coin.symbol]];
    NSLog(@"%@",[CoinUtil convertToSysCoin:number coin:coin.symbol]);
    [omniScript appendOpcode:BTCOpcodeForName(@"OP_RETURN")];
    [omniScript appendData:BTCDataFromHex(txHex)];
    
    //构造输出
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:546 address:to];
    [tx addOutput:paymentOutput];
    
//    找零
    if (isChange == YES) {
        BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:changeValue address:from];
        [tx addOutput:changeOutput];
    }
    
    BTCTransactionOutput* omniOutput = [[BTCTransactionOutput alloc] initWithValue:0 script:omniScript];
    [tx addOutput:omniOutput];

    
    //第一个output必须是paymentOutput

    BTCTransactionInput* txinput = tx.inputs[0];
    
//    BTCKey *key = [[BTCKey alloc] initWithWIF:privateKey];
//
    BTCScript *sc = [[BTCScript alloc] initWithData:BTCDataFromHex(utxoIn.scriptPubKey)];
    //        BTCScript *sc = [[BTCScript alloc] initWithString:utxoIn.scriptPubKey];
    NSData* hash = [tx signatureHashForScript:sc inputIndex:0 hashType:BTCSignatureHashTypeAll error:nil];
    NSData* signatureForScript = [privateKey signatureForHash:hash hashType:BTCSignatureHashTypeAll];
    
    BTCScript* sigScript = [[BTCScript alloc] init];
    [sigScript appendData:signatureForScript];
    [sigScript appendData:privateKey.publicKey];
    
    NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
    NSAssert([privateKey isValidSignature:sig hash:hash], @"Signature must be valid");
    
    [txinput setSignatureScript:sigScript];
    
    BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
    BTCScript *script = [[BTCScript alloc] initWithData:BTCDataFromHex(utxoIn.scriptPubKey)];
    //        BTCScript *script = [[BTCScript alloc] initWithString:utxoIn.scriptPubKey];
    BOOL r = [sm verifyWithOutputScript:script error:nil];
    
    NSLog(@"raxTx=%@", [tx hex]);
    return tx;
}

+ (NSString *)createSimpleSendHex:(NSString *)currencyId amount:(NSString *)amount {
    NSString *rawTxHex = [NSString stringWithFormat:@"6f6d6e69%016x%016x", [currencyId intValue], [amount intValue]];
    
    return rawTxHex;
}


+ (NSArray<utxoModel *> *) getUtxoList:(NSString *)address {
    
    static NSMutableArray <utxoModel *> *utxoList;

    TLNetworking *net = [TLNetworking new];
    net.code = @"802220";
    net.parameters[@"address"] = address;
    [net postWithSuccess:^(id responseObject) {
        utxoList = [utxoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"utxoList"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return utxoList;
    
}

@end
