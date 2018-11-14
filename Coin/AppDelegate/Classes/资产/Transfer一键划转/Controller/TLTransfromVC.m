//
//  TLTransfromVC.m
//  Coin
//
//  Created by shaojianfei on 2018/7/5.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLTransfromVC.h"
#import "CustomLayoutWallet.h"
#import "THTranstionCollectionView.h"
#import "TLPwdRelatedVC.h"
#import "MnemonicUtil.h"
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

#import "keyTransferTableView.h"
#import "BTCPoundage.h"
#import "UsdtClient.h"

typedef enum : NSUInteger {
    BTCAPIChain,
    BTCAPIBlockchain,
} BTCAPI;
@interface TLTransfromVC ()<THTranstionCollectionViewDelegate,UITableViewDelegate,RefreshDelegate>
{
    BOOL isHaveDian;
    NSString *symbolblance;
    
//选中按钮tag
    NSInteger SelectTheButtonTag;
}

@property (nonatomic , strong)keyTransferTableView *tableView;
@property (nonatomic , strong)UITextField *numberTextField;
@property (nonatomic , strong)UITextField *googleTextField;
@property (nonatomic , strong)UISlider *poundageSlider;

@property (nonatomic ,strong) THTranstionCollectionView *nineView;
@property (nonatomic ,strong) UIView *whiteView;


@property (nonatomic ,copy)  NSString * word;

@property (nonatomic ,strong)  CurrencyModel *currentModel;
@property (nonatomic, strong) UILabel *symbolBlance;
@property (nonatomic, assign) CGFloat gamPrice;
@property (nonatomic, copy) NSString *tempPrice;

@property (nonatomic, copy) NSString *pricr;
@property (nonatomic, copy) NSString *btcAddress;

@property (nonatomic, copy) NSString *btcPrivate;
@property (nonatomic, strong) NSMutableArray <utxoModel *>*utxis;

@property (nonatomic, assign) NSInteger btcPrice;
@property (nonatomic, strong) UILabel *totalFree;
@property (nonatomic, strong) BTCKey *key;

@property (nonatomic, assign) NSInteger currentIndex;

//btc提示文字
@property (nonatomic, copy)NSString *btcPrompt;

@property (nonatomic , copy)NSString *poundage;
@property (nonatomic , copy)NSString *currencyStr;

@end

@implementation TLTransfromVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = kBackgroundColor;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0  blue:242/255.0  alpha:1.0];

    //    [LangSwitcher currentLang];
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(kScreenWidth/2-60, 0, 120, 50)];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=kTextColor;
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:[LangSwitcher switchLang:@"一键划转" key:nil]];
    self.navigationItem.titleView=titleText;
    [self.view addSubview:self.tableView];

    self.numberTextField = [self.view viewWithTag:1000];
    self.googleTextField = [self.view viewWithTag:1001];
    self.poundageSlider = [self.view viewWithTag:1002];
    self.totalFree = [self.view viewWithTag:1212];
    
    if (self.isLocal == YES) {
        self.currentModel = self.localcurrencys[0];
        [self loadtype];
        [self loadGas];
    }else
    {
        self.currentModel = self.currencys[0];
    }
    _tableView.models = _currencys;
    _tableView.model = self.currentModel;
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kHexColor(@"#0848DF");
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}


-(keyTransferTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[keyTransferTableView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.refreshDelegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.isLocal = self.isLocal;
        
    }
    return _tableView;
}

-(void)refreshTableView:(TLTableView *)refreshTableview Slider:(UISlider *)slider
{
    if (self.isLocal == NO) {
        return;
    }
    NSLog(@"%f",slider.value);
    [self valueChange:slider];
}

