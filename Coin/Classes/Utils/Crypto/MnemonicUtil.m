//
//  MnemonicUtil.m
//  Coin
//
//  Created by haiqingzheng on 2018/6/6.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "MnemonicUtil.h"
#import "Coin-Swift.h"

@implementation MnemonicUtil

+ (void)test{
    
    NSString *mnenomic = [EthCrypto generateMnemonics];
    mnenomic = @"cube oil need license stove style act drive kit ship claw rapid";
    
    NSString *privateKey = [EthCrypto getPrivateKey:mnenomic];
    
    NSString *address = [EthCrypto getAddressWithPrivateKey:privateKey];
    
    NSLog(@"mnenomic=%@", mnenomic);
    NSLog(@"privateKey=%@", privateKey);
    NSLog(@"address=%@", address);
    
}

//+ (BTCMnemonic *)generateNewMnemonic {
//    BTCMnemonic *mnemonic =  [[BTCMnemonic alloc] initWithEntropy:BTCRandomDataWithLength(16) password:nil wordListType:BTCMnemonicWordListTypeEnglish];
//    return mnemonic;
//}
//
//+ (BTCMnemonic *)importMnemonic:(NSArray *)wordList {
//    BTCMnemonic *mnemonic =  [[BTCMnemonic alloc] initWithWords:wordList password:nil wordListType:BTCMnemonicWordListTypeEnglish];
//    return mnemonic;
//}
//
//+ (NSString *)getBtcPrivateKey:(BTCMnemonic *)mnemonic {
//    BTCKeychain *keychain = [mnemonic keychain];
//    return keychain.key.privateKeyAddress.string;
//}
//
//+ (NSString *)getBtcAddress:(BTCMnemonic *)mnemonic {
//    BTCKeychain *keychain = [mnemonic keychain];
//    return keychain.key.address.string;
//}
//
//+ (NSString *)getEthPrivateKey:(BTCMnemonic *)mnemonic {
//    BTCKeychain *keychain = [mnemonic keychain];
//    keychain = [keychain derivedKeychainWithPath:@"m/44'/1'/2'"];
//    
//    return keychain.key.privateKeyAddress.string;
//}
//
//+ (NSString *)getEthAddress:(BTCMnemonic *)mnemonic {
//    BTCKeychain *keychain = [mnemonic keychain];
//    keychain = [keychain derivedKeychainWithPath:@"m/44'/1'/2'"];
//    return [NSString stringWithFormat:@"0x%@", keychain.key.address.string];
//}

@end
