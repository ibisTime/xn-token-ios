//
//  WalletForwordVC.m
//  Coin
//
//  Created by shaojianfei on 2018/6/11.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "WalletForwordVC.h"
#import "UIBarButtonItem+convience.h"
#import "TLAlert.h"
#import "NSString+Check.h"
#import "UIViewController+BackButtonHander.h"
#import "APICodeMacro.h"

#import "BillVC.h"
#import "TLCoinWithdrawOrderVC.h"
#import "TLTextField.h"
#import "FilterView.h"
#import "QRCodeVC.h"
#import "CoinAddressListVC.h"
#import "CoinUtil.h"
#import "MnemonicUtil.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MnemonicUtil.h"
#import "CoinUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>
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
typedef NS_ENUM(NSInteger, WalletAddressType) {
    
    WalletAddressTypeSelectAddress = 0,       //选择地址
    WalletAddressTypeScan,                    //扫码
    WalletAddressTypeCopy,                    //复制粘贴
};
typedef enum : NSUInteger {
    BTCAPIChain,
    BTCAPIBlockchain,
} BTCAPI;
@interface WalletForwordVC ()
//可用余额
@property (nonatomic, strong) TLTextField *balanceTF;
//接收地址
@property (nonatomic, strong) UILabel *receiveAddressLbl;
//选择
@property (nonatomic, strong) FilterView *coinAddressPicker;

//矿工费
@property (nonatomic, strong) FilterView *WorkMoneyPicker;

//转账数量
@property (nonatomic, strong) TLTextField *tranAmountTF;
//谷歌验证码
@property (nonatomic, strong) TLTextField *googleAuthTF;
//矿工费
@property (nonatomic, strong) TLTextField *minerFeeTF;
//开关
@property (nonatomic, strong) UISwitch *sw;
//提示
@property (nonatomic, strong) UIView *minerView;
//确认付币
@property (nonatomic, strong) UIButton *confirmBtn;
//手续费率
@property (nonatomic, copy) NSString *withdrawFee;
//地址类型
@property (nonatomic, assign) WalletAddressType addressType;
//地址
@property (nonatomic, strong) CoinAddressModel *addressModel;

@property (nonatomic, strong) UILabel *choseLab;
//矿工费
@property (nonatomic, assign) CGFloat gamPrice;

@property (nonatomic, copy) NSString *pricr;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UILabel * blanceFree;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, copy) NSString *word;
@property (nonatomic, strong) UILabel *symbolBlance;

@property (nonatomic, copy) NSString *btcAddress;

@property (nonatomic, copy) NSString *btcPrivate;
@property (nonatomic, strong) NSMutableArray <utxoModel *>*utxis;

@property (nonatomic, copy) NSString *signTx;

@property (nonatomic, copy) NSString *priceSlow ;
@property (nonatomic, copy) NSString *priceFast;

@end

@implementation WalletForwordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LangSwitcher switchLang:@"转账" key:nil];
    self.view.backgroundColor = kWhiteColor;
    //记录
    [self addRecordItem];
    //
    [self initSubviews];
    [self loadPwd];
    //矿工费
    //获取手续费费率
//    [self setWithdrawFee];
    // Do any additional setup after loading the view.
}

- (void)loadPwd
{
    
    TLDataBase *dataBase = [TLDataBase sharedManager];
//    NSString *word;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT PwdKey from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            self.word = [set stringForColumn:@"PwdKey"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    
}
- (BOOL)navigationShouldPopOnBackButton {
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self loadUtxoList];
    
//    [self getgamProce];

    [super viewDidAppear:animated];
}

- (void)loadUtxoList
{
    
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *btcaddress;
    NSString *btcprivate;

    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT btcaddress,btcprivate from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            btcaddress = [set stringForColumn:@"btcaddress"];
            btcprivate = [set stringForColumn:@"btcprivate"];

        }
        [set close];
    }
    [dataBase.dataBase close];
    self.btcAddress = btcaddress;
    self.btcPrivate = btcprivate;

    TLNetworking *net = [TLNetworking new];
    
    
    net.code = @"802220";
    net.parameters[@"address"] = btcaddress;
    
    
    [net postWithSuccess:^(id responseObject) {
       NSString *blance = responseObject[@"data"][@"balance"];
        
        CoinModel *currentCoin = [CoinUtil getCoinModel:@"BTC"];
//
//        NSString *leftAmount = [blance subNumber:currentCoin.withdrawFeeString];
        NSString *text =  [CoinUtil convertToRealCoin:blance coin:@"BTC"];

        self.symbolBlance.text = [NSString stringWithFormat:@"%.8f %@",[text floatValue],self.currency.symbol];
        NSLog(@"%@",responseObject);
        
        self.utxis = [utxoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"utxoList"]];
        [self testSpendCoins:BTCAPIChain];

        [self loadHash];
        
        NSLog(@"%@",self.utxis);
//        [self.tableView endRefreshHeader];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);

//        [self.tableView endRefreshHeader];
    }];
}

