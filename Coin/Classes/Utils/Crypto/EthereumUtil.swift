//
//  test.swift
//  Coin
//
//  Created by haiqingzheng on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

import Foundation
import web3swift

public class EthCrypto: NSObject
{
    static public func generateMnemonics() -> String? {
        var str : String!
        do{
        try str = BIP39.generateMnemonics(bitsOfEntropy: 128);
        }
        catch {}
        return str
    }
//    static public var paths: [String:EthereumAddress] = [String:EthereumAddress]()
    
    static public func getISRightKey(_ mnemonics: String) -> Data? {
        var _ : String!
        var seed : Data!
        seed = BIP39.mnemonicsToEntropy(mnemonics)
//        seed = BIP39.mnemonicsToEntropy(mnemonics)
//        guard let prefixNode = HDNode(seed: seed)?.derive(path: HDNode.defaultPathMetamaskPrefix, derivePrivateKey: true) else {return nil}
//
//        var newIndex = UInt32(0)
//        for (p, _) in paths {
//            guard let idx = UInt32(p.components(separatedBy: "/").last!) else {continue}
//            if idx >= newIndex {
//                newIndex = idx + 1
//            }
//        }
//
//        let newNode = prefixNode.derive(index: newIndex, derivePrivateKey: true, hardened: false)
//        privateKeyStr = newNode?.privateKey?.toHexString();
        
        return seed;
    }
    static public var paths: [String:EthereumAddress] = [String:EthereumAddress]()
    
    static public func getPrivateKey(_ mnemonics: String) -> String? {
        var privateKeyStr : String!
        var seed : Data!
        seed = BIP39.seedFromMmemonics(mnemonics);
        seed = BIP39.mnemonicsToEntropy(mnemonics)
        guard let prefixNode = HDNode(seed: seed)?.derive(path: HDNode.defaultPathMetamaskPrefix, derivePrivateKey: true) else {return nil}
        
        var newIndex = UInt32(0)
        for (p, _) in paths {
            guard let idx = UInt32(p.components(separatedBy: "/").last!) else {continue}
            if idx >= newIndex {
                newIndex = idx + 1
            }
        }
        
        let newNode = prefixNode.derive(index: newIndex, derivePrivateKey: true, hardened: false)
        privateKeyStr = newNode?.privateKey?.toHexString();
        
        return privateKeyStr;
    }
    
    static public func getAddress(privateKey: String) -> String? {
        var address : String!
        var publicKey : Data!
       
        publicKey = Web3Utils.privateToPublic(Data.fromHex(privateKey)!)
        address = Web3Utils.publicToAddressString(publicKey);
        return address;
    }
    
}