-(void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index
{
    self.numberTextField = [self.view viewWithTag:1000];
    self.googleTextField = [self.view viewWithTag:1001];
    self.poundageSlider = [self.view viewWithTag:1002];
    self.totalFree = [self.view viewWithTag:1212];
    UILabel *leftAmountLabel = [self.view viewWithTag:1122];
    //    转换
    
    if (self.isLocal == NO) {
        if (index < 100) {
            
            self.tableView.model = _currencys[index];
            self.currentModel = _currencys[index];
            SelectTheButtonTag = index;
            self.numberTextField.text = @"";
            CoinModel *currentCoin = [CoinUtil getCoinModel:self.tableView.model.currency];
            
            self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.tableView.model.currency], self.tableView.model.currency]];

            NSString *leftAmount = [self.tableView.model.amountString subNumber:self.tableView.model.frozenAmountString];
            NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:self.tableView.model.currency];
            leftAmountLabel.text = [NSString stringWithFormat:@"%@:  %@ %@",[LangSwitcher switchLang:@"可用余额" key:nil],money,self.tableView.model.currency];
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        if (index == 100) {
            
            self.isLocal = !self.isLocal;
            self.tableView.isLocal = self.isLocal;
            
            self.tableView.model = self.localcurrencys[SelectTheButtonTag];
            self.numberTextField.text = @"";
            self.currentModel = self.localcurrencys[SelectTheButtonTag];
            [self loadtype];
            [self loadGas];
            self.totalFree = [UILabel new];
            [self.tableView reloadData];
        }
        //    全部
        if (index == 101) {
            NSString *leftAmount = [self.tableView.model.amountString subNumber:self.tableView.model.frozenAmountString];
            CoinModel *currentCoin = [CoinUtil getCoinModel:self.tableView.model.currency];

            if ([[CoinUtil convertToRealCoin:leftAmount coin:self.tableView.model.currency] floatValue] > [[CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.tableView.model.currency] floatValue]) {
//                NSString *money =  floatValue];
                self.numberTextField.text = [CoinUtil convertToRealCoin:leftAmount coin:self.tableView.model.currency];
            }else
            {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"余额不足" key:nil]];
            }

            
        }
        //    划转
        if (index == 102) {
            //中心化划转
            if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
                
                TLPwdType pwdType = TLPwdTypeSetTrade;
                TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
                pwdRelatedVC.isWallet = YES;
                [self.navigationController pushViewController:pwdRelatedVC animated:YES];
                return ;
            }
            if ([self.numberTextField.text isBlank]) {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入数量" key:nil]];
                return;
            }
            if ([TLUser user].isGoogleAuthOpen) {
                if ([self.googleTextField.text isEqualToString:@""]) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
                    return;
                }
            }
            [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                                msg:@""
                         confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                          cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                        placeHolder:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                              maker:self cancle:^(UIAlertAction *action)
            {
            } confirm:^(UIAlertAction *action, UITextField *textField) {
                [self  requestTransform:textField.text];
            }];
            
        }
    }else
    {
        if (index < 100) {
            [TLProgressHUD show];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeFlat)];
            
            self.tableView.model = self.localcurrencys[index];
            self.numberTextField.text = @"";
            self.currentModel = self.localcurrencys[index];
            [self loadtype];
            [self loadGas];
            [self.tableView reloadData];
            SelectTheButtonTag = index;
        }
        if (index == 100) {
            
            self.isLocal = !self.isLocal;
            self.tableView.isLocal = self.isLocal;
            self.tableView.model = _currencys[SelectTheButtonTag];
            self.currentModel = _currencys[SelectTheButtonTag];
//            [self.tableView reloadData];
            
            CoinModel *currentCoin = [CoinUtil getCoinModel:self.tableView.model.currency];
            self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.tableView.model.currency], self.tableView.model.currency]];
            NSString *leftAmount = [self.tableView.model.amountString subNumber:self.tableView.model.frozenAmountString];
            NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:self.tableView.model.currency];
            leftAmountLabel.text = [NSString stringWithFormat:@"%@:  %@ %@",[LangSwitcher switchLang:@"可用余额" key:nil],money,self.tableView.model.currency];
            self.numberTextField.text = @"";
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        //    全部
        if (index == 101) {
            
            [self AllThePrivateKey];
            
            
        }
        //    划转
        if (index == 102) {
//            if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
//
//                TLPwdType pwdType = TLPwdTypeSetTrade;
//                TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
//                pwdRelatedVC.isWallet = YES;
//                [self.navigationController pushViewController:pwdRelatedVC animated:YES];
//                return ;
//            }
            if ([self.numberTextField.text isBlank]) {
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入数量" key:nil]];
                return;
            }
            if ([TLUser user].isGoogleAuthOpen) {
                if ([self.googleTextField.text isEqualToString:@""]) {
                    [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
                    return;
                }
            }
            
            TLDataBase *dataBase = [TLDataBase sharedManager];
            NSString *address;
            if ([dataBase.dataBase open]) {
                NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@' and th.symbol = '%@' and lo.IsSelect = 1",[TLUser user].userId,self.currentModel.symbol];
                //        [sql appendString:[TLUser user].userId];
                FMResultSet *set = [dataBase.dataBase executeQuery:sql];
                while ([set next])
                {
                    
                    address = [set stringForColumn:@"address"];
                    
                    self.currentModel.address = address;
                }
                [set close];
            }
            [dataBase.dataBase close];
            [self loadtype];
            [self loadPwd];

            [self sendExcange];

        }
    }
}