- (void)loadHash
{
    TLNetworking *net = [TLNetworking new];
    
    
    net.code = @"802222";
    net.parameters[@"signTx"] = self.signTx;
    
    [net postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void) testSpendCoins:(BTCAPI)btcAPI {
    // For safety I'm not putting a private key in the source code, but copy-paste here from Keychain on each run.为了安全起见，我没有在源代码中放入私钥，而是在每次运行时从Keychain复制粘贴过来。
    
    
//    NSString * str＝ self._btcPrivate;
//     char * a =[self.btcPrivate UTF8String];
////    printf("Private key in hex:\n");
////    char str[1000] = {self.btcPrivate};
//    gets(a);
    
    NSData* privateKey = BTCDataWithHexCString([@"cSgaJMM6sKhFMXFq1jVFUJp657nojoApaXb3kv1ma1SC1PwGujTB" UTF8String]);
    NSLog(@"Private key: %@", privateKey);
    
    BTCKey* key = [[BTCKey alloc] initWithPrivateKey:privateKey];
    key.publicKeyCompressed = NO;
    BTCKeychain *keychain = [[BTCKeychain  alloc] initWithSeed:privateKey];
    
    NSLog(@"Address: %@", keychain.key.privateKeyAddressTestnet.string);

//    NSLog(@"Address: %@", key.compressedPublicKeyAddress);
    
    if (![@"mta8isvnW6GbrzmqAMJCyfiYVEWAtHRUHJ" isEqualToString:key.compressedPublicKeyAddress.string]) {
        NSLog(@"WARNING: incorrect private key is supplied");
        return;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSError* error = nil;
    BTCTransaction* transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                                       to:[BTCPublicKeyAddressTestnet addressWithString:@"mta8isvnW6GbrzmqAMJCyfiYVEWAtHRUHJ"]
                                                                   change:key.compressedPublicKeyAddress // send change to the same address
                                                                   amount:0.02*100000000
                                                                      fee:0.001*100000000
                                                                      api:btcAPI
                                                                    error:&error];

    if (!transaction) {
        NSLog(@"Can't make a transaction: %@", error);
    }
    self.signTx = BTCHexFromData([transaction data]);

    NSLog(@"transaction = %@", transaction.dictionary);
    NSLog(@"transaction in hex:\n------------------\n%@\n------------------\n", BTCHexFromData([transaction data]));
    return;
    TLNetworking *net = [TLNetworking new];
    
    
    net.code = @"802222";
    net.parameters[@"signTx"] = [[NSString alloc] initWithData:[transaction data] encoding:NSUTF8StringEncoding];
    
    [net postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    return;
    NSLog(@"Sending in 5 sec...");
    sleep(5);
    NSLog(@"Sending...");
    sleep(1);
    NSURLRequest* req = [[[BTCChainCom alloc] initWithToken:@"Free API Token form chain.com"] requestForTransactionBroadcastWithData:[transaction data]];
    NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];

    NSLog(@"Broadcast result: data = %@", data);
    NSLog(@"string = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}


// Simple method for now, fetching unspent coins on the fly //目前的方法很简单，即动态提取未使用的硬币


- (BTCTransaction*) transactionSpendingFromPrivateKey:(NSData*)privateKey
                                                   to:(BTCPublicKeyAddress*)destinationAddress
                                               change:(BTCPublicKeyAddress*)changeAddress
                                               amount:(BTCAmount)amount
                                                  fee:(BTCAmount)fee
                                                  api:(BTCAPI)btcApi
                                                error:(NSError**)errorOut
{
    // 1. Get a private key, destination address, change address and amount
    // 2. Get unspent outputs for that key (using both compressed and non-compressed pubkey)
    // 3. Take the smallest available outputs to combine into the inputs of new transaction
    // 4. Prepare the scripts with proper signatures for the inputs
    // 5. Broadcast the transaction
    
    /// 1。获取私钥、目标地址、更改地址和金额
    
    // 2。获取该键的未使用的输出(使用压缩和非压缩pubkey)
    
    // 3。将最小的可用输出合并到新事务的输入中
    
    // 4。为输入准备带有适当签名的脚本
    
    // 5。广播事务
    BTCKey* key = [[BTCKey alloc] initWithPrivateKey:privateKey];
   
   BTCNetwork *net = [[BTCNetwork alloc] initWithName:@"testnet3"];
    NSLog(@"%d",net.isTestnet);
    NSError* error = nil;
    NSArray* utxos = self.utxis;
    
//    switch (btcApi) {
//        case BTCAPIBlockchain: {
//            BTCBlockchainInfo* bci = [[BTCBlockchainInfo alloc] init];
//            utxos = [bci unspentOutputsWithAddresses:@[ key.compressedPublicKeyAddress ] error:&error];
//            break;
//        }
//        case BTCAPIChain: {
//            BTCChainCom* chain = [[BTCChainCom alloc] initWithToken:@"Free API Token form chain.com"];
//            utxos = [chain unspentOutputsWithAddress:key.compressedPublicKeyAddress error:&error];
//            break;
//        }
//        default:
//            break;
//    }
    
    NSLog(@"UTXOs for %@: %@ %@", key.compressedPublicKeyAddress, utxos, error);
    
    // Can't download unspent outputs - return with error. //无法下载未使用的输出-返回错误。
    
    
//    if (!utxos) {
//        *errorOut = error;
//        return nil;
//    }
    
    
    // Find enough outputs to spend the total amount. //找到足够的产出来花完总量。
    
    
    BTCAmount totalAmount = amount + fee;
    BTCAmount dustThreshold = 100000; // don't want less than 1mBTC in the change.
    
    // We need to avoid situation when change is very small. In such case we should leave smallest coin alone and add some bigger one.
    // Ideally, we need to maintain more-or-less binary distribution of coins: having 0.001, 0.002, 0.004, 0.008, 0.016, 0.032, 0.064, 0.128, 0.256, 0.512, 1.024 etc.
    // Another option is to spend a coin which is 2x bigger than amount to be spent.
    // Desire to maintain a certain distribution of change to closely match the spending pattern is the best strategy.
    // Yet another strategy is to minimize both current and future spending fees. Thus, keeping number of outputs low and change sum above "dust" threshold.
    
    // For this test we'll just choose the smallest output.
    
    // 1. Sort outputs by amount
    // 2. Find the output that is bigger than what we need and closer to 2x the amount.
    // 3. If not, find a bigger one which covers the amount + reasonably big change (to avoid dust), but as small as possible.
    // 4. If not, find a combination of two outputs closer to 2x amount from the top.
    // 5. If not, find a combination of two outputs closer to 1x amount with enough change.
    // 6. If not, find a combination of three outputs.
    // Maybe Monte Carlo method is a way to go.
    
    
    // Another way:
    // Find the minimum number of txouts by scanning from the biggest one.
    // Find the maximum number of txouts by scanning from the lowest one.
    // Scan with a minimum window increasing it if needed if no good enough change can be found.
    // Yet another option: finding combinations so the below-the-dust change can go to miners.
    //我们需要避免变化很小的情况。在这种情况下，我们应该留下最小的硬币，并增加一些更大的。
    
    //理想情况下，我们需要保持硬币的或多或少的二元分布:有0.001、0.002、0.004、0.008、0.016、0.032、0.064、0.128、0.256、0.512、1.024等。
    
    //另一种选择是花一枚比要花的钱多两倍的硬币。
    
    //希望保持一定的分布变化，以密切配合消费模式是最好的策略。
    
    //另一个策略是尽量减少当前和未来的支出费用。因此，将输出数量保持在低水平，并将总数更改到“尘埃”阈值以上。
    
    
    //对于这个测试，我们只选择最小的输出。
    
    
    // / 1。排序输出的数量
    
    // 2。找到比我们需要的更大的输出，接近2倍的输出。
    
    // 3。如果没有，那就找一个更大的吧，它能覆盖足够大的变化(避免灰尘)，但要尽可能小。
    
    // 4。如果不是，从顶部找到两个接近2x的输出的组合。
    
    // 5。如果没有，找到两个输出的组合，它们的数量接近1倍，并且有足够的变化。
    
    /// 6。如果没有，找到三个输出的组合。
    
    //也许蒙特卡洛方法是一种方法。
    
    
    
    // /另一种方式:
    
    //从最大的一个扫描到最小的txout数。
    
    //通过从最低的一个扫描找到最大的txout数。
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.utxis.count; i++) {
        utxoModel *newut = [utxoModel new];
        newut = self.utxis[i];
        newut.count = [CoinUtil convertToRealCoin:self.utxis[i].count coin:@"BTC"];
        [arr addObject:newut];
    }
    utxos = [arr sortedArrayUsingComparator:^(utxoModel* obj1, utxoModel* obj2) {
        if (([obj1.count floatValue] - [obj2.count floatValue]) < 0) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
    NSArray* txouts = nil;
    
    for (utxoModel* txout in arr) {
        BTCAmount a = [[CoinUtil convertToSysCoin:txout.count coin:@"BTC"] longLongValue];
//                        convertToRealCoin:txout.count coin:@"BTC"] longLongValue];

        if ( a > (totalAmount + dustThreshold)) {
            txouts = @[ txout ];
            break;
        }
    }
    
    
    //扫描与最小窗口增加，如果需要，如果没有足够好的变化可以找到。
    
    //还有另一种选择:寻找各种组合，以便让矿商能够实现“低于尘埃的改变”。
    
    // Sort utxo in order of
//    utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput* obj1, BTCTransactionOutput* obj2) {
//        if ((obj1.value - obj2.value) < 0) return NSOrderedAscending;
//        else return NSOrderedDescending;
//    }];
//
//    NSArray* txouts = nil;
//
//    for (BTCTransactionOutput* txout in utxos) {
//        if (txout.value > (totalAmount + dustThreshold) && txout.script.isPayToPublicKeyHashScript) {
//            txouts = @[ txout ];
//            break;
//        }
//    }
    
    // We support spending just one output for now. 我们目前只支持支出一项产出。
    
    
    if (!txouts) return nil;
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (utxoModel* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.previousHash = [txout.txid dataUsingEncoding:NSUTF8StringEncoding];
        txin.previousIndex = [txout.vout intValue];
        [tx addInput:txin];
        
        NSLog(@"txhash: http://blockchain.info/rawtx/%@", BTCHexFromData(txin.previousHash));
        NSLog(@"txhash: http://blockchain.info/rawtx/%@ (reversed)", BTCHexFromData(BTCReversedData([txout.scriptPubKey dataUsingEncoding:NSUTF8StringEncoding])));
        
        spentCoins +=  [[CoinUtil convertToSysCoin:txout.count coin:@"BTC"] longLongValue];
    }
    
    NSLog(@"Total satoshis to spend:       %lld", spentCoins);
    NSLog(@"Total satoshis to destination: %lld", amount);
    NSLog(@"Total satoshis to fee:         %lld", fee);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins - (amount + fee)));
    
    // Add required outputs - payment and change
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:destinationAddress];
    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - (amount + fee)) address:changeAddress];
    
    // Idea: deterministically-randomly choose which output goes first to improve privacy.//想法:确定随机选择哪个输出优先用于提高隐私。
    
    
    [tx addOutput:paymentOutput];
    [tx addOutput:changeOutput];
    
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction. / /所有输入信号。现在我们已经定义了输入和输出，因此可以对事务进行签名。
    
    
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this 通常情况下，我们需要找到合适的钥匙来签这个txin，example we already know that we use a single private key.但是在这个例我们已经知道我们使用的是一个私钥。
        
        
        utxoModel* txout = txouts[i]; // output from a previous tx which is referenced by this txin. 此txin引用的前一个tx的输出。
        
        
        BTCTransactionInput* txin = tx.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        
        
        NSData* d1 = tx.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        BTCScript *sc = [[BTCScript alloc] initWithString:txout.scriptPubKey];
        NSData* hash = [tx signatureHashForScript:sc inputIndex:i hashType:hashtype error:errorOut];
        
        NSData* d2 = tx.data;
        
        NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");
        
        // 134675e153a5df1b8e0e0f0c45db0822f8f681a2eb83a0f3492ea8f220d4d3e4
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        if (!hash) {
            return nil;
        }
        
        NSData* signatureForScript = [key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        NSAssert([key isValidSignature:sig hash:hash], @"Signature must be valid");
        
        txin.signatureScript = sigScript;
    }
    
    // Validate the signatures before returning for extra measure. 在返回额外度量之前验证签名。
    
    
