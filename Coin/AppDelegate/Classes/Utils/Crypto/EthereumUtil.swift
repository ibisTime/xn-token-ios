//
//  test.swift
//  Coin
//
//  Created by haiqingzheng on 2018/6/7.
//  Copyright © 2018年 chengdai. All rights reserved.
//

import Foundation
import BigInt
import web3swift
//测试
let APPURL = "http://120.26.6.213:8546"
let web3 = Web3.InfuraRinkebyWeb3();
let web3Rinkeby = Web3.InfuraRinkebyWeb3()

//正式
//let APPURL = "http://47.75.165.70:8546"
//let web3 = Web3.InfuraMainnetWeb3();
//
//let web3Rinkeby = Web3.InfuraMainnetWeb3()



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
    
    static public func isValidMnemonice(_ mnemonics: String) -> String? {
        var _ : String!
        var seed : Data!
        seed = BIP39.mnemonicsToEntropy(mnemonics)
        
        if seed != nil {
            return "1"
        } else {
            return "0"
        }
        
        
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
        
//        return seed;
    }
    static public var paths: [String:EthereumAddress] = [String:EthereumAddress]()
    
    static public func getPrivateKey(_ mnemonics: String) -> String? {
        var privateKeyStr : String!
        var seed : Data!
        seed = BIP39.seedFromMmemonics(mnemonics);
//        seed = BIP39.mnemonicsToEntropy(mnemonics)
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
//    static public func isValidAddress(_ address: String) -> String? {
//        var _ : String!
//        var seed : Data!
//        seed = Web3Utils.publicToAddress(<#T##publicKey: Data##Data#>);
////            BIP39.mnemonicsToEntropy(address)
//
//        if seed != nil {
//            return "1"
//        } else {
//            return "0"
//        }
//    }
    static public func gasPriceResult(privateKey: String) -> String? {
        var address : String!
        var publicKey : Data!
        
        publicKey = Web3Utils.privateToPublic(Data.fromHex(privateKey)!)
        address = Web3Utils.publicToAddressString(publicKey);
        return address;
    }

    //获取矿工燃料费用单价
    static public func getGasPrice() -> String? {
        

        //        正式环境
//        let web3 = Web3.InfuraMainnetWeb3();

                //rinkey测试环境，上线需要修改
//        let web3 = Web3.InfuraRinkebyWeb3();

        let gasPriceResult = web3.eth.getGasPrice();
        if case .failure(_) = gasPriceResult {
            return (nil)
        }
        return String.init(gasPriceResult.value!);
        
        //gasPrice
        //gasLimit默认21000
        //默认矿工费用=21000*gasPrice
        
    }
    
    static public func getWanGasPrice() -> String? {
        
        //rinkey测试环境，上线需要修改
//        let web3 = Web3.new(URL.init(string: "http://120.26.6.213:8546")!)
//      正式环境
//        let web3 = Web3.new(URL.init(string: "http://47.75.165.70:8546")!)
        let web3 = Web3.new(URL.init(string: APPURL)!)
        let gasPriceResult = web3?.eth.getGasPrice();
        if case .failure(_)? = gasPriceResult {
            return (nil)
        }
        return String.init((gasPriceResult?.value!)!);
        
        //gasPrice
        //gasLimit默认21000
        //默认矿工费用=21000*gasPrice
        
    }
    
    //获取矿工燃料费用单价
    static public func getETHTokenPrice() -> String? {
        
//          正式环境
//        let web3 = Web3.InfuraMainnetWeb3();
//          测试环境
//                let web3 = Web3.InfuraRinkebyWeb3();

//
//        let gasPriceResult = web3.eth.getGasPrice();
//        if case .failure(_) = gasPriceResult {
//            return (nil)
//        }
//        return String.init(gasPriceResult.value!);
        
        //gasPrice
        //gasLimit默认21000
        //默认矿工费用=21000*gasPrice
        let contractAddress = EthereumAddress("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")! // BKX token on Ethereum mainnet
        let contract = web3.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)! // utilize precompiled ERC20 ABI for your concenience
        let options = web3.options

        guard let bkxBalanceResult = contract.method("balanceOf", parameters: [contractAddress] as [AnyObject], options: options)?.call(options: nil) else {return nil} // encode parameters for transaction
        guard case .success(let bkxBalance) = bkxBalanceResult, let bal = bkxBalance["0"] as? BigUInt else {return nil} // bkxBalance is [String: Any], and parameters are enumerated as "0", "1", etc in order of being returned. If returned parameter has a name in ABI, it is also duplicated
        print("BKX token balance = " + String(bal))
        return ""
        
    }
    
    //发送ETH交易（签名并广播）
    static public func sendTransaction(mnemonic: String, to: String, amount: String, gasPrice: String, gasLimit: String) -> String? {
        
        var txHash : String!
//        txHash = "";
        do{
           
            let keystore = try! BIP32Keystore(mnemonics: mnemonic, password: "BANKEXFOUNDATION", mnemonicsPassword: "")
//            正式环境
//            let web3Rinkeby = Web3.InfuraMainnetWeb3()

//            测试环境
//             let web3Rinkeby = Web3.InfuraRinkebyWeb3()
            let keystoreManager = KeystoreManager.init([keystore!])
            web3Rinkeby.addKeystoreManager(keystoreManager)
            
            var options = Web3Options.defaultOptions()
            options.gasLimit = BigUInt(21000)
            options.gasPrice = BigUInt(gasPrice)
            options.from = keystore?.addresses?.first!
            let am = BigUInt.init(amount)
            options.value = am
            let toaddress = EthereumAddress(to)
           
           
            let intermediateSend = web3Rinkeby.contract(Web3.Utils.coldWalletABI, at: toaddress, abiVersion: 2)!.method(options: options)!
            let sendResult = intermediateSend.send(password: "BANKEXFOUNDATION")
            switch sendResult {
            case .success(let r):
                print("Sucess",r.values.first as Any)
                txHash=r.values.first as Any as! String
                //todo 返回交易hash
            case .failure(let err):
                print("Eroor",err)
            }
            if txHash != nil {
               txHash =  "1"
            } else {
              txHash = "0"
            }
            
        }
        
        return txHash;
    
    }
    
    //发送ETHToken交易（签名并广播）
    static public func sendEthTokenTransaction(mnemonic: String,con: String, to: String, amount: String, gasPrice: String, gasLimit: String) -> String? {
        
        var txHash : String!
        //        txHash = "";
        do{
            let keystore = try! BIP32Keystore(mnemonics: mnemonic, password: "BANKEXFOUNDATION", mnemonicsPassword: "")
//            测试环境
//            let web3Rinkeby = Web3.InfuraRinkebyWeb3()
//            正式环境
//              let web3Rinkeby = Web3.InfuraMainnetWeb3()
            let keystoreManager = KeystoreManager.init([keystore!])
            web3Rinkeby.addKeystoreManager(keystoreManager)
            var convenienceTransferOptions = Web3Options.defaultOptions()
            convenienceTransferOptions.gasLimit = BigUInt(210000)

            convenienceTransferOptions.gasPrice = BigUInt(gasPrice)
//            let contractAddress = EthereumAddress("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")!
            let convenienceTokenTransfer = web3Rinkeby.eth.sendERC20tokensWithNaturalUnits(tokenAddress: EthereumAddress(con)!, from: (keystore?.addresses?.first!)!, to: EthereumAddress(to)!, amount: amount, options: convenienceTransferOptions) // there are also convenience functions to send ETH and ERC20 under the .eth structure

//            let gasEstimateResult = convenienceTokenTransfer!.estimateGas(options: nil)
//            guard case .success(let gasEstimate) = gasEstimateResult else {return nil}
//            convenienceTransferOptions.gasLimit  = BigUInt(80000)
//            convenienceTransferOptions.gasLimit = gasEstimate
            let convenienceTransferResult = convenienceTokenTransfer!.send(password: "BANKEXFOUNDATION", options: convenienceTransferOptions)
            switch convenienceTransferResult {
            case .success(let res):
                print("Token transfer successful")
                print(res)
                txHash=res.values.first as Any as! String

            case .failure(let error):
                print(error)
            }
            
            if txHash != nil {
                txHash =  "1"
            } else {
                txHash = "0"
            }
            
        }
        
        return txHash;
        
    }


    //判断地址是否正确