#pragma mark -- 私钥点击全部
-(void)AllThePrivateKey
{
//    转账币种总金额
    NSString *allMoney = [CoinUtil convertToRealCoin:self.tableView.model.balance coin:self.tableView.model.symbol];
//    手续费币种总金额
    NSString *feeAllMoney;
    NSString *symbol = self.tableView.model.symbol;
    
    
    if ([symbol isEqualToString:@"WAN"] || [symbol isEqualToString:@"ETH"] || [symbol isEqualToString:@"BTC"])
    {
        if ([allMoney floatValue] > [self.poundage floatValue]) {
            NSString *money = [NSString stringWithFormat:@"%.8f",[allMoney floatValue] - [self.poundage floatValue]];
//            NSString *str = [CoinUtil mult1:money mult2:@"1" scale:8];
            self.numberTextField.text = money;
        }else
        {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"余额不足" key:nil]];
        }
    }
    
    else if ([symbol isEqualToString:@"USDT"]) {
        for (int i = 0; i < self.localcurrencys.count; i ++) {
            if ([self.localcurrencys[i].symbol isEqualToString:@"BTC"]) {
                feeAllMoney = [CoinUtil convertToRealCoin:self.localcurrencys[i].balance coin:@"BTC"];
            }
            
        }
        if ([feeAllMoney floatValue] > [self.poundage floatValue]) {
            NSString *money = [NSString stringWithFormat:@"%.8f",[allMoney floatValue]];
            self.numberTextField.text = money;
        }else
        {
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"BTC%@",[LangSwitcher switchLang:@"余额不足" key:nil]]];
        }
    }
    
    
    else if ([self.currentModel.type isEqualToString:@"0"])
    {
        if ([allMoney floatValue] > [self.poundage floatValue]) {
            NSString *money = [NSString stringWithFormat:@"%.8f",[allMoney floatValue] - [self.poundage floatValue]];
//                        NSString *str = [CoinUtil mult1:money mult2:@"1" scale:8];
            self.numberTextField.text = money;
        }else
        {
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"%@%@",self.currencyStr,[LangSwitcher switchLang:@"余额不足" key:nil]]];
        }
    }else if ([self.currentModel.type isEqualToString:@"1"])
    {
        for (int i = 0; i < self.localcurrencys.count; i ++) {
            if ([self.localcurrencys[i].symbol isEqualToString:@"ETH"]) {
                feeAllMoney = [CoinUtil convertToRealCoin:self.localcurrencys[i].balance coin:@"ETH"];
            }
        }
        if ([feeAllMoney floatValue] >[self.poundage floatValue]) {
            NSString *money = [NSString stringWithFormat:@"%.8f",[allMoney floatValue]];
            self.numberTextField.text = money;
        }else
        {
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"ETH%@",[LangSwitcher switchLang:@"余额不足" key:nil]]];
        }
//        self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", self.poundage ,@"ETH"]];
//        self.currencyStr = @"ETH";
    }else{
        
        for (int i = 0; i < self.localcurrencys.count; i ++) {
            if ([self.localcurrencys[i].symbol isEqualToString:@"WAN"]) {
                feeAllMoney = [CoinUtil convertToRealCoin:self.localcurrencys[i].balance coin:@"WAN"];
            }
        }
        if ([feeAllMoney floatValue] > [self.poundage floatValue]) {
            NSString *money = [NSString stringWithFormat:@"%.8f",[allMoney floatValue]];
            self.numberTextField.text = money;
        }else
        {
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"WAN%@",[LangSwitcher switchLang:@"余额不足" key:nil]]];
        }
//        self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", self.poundage,@"WAN" ]];
//        self.currencyStr = @"WAN";
    }
    
    
    
}