//    {
//        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
//        NSError* error = nil;
//        BOOL r = [sm verifyWithOutputScript:[[(BTCTransactionOutput*)txouts[0] script] copy] error:&error];
//        NSLog(@"Error: %@", error);
//        NSAssert(r, @"should verify first output");
//    }
    
    // Transaction is signed now, return it. 交易现已签署，返回
    
    
    return tx;
}




#warning BTC转账测试!!
- (void)getgamProce
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *pricr;
        if ([self.currency.symbol isEqualToString:@"BTC"]) {
            TLNetworking *net = [TLNetworking new];
            
            
            net.code = @"802223";
            
            [net postWithSuccess:^(id responseObject) {
                NSLog(@"%@",responseObject);
                NSNumber *slow = responseObject[@"data"][@"fastestFeeMin"];
                NSNumber *fast = responseObject[@"data"][@"fastestFeeMax"];

                int f = ([slow intValue] +[fast intValue])/2;
                NSString *priceSlow = [CoinUtil convertToRealCoin:[NSString stringWithFormat:@"%@",slow] coin:@"BTC"];
                NSString *priceFast = [CoinUtil convertToRealCoin:[NSString stringWithFormat:@"%@",fast] coin:@"BTC"];
                self.priceSlow = priceSlow;
                self.priceFast = priceFast;
                NSString *price = [CoinUtil convertToRealCoin:[NSString stringWithFormat:@"%d",f] coin:@"BTC"];

                NSLog(@"%@low@,fast%@",priceSlow,priceFast);
                self.gamPrice = [price floatValue ] ;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self WorkpickerEventWithIndex:1];
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
        }else{

        if ([self.currency.symbol isEqualToString:@"ETH"]) {
            pricr = [MnemonicUtil getGasPrice];
        }else
        {
            pricr = [MnemonicUtil getWanGasPrice];
            
        }
        self.pricr = pricr;
        CGFloat p = [pricr doubleValue]/1000000000000000000;
        p = p *21000;
        NSLog(@"%.8f",p);
        self.gamPrice = p;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self WorkpickerEventWithIndex:1];
        }
    });
   
  
}
#pragma mark -
- (void)addRecordItem {
    
//    [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"记录" key:nil]
//                                titleColor:kTextColor
//                                     frame:CGRectMake(0, 0, 40, 30)
//                                        vc:self
//                                    action:@selector(clickRecord:)];
    
}

