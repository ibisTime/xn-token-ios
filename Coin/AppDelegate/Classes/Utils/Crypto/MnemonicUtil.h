//
//  MnemonicUtil.h
//  Coin
//
//  Created by haiqingzheng on 2018/6/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCMnemonic.h"
@interface MnemonicUtil : NSObject

+ (void)test ;

+ (NSString *)getGenerateMnemonics;

+ (NSString *)getPrivateKeyWithMnemonics: (NSString*)mnemonics;

+ (NSString *)getAddressWithPrivateKey: (NSString*)privateKey;

+ (NSString * )getGasPrice;
+ (NSString * )getWanGasPrice;
+ (NSString * )getEthTokenGasPrice;

+ (NSString * )sendTransactionWithMnemonicWallet: (NSString *)wallet address:(NSString *)address amount:(NSString *)amount gaspic:(NSString*)gasPric gasLimt:(NSString *)gasLimt;

+ (NSString * )sendWanTransactionWithMnemonicWallet: (NSString *)wallet address:(NSString *)address amount:(NSString *)amount gaspic:(NSString*)gasPric gasLimt:(NSString *)gasLimt;

+ (NSString * )sendEthTokenTransactionWithAddress: (NSString *)wallet contractAddress:(NSString *)contract address:(NSString *)address amount:(NSString *)amount gaspic:(NSString*)gasPric gasLimt:(NSString *)gasLimt;

+(NSString *)getMnemonicsISRight:(NSString *)mnemon;


//生成随机的助记词
+ (BTCMnemonic *)generateNewMnemonic;

//导入助记词
+ (BTCMnemonic *)importMnemonic:(NSArray *)wordList;

//获取BTC私钥
+ (NSString *)getBtcPrivateKey:(BTCMnemonic *)mnemonic;

//获取BTC地址
+ (NSString *)getBtcAddress:(BTCMnemonic *)mnemonic;
+ (NSString *)getBtcTheOldAddress:(BTCMnemonic *)mnemonic;
//获取ETH私钥
+ (NSString *)getEthPrivateKey:(BTCMnemonic *)mnemonic;

//获取ETH地址
+ (NSString *)getEthAddress:(BTCMnemonic *)mnemonic;

@end