#pragma mark -- 个人钱包划转
- (void)requestTransform:(NSString *)pwd
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"802750";
    http.showView = self.view;
    http.parameters[@"accountNumber"] = self.currentModel.accountNumber;
    http.parameters[@"amount"] = [CoinUtil convertToSysCoin:self.numberTextField.text
                                                       coin:self.currentModel.currency];
    http.parameters[@"applyNote"] = [NSString stringWithFormat:@"%@提现", self.currentModel.currency];
    http.parameters[@"applyUser"] = [TLUser user].userId;
    http.parameters[@"payCardInfo"] = self.currentModel.currency;
    NSString *add;
    for (int i = 0; i < self.localcurrencys.count; i++) {
        if ([self.currentModel.currency isEqualToString:self.localcurrencys[i].symbol]) {
            add = self.localcurrencys[i].address;
        }
    }
    http.parameters[@"payCardNo"] = add;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"tradePwd"] = pwd;
    if ([TLUser user].isGoogleAuthOpen) {
        http.parameters[@"googleCaptcha"] = self.googleTextField.text;
    }
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"划转成功" key:nil]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWithDrawCoinSuccess object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 私钥划转
- (void)sendExcange
{
    if ([self.currentModel.symbol isEqualToString:@"BTC"] || [self.currentModel.symbol isEqualToString:@"USDT"]) {
        NSString *intputMoney = [CoinUtil convertToSysCoin:self.numberTextField.text coin:self.currentModel.symbol];

        NSString *g1 = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]*21000];
        NSString *text1 = [intputMoney subNumber:g1];
        if (text1.floatValue  > self.currentModel.balance.floatValue) {
            [TLAlert alertWithError:[LangSwitcher switchLang:@"可用余额不足" key:nil]];
            return;
        }
    }else{
        NSString *allMoney = [CoinUtil convertToRealCoin:self.currentModel.balance coin:self.tableView.model.symbol];
        if ([self.numberTextField.text floatValue]  > [allMoney floatValue]) {
            
            [TLAlert alertWithError:[LangSwitcher switchLang:@"可用余额不足" key:nil]];
            return;
        }
        
    }
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *Mnemonics;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            Mnemonics = [set stringForColumn:@"Mnemonics"];
        }
        [set close];
    }
    NSString *gaspic =  [CoinUtil convertToSysCoin:self.numberTextField.text coin:self.currentModel.symbol];
    ;
    [dataBase.dataBase close];
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                        msg:@""
                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                placeHolder:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                      maker:self cancle:^(UIAlertAction *action) {
                          
                          
                      } confirm:^(UIAlertAction *action, UITextField *textField)
    {
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            if ([self.word isEqualToString:textField.text])
            {
                [SVProgressHUD show];
//                [TLProgressHUD show];
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSString *result;
                NSLog(@"线程2--->%d",[NSThread isMainThread]);
                NSString *add;
                for (int i = 0; i < self.localcurrencys.count; i++) {
                    if ([self.currentModel.symbol isEqualToString:self.centercurrencys[i].currency]) {
                        add = self.centercurrencys[i].coinAddress;
                    }
                }
                
                if ([self.currentModel.type isEqualToString:@"0"]) {
                    //公链 ETH WAN BTC
                    if ([self.currentModel.symbol isEqualToString:@"ETH"]) {
                        [TLProgressHUD show];
                        result =[MnemonicUtil sendTransactionWithMnemonicWallet:Mnemonics address:add amount:gaspic gaspic:[NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]] gasLimt:@"21000"];
                        
                        
                    }else if ([self.currentModel.symbol isEqualToString:@"WAN"]){
                        [TLProgressHUD show];
                        result =[MnemonicUtil sendWanTransactionWithMnemonicWallet:Mnemonics address:add amount:gaspic gaspic:[NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]] gasLimt:@"21000"];
                    }else if([self.currentModel.symbol isEqualToString:@"BTC"])
                    {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if ([add isEqualToString:self.btcAddress]) {
                            [TLAlert alertWithMsg:@"转入和转出地址不能相同"];
                            return ;
                        }
                        [self testSpendCoins:add :self.numberTextField.text :[NSString stringWithFormat:@"%ld",(long)self.btcPrice]];
                        return ;
                    }else if([self.currentModel.symbol isEqualToString:@"USDT"]){
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if ([add isEqualToString:self.btcAddress]) {
                            [TLAlert alertWithMsg:@"转入和转出地址不能相同"];
                            return ;
                        }
                        [self utxoTransfer];
                        return ;
                    }
                }else{
                    [TLProgressHUD show];
                    CoinModel *coin = [CoinUtil getCoinModel:self.currentModel.symbol];
                    result = [MnemonicUtil sendEthTokenTransactionWithAddress:Mnemonics contractAddress:coin.contractAddress address:add amount:self.numberTextField.text gaspic:[NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]] gasLimt:@"210000"];
                    
                }
                if ([result isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TLAlert alertWithSucces:[LangSwitcher switchLang:@"划转成功" key:nil]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else
                {
                    NSLog(@"线程3--->%d",[NSThread isMainThread]);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [TLAlert alertWithError:[LangSwitcher switchLang:@"划转失败" key:nil]];
                }
            }else
            {
                [TLAlert alertWithError:[LangSwitcher switchLang:@"交易密码错误" key:nil]];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
//        });
        
    }];
}