- (void)initSubviews {
    
    UIView *top = [[UIView alloc] init];
    [self.view addSubview:top];
    top.backgroundColor = kHexColor(@"#0848DF");
    
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    
    self.bgImage = bgImage;
    bgImage.image = kImage(@"提背景");
    bgImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@90);
        
    }];
    
    UILabel *blance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:12];
    blance.text = [LangSwitcher switchLang:@"可用余额" key:nil];
    [bgImage addSubview:blance];
    [blance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_top).offset(19);
        make.centerX.equalTo(bgImage.mas_centerX);

    }];
    UILabel *symbolBlance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:24];
    [bgImage addSubview:symbolBlance];
    self.symbolBlance = symbolBlance;
    symbolBlance.text = [NSString stringWithFormat:@"%.6f %@",[self.currency.balance doubleValue]/1000000000000000000,self.currency.symbol];
    [symbolBlance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blance.mas_bottom).offset(2);
        make.centerX.equalTo(bgImage.mas_centerX);
        
    }];
    
    CGFloat heightMargin = 50;
    //余额
    self.balanceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, kHeight(103), kScreenWidth-30, heightMargin+20)
                                              leftTitle:[LangSwitcher switchLang:@"接收地址" key:nil]
                                             titleWidth:80
                                            placeholder:[LangSwitcher switchLang:@"请输入付币地址或扫码" key:nil]];
 
    self.balanceTF.textColor = kHexColor(@"#109ee9");
    if (kDevice_Is_iPhoneX) {
        self.balanceTF.font =FONT(11);

    }else{
        
        self.balanceTF.font =FONT(10);

    }
//    [UIFont systemFontOfSize:10];
    
//    self.balanceTF.textAlignment = NSTextAlignmentCenter;
//    NSString *leftAmount = [self.currency.amountString subNumber:self.currency.frozenAmountString];
//
//    NSString *currentCurrency = self.currency.currency;
//    self.balanceTF.text = [NSString stringWithFormat:@"%.8f %@",[self.currency.balance doubleValue]/1000000000000000000,self.currency.symbol];



    [self.view addSubview:self.balanceTF];
    
//    //接受地址
//    UIView *receiveView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight(133), kScreenWidth, heightMargin)];
//
//    receiveView.backgroundColor = kWhiteColor;
//
//    [self.view addSubview:receiveView];
    //更多
    UIImageView *rightArrowIV = [[UIImageView alloc] initWithImage:kImage(@"扫一扫-黑色")];
    rightArrowIV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:rightArrowIV];
    rightArrowIV.userInteractionEnabled = YES;
    [rightArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.balanceTF.mas_centerY);
        make.width.equalTo(@18);
        make.height.equalTo(@18);

    }];
    
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [rightArrowIV addGestureRecognizer:ta];
//
//    //
//    UILabel *receiveTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
//
//    receiveTextLbl.text = [LangSwitcher switchLang:@"接收地址" key:nil];
//
//    [receiveView addSubview:receiveTextLbl];
//    [receiveTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.centerY.equalTo(receiveView.mas_centerY);
//
//    }];
//
//    UIView *receiveLine = [[UIView alloc] init];
//
//    receiveLine.backgroundColor = kLineColor;
//
//    [receiveView addSubview:receiveLine];
//    [receiveLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.bottom.right.equalTo(@0);
//        make.height.equalTo(@0.5);
//
//    }];
//
    //获取placeholder的颜色
    //    UIColor *placeholderColor = [[[UITextField alloc] init] valueForKeyPath:@"_placeholderLabel.textColor"];
    
//    UILabel *receiveAddressLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kPlaceholderColor font:14.0];
//
//    receiveAddressLbl.text = [LangSwitcher switchLang:@"请粘贴地址或扫码录入" key:nil];
//
//    receiveAddressLbl.numberOfLines = 0;
//
//    [receiveView addSubview:receiveAddressLbl];
//    [receiveAddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(receiveTextLbl.mas_right).offset(5);
//        make.right.equalTo(rightArrowIV.mas_left).offset(-10);
//        make.centerY.equalTo(receiveView.mas_centerY);
//
//    }];
//
//    self.receiveAddressLbl = receiveAddressLbl;
    
    //