//    static public func getEthereumAddress(to: String) -> String?
//    {
//        let toaddress = EthereumAddress(to)
//        return toaddress;
//    }
    
    //发送WAN交易（签名并广播）
    static public func sendWanTransaction(mnemonic: String, to: String, amount: String, gasPrice: String, gasLimit: String) -> String? {
        
        var txHash : String!
//                txHash = "";
        do{
            
            let keystore = try! BIP32Keystore(mnemonics: mnemonic, password: "BANKEXFOUNDATION", mnemonicsPassword: "")
//            正式环境
            let web3wan = Web3.new(URL.init(string: APPURL)!)
//            测试环境
//            let web3wan = Web3.new(URL.init(string: "http://120.26.6.213:8546")!)

            let keystoreManager = KeystoreManager.init([keystore!])
            web3wan?.addKeystoreManager(keystoreManager)
            
            var options = Web3Options.defaultOptions()
            options.Txtype = BigUInt(1)
            options.gasLimit = BigUInt(21000)
            options.gasPrice = BigUInt(gasPrice)
            options.from = keystore?.addresses?.first!
            let am = BigUInt.init(amount)
            options.value = am
            let toaddress = EthereumAddress(to)
            
            
            let intermediateSend = web3wan?.contract(Web3.Utils.coldWalletABI, at: toaddress, abiVersion: 2)!.method(options: options)!
            let sendResult = intermediateSend?.send(password: "BANKEXFOUNDATION")
            switch sendResult {
            case .success(let r)?:
                print("Sucess",r.values.first as Any)
                txHash=r.values.first as Any as! String
                if txHash != nil {
                    txHash =  "1"
                } else {
                    txHash = "0"
                }
            //todo 返回交易hash
            case .failure(let err)?:
                print("Eroor",err)
            
//            if txHash != nil {
//                txHash =  "1"
//            } else {
//                txHash = "0"
//            }
            
            case .none: break
                
            }
        
        return txHash;
        
        }
        
    }
    
    //发送WANtoken交易（签名并广播）
    static public func sendWanTokenTransaction(mnemonic: String,con: String, to: String, amount: String, gasPrice: String, gasLimit: String) -> String? {
        
        var txHash : String!
        //        txHash = "";
        do{
            
            let keystore = try! BIP32Keystore(mnemonics: mnemonic, password: "BANKEXFOUNDATION", mnemonicsPassword: "")
//            测试环境
//            let web3Rinkeby = Web3.InfuraRinkebyWeb3()
//            正式环境
//            let web3Rinkeby = Web3.InfuraMainnetWeb3()
            let keystoreManager = KeystoreManager.init([keystore!])
            web3Rinkeby.addKeystoreManager(keystoreManager)
            
            var options = Web3Options.defaultOptions()
//            options.Txtype = BigUInt(1)
            options.gasLimit = BigUInt(21000)
            options.gasPrice = BigUInt(gasPrice)
            options.from = keystore?.addresses?.first!
            let am = BigUInt.init(amount)
            options.value = am
            let toaddress = EthereumAddress(to)
            let convenienceTokenTransfer = web3Rinkeby.eth.sendERC20tokensWithNaturalUnits(tokenAddress: EthereumAddress(con)!, from: (keystore?.addresses?.first!)!, to: EthereumAddress(to)!, amount: amount, options: options)
//
//            let intermediateSend = web3Rinkeby?.contract(Web3.Utils.coldWalletABI, at: toaddress, abiVersion: 2)!.method(options: options)!
//            let sendResult = intermediateSend?.send(password: "BANKEXFOUNDATION")
//            switch sendResult {
//            case .success(let r)?:
//                print("Sucess",r.values.first as Any)
//                txHash=r.values.first as Any as! String
//                if txHash != nil {
//                    txHash =  "1"
//                } else {
//                    txHash = "0"
//                }
//            //todo 返回交易hash
//            case .failure(let err)?:
//                print("Eroor",err)
            
                //            if txHash != nil {
                //                txHash =  "1"
                //            } else {
                //                txHash = "0"
                //            }
                
//            case .none: break
//                
//            }
            
            return txHash;
            
        }
        
    }
    
    
//    public struct Web3s {
//
//        public static func new(_ providerURL: URL) -> web3? {
//            guard let provider = Web3HttpProvider(providerURL) else {return nil}
//            return web3(provider: provider)
//        }
//    }
//    var web3: web3
//    public var options: Web3Options {
//        return self.web3.options
//    }
    
//    var ethInstance: web3.Eth?
//    public var eth: web3.Eth {
//        if (self.ethInstance != nil) {
//            return self.ethInstance!
//        }
////        self.ethInstance = web3.Eth(provider : Web3Operation as! Web3Provider, web3: we)
//        return self.ethInstance!
//    }
//    var myTV = Web3()
    
    
//    transaction.gasPrice = gasPriceResult.value!
//    options.gasPrice = gasPriceResult.value!
//    guard let gasEstimate = self.estimateGas(transaction, options: options) else {return (nil, nil)}
//    transaction.gasLimit = gasEstimate
//    options.gasLimit = gasEstimate
//    print(transaction)
//    return (transaction, options)

    
    

}