#pragma mark -- 私钥手续费
- (void)loadGas
{
    if (self.isLocal == NO)
    {
        return;
    }
//    self.numberTextField = [self.view viewWithTag:1000];
//    self.googleTextField = [self.view viewWithTag:1001];
//    self.poundageSlider = [self.view viewWithTag:1002];
//    self.totalFree = [self.view viewWithTag:1212];
    self.totalFree.text = @"";
    [self.numberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    self.numberTextField
    __block  NSString *pricr;
    
    if ([self.currentModel.type isEqualToString:@"0"]) {
        
        if ([self.currentModel.symbol isEqualToString:@"BTC"] || [self.currentModel.symbol isEqualToString:@"USDT"]) {
           
            
            //获取BTCUTXO
            [self loadUtxoList];
            
            
            
        }else if ([self.currentModel.symbol isEqualToString:@"WAN"]) {

            
            TLNetworking *net =[TLNetworking new];
            net.code = @"802358";
            net.showView = self.view;
            [net postWithSuccess:^(id responseObject) {
                pricr   = responseObject[@"data"][@"gasPrice"];
                self.pricr = pricr;
                self.tempPrice = pricr;
                
                CGFloat p = [pricr doubleValue]/1000000000000000000;
                p = p *21000;
                NSLog(@"%.8f",p);
                self.gamPrice = p;
                self.poundageSlider.maximumValue = 1;
                self.poundageSlider.minimumValue = 0;
                self.poundageSlider.value = 0.5;
                [self valueChange:self.poundageSlider];

                
            } failure:^(NSError *error) {
                
            }];
            
        }else
        {
            TLNetworking *net =[TLNetworking new];
            net.code = @"802117";
            net.showView = self.view;
            [net postWithSuccess:^(id responseObject) {
                pricr  = responseObject[@"data"][@"gasPrice"];
                
                self.pricr = pricr;
                self.tempPrice = pricr;
                
                CGFloat p = [pricr doubleValue]/1000000000000000000;
                p = p *21000;
                NSLog(@"%.8f",p);
                self.gamPrice = p;
                self.poundageSlider.maximumValue = 1;
                self.poundageSlider.minimumValue = 0;
                self.poundageSlider.value = 0.5;
                [self valueChange:self.poundageSlider];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    }else{
        
        TLNetworking *net =[TLNetworking new];
        net.code = @"802117";
        net.showView = self.view;
        [net postWithSuccess:^(id responseObject) {
            pricr   = responseObject[@"data"][@"gasPrice"];
            self.tempPrice = pricr;
            
            self.pricr = pricr;
            CGFloat p = [pricr doubleValue]/1000000000000000000;
            p = p *21000;
            NSLog(@"%.8f",p);
            self.gamPrice = p;
            self.poundageSlider.maximumValue = 1;
            self.poundageSlider.minimumValue = 0;
            self.poundageSlider.value = 0.5;
            [self valueChange:self.poundageSlider];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (self.isLocal == NO)
    {
        return;
    }
    
//    self.numberTextField = [self.view viewWithTag:1000];
//    self.googleTextField = [self.view viewWithTag:1001];
//    self.poundageSlider = [self.view viewWithTag:1002];
//    self.totalFree = [self.view viewWithTag:1212];
    if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
        
        self.poundage = [NSString stringWithFormat:@"%.8f",[BTCPoundage enterTheumber:self.numberTextField.text setFee:[NSString stringWithFormat:@"%.1f",self.poundageSlider.value] setUtxis:self.utxis]/100000000];
        self.totalFree.text = [NSString stringWithFormat:@"%@ %.8fBTC",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[self.poundage floatValue]];
    }
    if ([self.currentModel.symbol isEqualToString:@"USDT"]) {
        self.poundage = [NSString stringWithFormat:@"%.8f",[BTCPoundage usdtPoundage:self.numberTextField.text setFee:[NSString stringWithFormat:@"%.1f",self.poundageSlider.value] setUtxis:self.utxis]/100000000];
        self.totalFree.text = [NSString stringWithFormat:@"%@ %.8fBTC",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[self.poundage floatValue]];
    }
    
}


- (void)valueChange:(id) sender
{
    if (self.isLocal == NO)
    {
        return;
    }
    self.numberTextField = [self.view viewWithTag:1000];
    self.googleTextField = [self.view viewWithTag:1001];
    self.poundageSlider = [self.view viewWithTag:1002];
    self.totalFree = [self.view viewWithTag:1212];
    self.totalFree.text = @"";
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider *slider = sender;
        CGFloat value = slider.value;
        NSLog(@"%f", value);
        
        if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
            self.poundage = [NSString stringWithFormat:@"%.8f",[BTCPoundage enterTheumber:self.numberTextField.text setFee:[NSString stringWithFormat:@"%.1f",slider.value] setUtxis:self.utxis]/100000000];
            self.totalFree.text = [NSString stringWithFormat:@"%@ %.8fBTC",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[self.poundage floatValue]];
            self.btcPrice = slider.value;
            
            return;
        }
        if ([self.currentModel.symbol isEqualToString:@"USDT"]) {
            self.poundage = [NSString stringWithFormat:@"%.8f",[BTCPoundage usdtPoundage:self.numberTextField.text setFee:[NSString stringWithFormat:@"%.1f",slider.value] setUtxis:self.utxis]/100000000];
            self.totalFree.text = [NSString stringWithFormat:@"%@ %.8fBTC",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[self.poundage floatValue]];
            return;
        }
        
        if (value == 0) {
            
            self.poundage = [NSString stringWithFormat:@"%.8f",self.gamPrice*0.85];
            if ([self.currentModel.type isEqualToString:@"0"]) {
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",[self.poundage floatValue],self.currentModel.symbol]];
//                self.poundage = self.gamPrice*0.85;
                self.currencyStr = self.currentModel.symbol;
                
            }else if ([self.currentModel.type isEqualToString:@"1"])
            {
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",[self.poundage floatValue],@"ETH"]];
//                self.poundage = self.gamPrice*0.85;
                self.currencyStr = @"ETH";
                
            }else{
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",[self.poundage floatValue],@"WAN"]];
                
                self.currencyStr = @"WAN";
                
            }
            
            self.pricr = [NSString stringWithFormat:@"%f",[self.tempPrice longLongValue]*0.85];
            //            }
            
        }else{
            
            self.poundage = [NSString stringWithFormat:@"%.8f",self.gamPrice *0.85 +self.gamPrice*value*1/3];
            if ([self.currentModel.type isEqualToString:@"0"])
            {
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", [self.poundage floatValue] ,self.currentModel.symbol]];
                self.currencyStr = self.currentModel.symbol;
                
            }else if ([self.currentModel.type isEqualToString:@"1"])
            {
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", [self.poundage floatValue] ,@"ETH"]];
                self.currencyStr = @"ETH";
            }else{
                
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", [self.poundage floatValue],@"WAN" ]];
                self.currencyStr = @"WAN";
            }
            self.pricr = [NSString stringWithFormat:@"%f",[self.tempPrice longLongValue] + [self.tempPrice longLongValue] *value *1/3];
        }
        if (value == 1)
        {
            self.poundage = [NSString stringWithFormat:@"%.8f",self.gamPrice*value*1.15];
            if ([self.currentModel.type isEqualToString:@"0"]) {
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",[self.poundage floatValue],self.currentModel.symbol]];
                self.currencyStr = self.currentModel.symbol;
                
            }else if ([self.currentModel.type isEqualToString:@"1"])
            {
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",[self.poundage floatValue],@"ETH"]];
                self.currencyStr = @"ETH";
            }else{
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",[self.poundage floatValue],@"WAN"]];
                self.currencyStr = @"WAN";
            }
            self.pricr = [NSString stringWithFormat:@"%f",[self.tempPrice longLongValue]*value*1.15];
        }
    }
    else
    {
        self.tableView.model = self.localcurrencys[0];
        self.currentModel = self.localcurrencys[0];
        [self loadtype];
        [self loadGas];
        [self.tableView reloadData];
    }
}

-(void)loadtype
{
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *type;
    
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT type from THALocal where symbol = '%@'",self.currentModel.symbol];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            type = [set stringForColumn:@"type"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    self.currentModel.type = type;
}


#pragma mark -- BTC手续费
- (void)loadUtxoList
{
    if (self.isLocal == NO) {
        return;
    }
    self.totalFree = [self.view viewWithTag:1212];
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
        [self.tableView reloadData];
        NSString *blance = responseObject[@"data"][@"balance"];
        NSString *text =  [CoinUtil convertToRealCoin:blance coin:@"BTC"];
        self.symbolBlance.text = [NSString stringWithFormat:@"%.8f %@",[text floatValue],self.currentModel.symbol];
        symbolblance = text;
        NSLog(@"%@",responseObject);
        
        self.utxis = [utxoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"utxoList"]];
        
        TLNetworking *net = [TLNetworking new];
        net.showView = self.view;
        net.code = @"802223";
        [net postWithSuccess:^(id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSNumber *Min = responseObject[@"data"][@"fastestFeeMin"];
            NSNumber *Max = responseObject[@"data"][@"fastestFeeMax"];
            self.tableView.cell.slider.maximumValue = [Max floatValue];
            self.tableView.cell.slider.minimumValue = [Min floatValue];
            self.tableView.cell.slider.value = ([Max floatValue] + [Min floatValue])/2;
            
            if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
                self.tableView.poundage = [NSString stringWithFormat:@"%@ %.8fBTC",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[BTCPoundage enterTheumber:self.numberTextField.text setFee:[NSString stringWithFormat:@"%f",([Max floatValue] + [Min floatValue])/2] setUtxis:self.utxis]/100000000];
            }
            
            if ([self.currentModel.symbol isEqualToString:@"USDT"]) {
                self.tableView.poundage = [NSString stringWithFormat:@"%@ %.8fBTC",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[BTCPoundage usdtPoundage:self.numberTextField.text setFee:[NSString stringWithFormat:@"%.1f",([Max floatValue] + [Min floatValue])/2] setUtxis:self.utxis]/100000000];
            }
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadPwd
{
    TLDataBase *dataBase = [TLDataBase sharedManager];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT PwdKey from THAUser where userId = '%@'",[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            self.word = [set stringForColumn:@"PwdKey"];
        }
        [set close];
    }
    [dataBase.dataBase close];
}



#pragma mark -- btc转账
- (void) testSpendCoins:(NSString *)to : (NSString*)count :(NSString*)free {
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    NSArray *words = [word componentsSeparatedByString:@" "];
    BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
    BTCKeychain *keychain = [mnemonic keychain];
    if ([AppConfig config].runEnv == 0) {
        keychain = [keychain derivedKeychainWithPath:@"m/44'/0'/0'/0/0"];
        keychain.network = [BTCNetwork mainnet];
    }else{
        keychain = [keychain derivedKeychainWithPath:@"m/44'/1'/0'/0/0"];
        keychain.network = [BTCNetwork testnet];
    }
    BTCKey *key = keychain.key;
    self.key = key;
    NSData* privateKey = BTCDataFromHex(self.btcPrivate);
    NSLog(@"Private key: %@", privateKey);
    
    self.btcPrompt = @"";
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSError* error = nil;
    BTCTransaction* transaction;
    if ([AppConfig config].runEnv == 0) {
        transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                           to:[BTCPublicKeyAddress addressWithString:to]
                                                       change:key.address
                                                       amount:count
                                                          fee:free
                                                          api:0
                                                        error:&error];
    }else{
        transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                           to:[BTCPublicKeyAddressTestnet addressWithString:to]
                                                       change:key.addressTestnet
                                                       amount:count
                                                          fee:free
                                                          api:0
                                                        error:&error];
    }
    
    if (![self.btcPrompt isEqualToString:@""]) {
        [TLAlert alertWithInfo:self.btcPrompt];
        return;
    }

    [self validationSignTx:BTCHexFromData([transaction data])];
    //    return;
    
    
}

-(void)validationSignTx:(NSString *)signTx
{
    //    return;
    TLNetworking *net = [TLNetworking new];
    net.code = @"802222";
    net.showView = self.view;
    net.parameters[@"signTx"] = signTx;
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [net postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [TLAlert alertWithSucces:@"广播成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}


// Simple method for now, fetching unspent coins on the fly //目前的方法很简单，即动态提取未使用的硬币
- (BTCTransaction*) transactionSpendingFromPrivateKey:(NSData*)privateKey
                                                   to:(BTCPublicKeyAddress*)destinationAddress
                                               change:(BTCPublicKeyAddress*)changeAddress
                                               amount:(NSString *)amount
                                                  fee:(NSString*)fee
                                                  api:(BTCAPI)btcApi
                                                error:(NSError**)errorOut
{
    /// 1。获取私钥、目标地址、更改地址和金额
    // 2。获取该键的未使用的输出(使用压缩和非压缩pubkey)
    // 3。将最小的可用输出合并到新事务的输入中
    // 4。为输入准备带有适当签名的脚本
    // 5。广播事务
    NSError* error = nil;
    NSArray* utxos = self.utxis;
    if (!utxos) {
        *errorOut = error;
        return nil;
    }
    CoinModel *coin = [CoinUtil getCoinModel:@"BTC"];
    long long mount = [[CoinUtil convertToSysCoin:amount coin:coin.symbol] longLongValue];
    BTCAmount btcValue = mount;
    BTCAmount sumIntputValue = 0;//Intput总额
    int sumIntputCount = 0;//Intput总个数
    BOOL isChange = NO;//是否需要找零
    BTCAmount changeValue = 0;//找零金额
    long long btcFree = 0;//手续费
    NSMutableArray *IntputUtsos = [NSMutableArray array];
    
//    计算服务费
    for (int i = 0; i < self.utxis.count; i ++) {
        utxoModel* txout = self.utxis[i];
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
    
    // We support spending just one output for now. 我们目前只支持支出一项产出。
    if (btcValue + btcFree > sumIntputValue) {
        self.btcPrompt = [LangSwitcher switchLang:@"余额不足" key:nil];
    }
    if (!IntputUtsos)
    {
        return nil;
    }
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (utxoModel* txout in IntputUtsos) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.previousHash =  BTCHashFromID(txout.txid);
        txin.previousIndex = [txout.vout intValue];
        [tx addInput:txin];
        
        NSLog(@"txhash: http://blockchain.info/rawtx/%@", BTCHexFromData(txin.previousHash));
        NSLog(@"txhash: http://blockchain.info/rawtx/%@ (reversed)", BTCHexFromData(BTCReversedData([txout.scriptPubKey dataUsingEncoding:NSUTF8StringEncoding])));
        
        spentCoins +=  [[CoinUtil convertToSysCoin:txout.count coin:@"BTC"] longLongValue];
    }
    
    NSLog(@"Total satoshis to spend:       %lld", spentCoins);
    NSLog(@"Total satoshis to destination: %lld", mount);
    NSLog(@"Total satoshis to fee:         %lld", btcFree);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins - (mount + btcFree)));
    
    // Add required outputs - payment and change
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:mount address:destinationAddress];
    [tx addOutput:paymentOutput];
    
    if (isChange == YES) {
        BTCTransactionOutput *changeOutput = [[BTCTransactionOutput alloc] initWithValue:(changeValue) address:changeAddress];
        [tx addOutput:changeOutput];
    }
    for (int i = 0; i < IntputUtsos.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this 通常情况下，我们需要找到合适的钥匙来签这个txin，example we already know that we use a single private key.但是在这个例我们已经知道我们使用的是一个私钥。
        utxoModel* txout = IntputUtsos[i]; // output from a previous tx which is referenced by this txin. 此txin引用的前一个tx的输出。
        
        
        BTCTransactionInput* txin = tx.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        NSData* d1 = tx.data;
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        BTCScript *sc = [[BTCScript alloc] initWithData:BTCDataFromHex(txout.scriptPubKey)];
        NSData* hash = [tx signatureHashForScript:sc inputIndex:i hashType:hashtype error:errorOut];
        NSData* d2 = tx.data;
        NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");
        // 134675e153a5df1b8e0e0f0c45db0822f8f681a2eb83a0f3492ea8f220d4d3e4
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        NSLog(@"pubKey: %@", BTCHexFromData(self.key.publicKey));
        
        if (!hash) {
            return nil;
        }
        
        NSData* signatureForScript = [self.key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:self.key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        NSAssert([self.key isValidSignature:sig hash:hash], @"Signature must be valid");
        txin.signatureScript = sigScript;
    }
    {
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
        NSError* error = nil;
        NSString *scriptPubKey = [[IntputUtsos objectAtIndex:0] scriptPubKey];
        BTCScript *script = [[BTCScript alloc] initWithData:BTCDataFromHex(scriptPubKey)];
        //        BTCScript *script = [[BTCScript alloc] initWithString:scriptPubKey];
        BOOL r = [sm verifyWithOutputScript:script error:&error];
        NSLog(@"Error: %@", error);
        NSAssert(r, @"should verify first output");
    }
    return tx;
}

-(void)utxoTransfer
{
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            
        }
        [set close];
    }
    [dataBase.dataBase close];
    //    [self queryTotalAmount];
    
    
    NSArray *words = [word componentsSeparatedByString:@" "];
    
    BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
    BTCKeychain *keychain = [mnemonic keychain];
    
    if ([AppConfig config].runEnv == 0) {
        keychain = [keychain derivedKeychainWithPath:@"m/44'/0'/0'/0/0"];
        keychain.network = [BTCNetwork mainnet];
        
    }else{
        keychain = [keychain derivedKeychainWithPath:@"m/44'/1'/0'/0/0"];
        keychain.network = [BTCNetwork testnet];
        
    }
    BTCKey *key = keychain.key;
    self.key = key;
    BTCTransaction* transaction;
    NSString *add;
    for (int i = 0; i < self.localcurrencys.count; i++) {
        if ([self.currentModel.symbol isEqualToString:self.centercurrencys[i].currency]) {
            add = self.centercurrencys[i].coinAddress;
        }
    }
    if ([AppConfig config].runEnv == 0) {
        transaction = [UsdtClient createSignedSimpleSend:key.address privateKey:key to:[BTCPublicKeyAddress addressWithString:add] currencyID:@"31" amount:self.numberTextField.text utxoList:self.utxis setFee:[NSString stringWithFormat:@"%ld",self.btcPrice] btcValue:self.numberTextField.text];
    }else
    {
        transaction = [UsdtClient createSignedSimpleSend:key.addressTestnet privateKey:key to:[BTCPublicKeyAddressTestnet addressWithString:add] currencyID:@"2" amount:self.numberTextField.text utxoList:self.utxis setFee:[NSString stringWithFormat:@"%ld",self.btcPrice] btcValue:self.numberTextField.text];
    }
    
    if (transaction == nil) {
        return;
    }
    [self validationSignTx:BTCHexFromData([transaction data])];
    
    
}


@end