//    UIButton *receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, kHeight(133) + 10, kScreenWidth, heightMargin)];
//
//    [receiveBtn addTarget:self action:@selector(selectCoinAddress) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:receiveBtn];
    
    //谷歌验证码
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy, kScreenWidth, heightMargin)
                                                 leftTitle:[LangSwitcher switchLang:@"谷歌验证码" key:nil]
                                                titleWidth:100
                                               placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil] ];
    
    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.googleAuthTF];
    
    //复制
    UIView *authView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, self.googleAuthTF.height)];
    
    UIButton *pasteBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"粘贴" key:nil]
                                        titleColor:kWhiteColor
                                   backgroundColor:kAppCustomMainColor
                                         titleFont:13.0
                                      cornerRadius:5];
    
    pasteBtn.frame = CGRectMake(0, 0, 85, self.googleAuthTF.height - 15);
    
    pasteBtn.centerY = authView.height/2.0;
    
    [pasteBtn addTarget:self action:@selector(clickPaste) forControlEvents:UIControlEventTouchUpInside];
    
    [authView addSubview:pasteBtn];
    
    self.googleAuthTF.rightView = authView;
    
    //分割线
    UIView *googleLine = [[UIView alloc] init];
    
    googleLine.backgroundColor = kLineColor;
    
    [self.googleAuthTF addSubview:googleLine];
    [googleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    //转账数量
    self.tranAmountTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.balanceTF.yy, kScreenWidth, heightMargin)
                                                 leftTitle:[LangSwitcher switchLang:@"转账数量" key:nil]
                                                titleWidth:80
                                               placeholder:[LangSwitcher switchLang:@"请填写付币数量" key:nil]
                         ];
    
    [self.tranAmountTF setValue:kPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.tranAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    //    [self.tranAmountTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:self.tranAmountTF];
    
    //矿工费
    self.minerFeeTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.tranAmountTF.yy + 10, kScreenWidth-30, heightMargin)
                                               leftTitle:[LangSwitcher switchLang:@"矿工费" key:nil]
                                              titleWidth:80
                                             placeholder:nil];
    
    self.minerFeeTF.enabled = NO;
    self.minerFeeTF.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];

    self.minerFeeTF.font = [UIFont systemFontOfSize:11];
    
//    self.minerFeeTF.text = [NSString stringWithFormat:@"-- %@", self.currency.currency];
    
    UILabel *free = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:12];
    free.frame = CGRectMake(80, self.tranAmountTF.yy + 10, kScreenWidth-100, heightMargin);
    free.text = [LangSwitcher switchLang:@"矿工费将在可用余额中扣除，余额不足将从转账金额中扣除" key:nil];
    free.numberOfLines = 0;
//    [LangSwitcher switchLang:@"矿工费将在可用余额中扣除，余额不足将从转账金额中扣除"];
    [self.view addSubview:self.minerFeeTF];

    [self.view addSubview:free];
    [self.minerFeeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(self.tranAmountTF.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(heightMargin));
        
    }];
    
    UISlider *slider = [UISlider new];
    self.slider = slider;
    [self.view addSubview:slider];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0;
    slider.thumbTintColor = kHexColor(@"#1B61F0");
    slider.minimumTrackTintColor = kHexColor(@"#1B61F0");
    slider.maximumTrackTintColor = kHexColor(@"#DDE6F9");
    slider.value = 0.5;
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.minerFeeTF.mas_bottom).offset(30);
        make.width.equalTo(@(kScreenWidth-30));
        make.height.equalTo(@(20));
    }];
    
    UILabel * solw = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#AAAAAA") font:12];
    solw.text = [LangSwitcher switchLang:@"慢" key:nil];
      UILabel * fast = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#AAAAAA") font:12];
    fast.text = [LangSwitcher switchLang:@"快" key:nil];
    UILabel * blanceFree = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    self.blanceFree = blanceFree;
    blanceFree.text = [LangSwitcher switchLang:@"快" key:nil];

    [self.view addSubview:solw];
    [self.view addSubview:blanceFree];

    [self.view addSubview:fast];
    
    [solw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(slider.mas_bottom).offset(20);
        

    }];
    [fast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(slider.mas_bottom).offset(20);
        
        
    }];
    
    [blanceFree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(slider.mas_bottom).offset(20);
        
        
    }];

//    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
////    rightArrow.frame = CGRectMake(0, self.tranAmountTF.yy + 10, 30, 20);
//    [self.view addSubview:rightArrow];
//    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.centerY.equalTo(self.minerFeeTF.mas_centerY);
//        make.width.equalTo(@6.5);
//
//    }];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
//    [rightArrow addGestureRecognizer:tapGesture];
//    rightArrow.userInteractionEnabled = YES;
//
//    UILabel *lable = [[UILabel alloc] init];
//    [self.view addSubview:lable];
//    lable.textColor = kTextColor;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
//    [lable addGestureRecognizer:tap];
//    lable.userInteractionEnabled = YES;
//    self.choseLab = lable;
//    lable.font = [UIFont systemFontOfSize:12];
//    lable.text = [LangSwitcher switchLang:@"更多" key:nil];
//    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(rightArrow.mas_left).offset(-5);
//        make.centerY.equalTo(rightArrow.mas_centerY);
//        make.height.equalTo(@(heightMargin));
//
//    }];
//    //提示
//    UIView *minerView = [[UIView alloc] init];
//
//    minerView.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];
//
//    [self.view addSubview:minerView];
//    [minerView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@0);
//        make.top.equalTo(self.minerFeeTF.mas_bottom);
//
//    }];
//
//    self.minerView = minerView;
//
//    UILabel *minerPromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:11.0];
//
//    minerPromptLbl.text = [LangSwitcher switchLang:@"矿工费将在可用余额中扣除,余额不足将从转账金额中扣除" key:nil];
//
//    minerPromptLbl.numberOfLines = 0;
//
//    [minerView addSubview:minerPromptLbl];
//    [minerPromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 32, 10, 15));
//
//        make.left.equalTo(self.view.mas_left).offset(32);
//        make.centerY.equalTo(minerView.mas_centerY);
//        make.width.equalTo(@(kScreenWidth - 32 - 15));
//
//    }];
//    //分割线
//    UIView *minerLine = [[UIView alloc] init];
//
//    minerLine.backgroundColor = kLineColor;
//
//    [minerView addSubview:minerLine];
//    [minerLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.top.right.equalTo(@0);
//        make.height.equalTo(@0.5);
//
//    }];
//
    //注意
