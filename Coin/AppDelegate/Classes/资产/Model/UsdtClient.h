//
//  UsdtClient.h
//  Coin
//
//  Created by haiqingzheng on 2018/10/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "utxoModel.h"
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
#import "BTCBase58.h"
@interface UsdtClient : NSObject




//BTCPublicKeyAddress

+ (BTCTransaction *)createSignedSimpleSend:(BTCPublicKeyAddress *)from
                    privateKey:(BTCKey *)privateKey
                            to:(BTCPublicKeyAddress *)to
                    currencyID:(NSString *)currencyID
                        amount:(NSString *)amount
                      utxoList:(NSMutableArray <utxoModel*>*)utxoList
                        setFee:(NSString *)sat
                      btcValue:(NSString *)number;

+ (NSArray<utxoModel *> *) getUtxoList:(NSString *)address;

@end