//    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"注意")];
//
//    [minerView addSubview:iconIV];
//    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.centerY.equalTo(minerPromptLbl.mas_centerY);
//
//    }];
    
    //内部转账
    //    UIView *interalTranView = [[UIView alloc] init];
    //
    //    interalTranView.backgroundColor = kWhiteColor;
    //
    //    [self.view addSubview:interalTranView];
    //    [interalTranView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.right.equalTo(@(0));
    //        make.top.equalTo(minerView.mas_bottom).offset(10);
    //        make.height.equalTo(@50);
    //
    //    }];
    //    //
    //    UILabel *tranTextLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    //
    //    tranTextLbl.text = @"内部转账";
    //
    //    [interalTranView addSubview:tranTextLbl];
    //    [tranTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.equalTo(@15);
    //        make.centerY.equalTo(interalTranView.mas_centerY);
    //
    //    }];
    //
    //    //开关
    //    UISwitch *sw = [[UISwitch alloc] init];
    //
    //    sw.on = NO;
    //
    //    [interalTranView addSubview:sw];
    //    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.right.equalTo(@(-15));
    //        make.centerY.equalTo(@0);
    //
    //    }];
    //
    //    self.sw = sw;
    //
    //    //内部转账提示
    //    UIView *tranPromptView = [[UIView alloc] init];
    //
    //    tranPromptView.backgroundColor = [UIColor colorWithHexString:@"#fdfdfd"];
    //
    //    [self.view addSubview:tranPromptView];
    //    [tranPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.right.equalTo(@0);
    //        make.top.equalTo(interalTranView.mas_bottom).offset(0);
    //
    //    }];
    //
    //    UILabel *tranPromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:11.0];
    //
    //    tranPromptLbl.text = @"同意提币至bitbank进行托管, 0手续费0确认, 不走区块链接极速到账, bitbank.com";
    //
    //    tranPromptLbl.numberOfLines = 0;
    //
    //    [tranPromptView addSubview:tranPromptLbl];
    //    [tranPromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 10, 15));
    //
    //        make.left.equalTo(tranPromptView.mas_left).offset(15);
    //        make.centerY.equalTo(tranPromptView.mas_centerY);
    //        make.right.equalTo(tranPromptView.mas_right).offset(-15);
    //
    //    }];
    //
    //    UIView *tranLine = [[UIView alloc] init];
    //
    //    tranLine.backgroundColor = kLineColor;
    //
    //    [tranPromptView addSubview:tranLine];
    //    [tranLine mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.left.top.right.equalTo(@0);
    //        make.height.equalTo(@0.5);
    //
    //    }];
    
    //确认付币
    UIButton *confirmPayBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确认转账" key:nil]
                                             titleColor:kWhiteColor
                                        backgroundColor:kHexColor(@"#108ee9")
                                              titleFont:16.0
                                           cornerRadius:5];
    
    [confirmPayBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmPayBtn];
    [confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.top.equalTo(self.minerFeeTF.mas_bottom).offset(150);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        
    }];
    
    self.confirmBtn = confirmPayBtn;
}


- (void)valueChange:(id) sender
{
    
//    self.minerFeeTF.text = [NSString stringWithFormat:@"%.6f %@",self.gamPrice/2,self.currency.symbol];
//    self.choseLab.text =  [LangSwitcher switchLang:@"经济" key:nil];
    
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider * slider = sender;
        CGFloat value = slider.value;
        NSLog(@"%f", value);
        if (value == 0) {
            if ([self.currency.symbol isEqualToString:@"BTC"]) {
                self.blanceFree.text = [NSString stringWithFormat:@"%@ %@",self.priceSlow,self.currency.symbol];
                self.pricr = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]/2];
            }else{
                self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice/2,self.currency.symbol];
                self.pricr = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]/2];
            }
            
        }else{
            if ([self.currency.symbol isEqualToString:@"BTC"]) {
                self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*2,self.currency.symbol];
                
                self.pricr = [NSString stringWithFormat:@"%f",[self.pricr longLongValue]*value];
            }else{
                
                self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*value,self.currency.symbol];
                
                self.pricr = [NSString stringWithFormat:@"%f",[self.pricr longLongValue]*value];
            }
           
        }
         if (value == 1)
         {
          
             if ([self.currency.symbol isEqualToString:@"BTC"]) {
                 self.blanceFree.text = [NSString stringWithFormat:@"%@ %@",self.priceFast,self.currency.symbol];
                 
                 self.pricr = [NSString stringWithFormat:@"%f",[self.pricr longLongValue]*value*2];
             }else{
                 self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*2,self.currency.symbol];
                 
                 self.pricr = [NSString stringWithFormat:@"%f",[self.pricr longLongValue]*value*2];
             }
          
         }
        
        


    }
    
}

- (FilterView *)coinAddressPicker {
    
    if (!_coinAddressPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[
                             //                              [LangSwitcher switchLang:@"选择地址" key:nil],
                             [LangSwitcher switchLang:@"扫描二维码" key:nil],
                             [LangSwitcher switchLang:@"粘贴地址" key:nil]
                             ];
        
        _coinAddressPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _coinAddressPicker.title = [LangSwitcher switchLang:@"接收地址" key:nil];
        
        _coinAddressPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf pickerEventWithIndex:index];
        };
        
        _coinAddressPicker.tagNames = textArr;
        
    }
    
    return _coinAddressPicker;
}


- (FilterView *)WorkMoneyPicker {
    
    if (!_WorkMoneyPicker) {
        
        CoinWeakSelf;
        
        NSArray *textArr = @[
                             //                              [LangSwitcher switchLang:@"选择地址" key:nil],
                             [LangSwitcher switchLang:@"优先" key:nil],
                             [LangSwitcher switchLang:@"普通" key:nil],
                             [LangSwitcher switchLang:@"经济" key:nil]

                             ];
        
        _WorkMoneyPicker = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _WorkMoneyPicker.title = [LangSwitcher switchLang:@"请选择经济的手续费,可能会导致延长交易确认时间,对时间有要求的交易,请选择优先" key:nil];
        
        _WorkMoneyPicker.selectBlock = ^(NSInteger index) {
            
            [weakSelf WorkpickerEventWithIndex:index];
        };
        
        _WorkMoneyPicker.tagNames = textArr;
        
    }
    
    return _WorkMoneyPicker;
}

- (void)WorkpickerEventWithIndex: (NSInteger)index
{
    switch (index) {
        case 2:
            //优先
            self.minerFeeTF.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice/2,self.currency.symbol];
            self.choseLab.text =  [LangSwitcher switchLang:@"经济" key:nil];
            self.pricr = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]/2];
            self.slider.value = 0.5;
            break;
        case 1:
            //普通
            self.blanceFree.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice,self.currency.symbol];
//            self.choseLab.text =  [LangSwitcher switchLang:@"普通" key:nil];
            self.pricr = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]];

            break;
        case 0:
            //经济
            self.minerFeeTF.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*2,self.currency.symbol];
            self.choseLab.text =  [LangSwitcher switchLang:@"优先" key:nil];
            self.pricr = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]*2];

//            self.pricr = [NSString stringWithFormat:@"%f",[self.pricr floatValue]];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 查看提现订单
- (void)clickRecord:(UIButton *)sender {
    
    //    BillVC *billVC = [BillVC new];
    //    billVC.accountNumber = self.currency.accountNumber;
    //    billVC.billType = BillTypeWithdraw;
    //    [self.navigationController pushViewController:billVC animated:YES];
    
    //
    TLCoinWithdrawOrderVC *withdrawOrderVC = [[TLCoinWithdrawOrderVC alloc] init];
    withdrawOrderVC.coin = self.currency.currency;
    [self.navigationController pushViewController:withdrawOrderVC animated:YES];
    
}

-(void)click
{
    QRCodeVC *qrCodeVC = [QRCodeVC new];
    CoinWeakSelf;
    qrCodeVC.scanSuccess = ^(NSString *result) {
        
        weakSelf.balanceTF.text = result;
//        weakSelf.receiveAddressLbl.textColor = kTextColor;
        weakSelf.addressType = WalletAddressTypeScan;
        //                [weakSelf setGoogleAuth];
        
    };
    
    [self.navigationController pushViewController:qrCodeVC animated:YES];
    
}

- (void)clickConfirm:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if ([self.balanceTF.text isEqualToString:@"请输入接收地址地址或扫码"]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择地址地址" key:nil] ];
        return ;
    }
    
    CGFloat amount = [self.tranAmountTF.text doubleValue];
    
    if (amount <= 0 || ![self.tranAmountTF.text valid]) {
        
        [TLAlert alertWithInfo:@"转账金额需大于0"];
        return ;
    }
//   NSString *word =  [[NSUserDefaults standardUserDefaults] objectForKey:KWalletWord];
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *Mnemonics;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            Mnemonics = [set stringForColumn:@"Mnemonics"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    
    //
    CGFloat f =  [self.tranAmountTF.text floatValue];
    f = f *1000000000000000000;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"线程1--->%d",[NSThread isMainThread]);


        NSString *gaspic =  [CoinUtil convertToSysCoin:self.tranAmountTF.text coin:self.currency.symbol];
        //    NSNumber *gaspic = [NSNumber numberWithFloat:[self.tranAmountTF.text floatValue] *1000000000000000000] ;
        
        [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                            msg:@""
                     confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                      cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                    placeHolder:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                          maker:self cancle:^(UIAlertAction *action) {
                             
                              return ;
                          } confirm:^(UIAlertAction *action, UITextField *textField) {
                              [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                               [SVProgressHUD show];
                              dispatch_after(0.5, dispatch_get_main_queue(), ^{
                                  if ([self.word isEqualToString:textField.text]) {
                                      NSString *result;
                                      NSLog(@"线程2--->%d",[NSThread isMainThread]);
                                      //                                  [SVProgressHUD show];
                                      
                                      //
                                      if ([self.currency.symbol isEqualToString:@"ETH"]) {
                                          result =[MnemonicUtil sendTransactionWithMnemonicWallet:Mnemonics address:self.balanceTF.text amount:gaspic gaspic:self.pricr gasLimt:@"21000"];
                                          
                                      }else{
                                          
                                          result =[MnemonicUtil sendWanTransactionWithMnemonicWallet:Mnemonics address:self.balanceTF.text amount:gaspic gaspic:self.pricr gasLimt:@"21000"];
                                      }
                                      
                                      
                                      if ([result isEqualToString:@"1"]) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          [TLAlert alertWithSucces:[LangSwitcher switchLang:@"转账成功" key:nil]];
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                              [self.navigationController popViewControllerAnimated:YES];
                                          });
                                          
                                      }else
                                      {
                                          NSLog(@"线程3--->%d",[NSThread isMainThread]);
                                          
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                          [TLAlert alertWithError:[LangSwitcher switchLang:@"转账失败" key:nil]];
                                          
                                          
                                      }
                                  }else{
                                      [TLAlert alertWithError:[LangSwitcher switchLang:@"交易密码错误" key:nil]];
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      
                                  }
                              });
                              
                              //                          [self confirmWithdrawalsWithPwd:textField.text];
                              
                          }];
        
        
      
        
//    });
   
//    if ([TLUser user].isGoogleAuthOpen) {
//
//        if (!(self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
//
//            if (![self.googleAuthTF.text valid]) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
//                return;
//
//            }
//
//            //判断谷歌验证码是否为纯数字
//            if (![NSString isPureNumWithString:self.googleAuthTF.text]) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
//                return ;
//            }
//
//            //判断谷歌验证码是否为6位
//            if (self.googleAuthTF.text.length != 6) {
//
//                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入正确的谷歌验证码" key:nil]];
//                return ;
//            }
//
//        }
//    }
    
//    if (self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"]) {
//
//        [self confirmWithdrawalsWithPwd:nil];
//
//        return ;
//
//    }
    
//    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
//                        msg:@""
//                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
//                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
//                placeHolder:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
//                      maker:self cancle:^(UIAlertAction *action) {
//
//                      } confirm:^(UIAlertAction *action, UITextField *textField) {
//
//                          [self confirmWithdrawalsWithPwd:textField.text];
//
//                      }];
    
}

- (void)clickPaste {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.string != nil) {
        
        self.googleAuthTF.text = pasteboard.string;
        
    } else {
        
        [TLAlert alertWithInfo:@"粘贴内容为空"];
    }
}

//- (void)textDidChange:(UITextField *)sender {

//    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:self.tranAmountTF.text];
//
//    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:self.withdrawFee];
//
//    NSDecimalNumber *o = [m decimalNumberByMultiplyingBy:n];
//
//    self.minerFeeTF.text = [NSString stringWithFormat:@"%@ %@", [o stringValue], self.currency.currency];
//}

- (void)selectCoinAddress {
    
    [self.coinAddressPicker show];
}

- (void)clickImage
{
    [self.WorkMoneyPicker show];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)pickerEventWithIndex:(NSInteger)index {
    
    CoinWeakSelf;
    
    switch (index) {
            //选择地址
            //        case 0:
            //        {
            //            [self.coinAddressPicker hide];
            //
            //            CoinAddressListVC *addressVC = [CoinAddressListVC new];
            //            addressVC.coin = self.currency.currency;
            //            addressVC.addressBlock = ^(CoinAddressModel *addressModel) {
            //
            //                weakSelf.addressModel = addressModel;
            //
            //                weakSelf.receiveAddressLbl.text = weakSelf.addressModel.address;
            //
            //                weakSelf.receiveAddressLbl.textColor = kTextColor;
            //
            //                weakSelf.addressType = AddressTypeSelectAddress;
            //
            //                [weakSelf setGoogleAuth];
            //            };
            //
            //            [self.navigationController pushViewController:addressVC animated:YES];
            //
            //        }break;
            //扫描二维码
        case 0:
        {
            QRCodeVC *qrCodeVC = [QRCodeVC new];
            
            qrCodeVC.scanSuccess = ^(NSString *result) {
                
                weakSelf.receiveAddressLbl.text = result;
                weakSelf.receiveAddressLbl.textColor = kTextColor;
                weakSelf.addressType = WalletAddressTypeScan;
//                [weakSelf setGoogleAuth];
                
            };
            
            [self.navigationController pushViewController:qrCodeVC animated:YES];
            
        }break;
            //粘贴地址
        case 1:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            if (pasteboard.string != nil) {
                
                self.receiveAddressLbl.text = pasteboard.string;
                
                self.receiveAddressLbl.textColor = kTextColor;
                
                self.addressType = WalletAddressTypeCopy;
                
                [weakSelf setGoogleAuth];
                
            } else {
                
                [TLAlert alertWithInfo:@"粘贴内容为空"];
            }
            
        }break;
            
        default:
            break;
    }
}




- (void)setGoogleAuth {
    
    if (![TLUser user].isGoogleAuthOpen) {
        
        return ;
    }
    
    if ((self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:kAddressCertified])) {
        
        [UIView animateWithDuration:0 animations:^{
            
            self.googleAuthTF.transform = CGAffineTransformIdentity;
            self.minerFeeTF.transform = CGAffineTransformIdentity;
            self.minerView.transform = CGAffineTransformIdentity;
            self.confirmBtn.transform = CGAffineTransformIdentity;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:0 animations:^{
            
            self.googleAuthTF.transform = CGAffineTransformMakeTranslation(0, 50);
            self.minerFeeTF.transform = CGAffineTransformMakeTranslation(0, 50);
            self.minerView.transform = CGAffineTransformMakeTranslation(0, 50);
            self.confirmBtn.transform = CGAffineTransformMakeTranslation(0, 50);
            
        }];
    }
}

#pragma mark - Data
- (void)confirmWithdrawalsWithPwd:(NSString *)pwd {
    
    if (!(self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
        
        if (![pwd valid]) {
            
            [TLAlert alertWithInfo:@"请输入资金密码"];
            return ;
        }
    }
    
    if (self.sw.on) {
        
        [self doTransfer:pwd];
        
    } else {
        
        [self doWithdraw:pwd];
        
    }
    
    
    
}

- (void)doWithdraw:(NSString *)pwd {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"802750";
    http.showView = self.view;
    http.parameters[@"accountNumber"] = self.currency.accountNumber;
    http.parameters[@"amount"] = [CoinUtil convertToSysCoin:self.tranAmountTF.text
                                                       coin:self.currency.currency];
    http.parameters[@"applyNote"] = [NSString stringWithFormat:@"%@提现", self.currency.currency];
    //    http.parameters[@"applyNote"] = @"ios-提现";
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"payCardInfo"] = self.currency.currency;
    http.parameters[@"payCardNo"] = self.receiveAddressLbl.text;
    http.parameters[@"token"] = [TLUser user].token;
    //    http.parameters[@"fee"] = @"-0.1";
    //    http.parameters[@"fee"] = @"-10";
    
    
    if ([TLUser user].isGoogleAuthOpen) {
        
        if (!(self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
            
            http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
            
        }
    }
    
    if (!(self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
        
        http.parameters[@"tradePwd"] = pwd;
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"提币申请提交成功" key:nil]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWithDrawCoinSuccess object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)doTransfer:(NSString *)pwd {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"802004";
    http.showView = self.view;
    http.parameters[@"fromUserId"] = [TLUser user].userId;
    http.parameters[@"fromAddress"] = self.currency.coinAddress;
    http.parameters[@"toAddress"] = self.receiveAddressLbl.text;
    http.parameters[@"transAmount"] = [CoinUtil convertToSysCoin:self.tranAmountTF.text
                                                            coin:self.currency.currency];
    http.parameters[@"currency"] = self.currency.currency;
    http.parameters[@"token"] = [TLUser user].token;
    //    http.parameters[@"fee"] = @"-0.1";
    //    http.parameters[@"fee"] = @"-10";
    
    
    if ([TLUser user].isGoogleAuthOpen) {
        
        if (!(self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
            
            http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
            
        }
    }
    
    if (!(self.addressType == WalletAddressTypeSelectAddress && [self.addressModel.status isEqualToString:@"1"])) {
        
        http.parameters[@"tradePwd"] = pwd;
        
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"内部转账成功" key:nil]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWithDrawCoinSuccess object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark- 获取手续费
- (void)setWithdrawFee {
    
    CoinModel *currentCoin = [CoinUtil getCoinModel:self.currency.currency];
    
    self.withdrawFee = currentCoin.withdrawFeeString;
    
    self.blanceFree.text = [NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:self.withdrawFee coin:self.currency.currency], self.currency.currency];
    
}




@end
