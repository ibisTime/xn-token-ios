#import "TLWalletVC.h"
#import "CurrencyModel.h"
#import "FMDBMigrationManager.h"
#import "RechargeCoinVC.h"
#import "WithdrawalsCoinVC.h"
#import "BillVC.h"
#import "TLPwdRelatedVC.h"
#import "RateDescVC.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "PlatformTableView.h"
#import "WallAccountVC.h"
#import "AddAccoutMoneyVc.h"
#import "WalletLocalVc.h"
#import "RateModel.h"
#import "CountryModel.h"
#import "TLFastvc.h"
#import "TLTransfromVC.h"
#import "BuildLocalHomeView.h"
#import "WalletImportVC.h"
#import "HTMLStrVC.h"
#import "BuildSucessVC.h"
#import "BTCMnemonic.h"
#import "BTCNetwork.h"
#import "BTCData.h"
#import "MnemonicUtil.h"
#import "BTCKeychain.h"
#import "BillModel.h"
#import "WalletForwordVC.h"
#import "AssetsHeadView.h"
#import "TradePasswordVC.h"
//引导图
#import "GuideTheFigureView.h"

@interface TLWalletVC ()<RefreshDelegate,AssetsHeadViewDelegate>

@property (nonatomic , copy)NSString *isWallet;

@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) PlatformTableView *tableView;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*AssetsListModel;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*allCurrencys;

@property (nonatomic, strong) NSMutableArray <RateModel *>*rates;

@property (nonatomic, strong) TLNetworking *helper;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic,strong) NSMutableArray <CoinModel *>*coins;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@property (nonatomic, strong) TLNetworking *http;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) BuildLocalHomeView *homeView;

@property (nonatomic , strong)AssetsHeadView *headView;

@property (nonatomic , strong)GuideTheFigureView *figureView;

@end

@implementation TLWalletVC

-(AssetsHeadView *)headView
{
    if (!_headView) {
        _headView = [[AssetsHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30)];
        _headView.delegate = self;
        _headView.backgroundColor = kWhiteColor;
        
        self.homeView = [[BuildLocalHomeView alloc] initWithFrame:CGRectMake(0, (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30 , SCREEN_WIDTH, 340)];
        self.homeView.hidden = YES;
        [self.headView addSubview:self.homeView];
        
        CoinWeakSelf;
        self.homeView.buildBlock = ^{
            TradePasswordVC *vc = [[TradePasswordVC alloc]init];
            vc.state = @"1";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        self.homeView.importBlock = ^{
            TradePasswordVC *vc = [[TradePasswordVC alloc]init];
            vc.state = @"2";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headView;
}

-(void)AssetsHeadViewDelegateSelectBtn:(NSInteger)tag
{
    
    switch (tag) {
        case 0:
        {
            RateDescVC *descVC = [RateDescVC new];
            [self.navigationController pushViewController:descVC animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if ([TLUser user].isLogin == NO) {
                [self loginTheWhether];
            }
            if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:MNEMONIC]] == NO) {
                
                TLTransfromVC *trans = [TLTransfromVC new];
                if ([self.isWallet isEqualToString:@"私钥钱包"])
                {
                    trans.isLocal = YES;
                }
                else
                {
                    trans.isLocal = NO;
                }
                [self.navigationController pushViewController:trans animated:YES];
            }else{
                
                [TLAlert alertWithTitle:[LangSwitcher switchLang:@"提示" key:nil] message:@"您还未创建私钥钱包,无法使用一键划转功能" confirmAction:^{
                }];
            }
        }
            break;
        case 3:
        {
            TLFastvc *fast = [TLFastvc new];
            [self.navigationController pushViewController:fast animated:YES];
        }
            break;
        case 4:
        {
//            点击加号
            if ([self.isWallet isEqualToString:@"私钥钱包"]) {
                AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
                monyVc.PersonalWallet = 101;
                [self.navigationController pushViewController:monyVc animated:YES];
            }else
            {
                AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
                monyVc.PersonalWallet = 100;
                [self.navigationController pushViewController:monyVc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 首页顶部滑动
-(void)SlidingIsWallet:(NSString *)WalletName
{
    self.isWallet = WalletName;
    if ([WalletName isEqualToString:@"私钥钱包"]) {
        if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC]] == YES) {
            self.homeView.hidden = NO;
            _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30 + 340);
            self.tableView.platforms = self.allCurrencys;
        }else
        {
            self.homeView.hidden = YES;
            _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30);
            self.tableView.platforms = self.allCurrencys;
        }
    }else
    {
        self.homeView.hidden = YES;
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH - 40)/2.3 + 61 + 12 + 11 + 30);
        self.tableView.platforms = self.AssetsListModel;
    }
    self.tableView.isWallet = self.isWallet;
    [self.tableView reloadData];
    [TableViewAnimationKit showWithAnimationType:2 tableView:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
  
    [super viewWillAppear:animated];
    [self navigationSetDefault];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([TLUser user].isLogin == NO) {
        self.isWallet = @"私钥钱包";
    }else
    {
        self.isWallet = @"个人钱包";
    }
    self.view.backgroundColor = kWhiteColor;
    [self initTableView];
    //登录退出通知
    [self addNotification];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"LOADDATAPAGE2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction1:) name:@"LOADDATAPAGE3" object:nil];
}

#pragma mark -- 接收到通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self getMyCurrencyList];
}

- (void)InfoNotificationAction1:(NSNotification *)notification{
    [self saveLocalWalletData];
}

#pragma mark -- 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOADDATAPAGE2" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOADDATAPAGE3" object:nil];
}

//-(void)PageDisplayLoading
//{
//
//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    NSString *word;
//    NSString *btcadd;
//    NSString *pwd;
//    //   获取一键划转币种列表
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics,btcaddress,PwdKey  from THAUser where userId = '%@'",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            word = [set stringForColumn:@"Mnemonics"];
//            btcadd = [set stringForColumn:@"btcaddress"];
//            pwd = [set stringForColumn:@"PwdKey"];
//
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
//    //    [self queryTotalAmount];
//    if (word != nil && word.length > 0) {
//        BOOL isBuild = [[NSUserDefaults standardUserDefaults] boolForKey:KISBuild];
//        //判断是否是创建或者导入钱包之后返回的
//        if (isBuild == YES) {
//            //            获取本地数据库私钥币种列表
//            [self saveLocalWalletData];
//            //            判断是否更新
//            [self saveLocalWallet];
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KISBuild];
//        }
//        //        [self getMyCeurrencyList];
//        //1.7.0版本升级适配
////        if (btcadd != nil && btcadd.length > 0 && pwd !=nil) {
////            return;
////        }
//
//        NSArray *words = [word componentsSeparatedByString:@" "];
//        //这里第一次进行BTC的私钥和地址创建 存到用户表里面 和币种表
//        BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
//        if ([AppConfig config].runEnv == 0) {
//            mnemonic.keychain.network = [BTCNetwork mainnet];
//
//        }else{
//            mnemonic.keychain.network = [BTCNetwork testnet];
//        }
//        NSLog(@"Seed=%@", BTCHexFromData(mnemonic.seed));
//        NSLog(@"Mnemonic=%@", mnemonic.words);
//        NSLog(@"btc_privateKey=%@", [MnemonicUtil getBtcPrivateKey:mnemonic]);
//        NSString *btc_private = [MnemonicUtil getBtcPrivateKey:mnemonic];
//
//        NSString *btc_address = [MnemonicUtil getBtcAddress:mnemonic];
//        //助记词存在 新增btc地址
//        TLDataBase *data = [TLDataBase sharedManager];
//        if ([data.dataBase open]) {
//
//            NSString *sql = [NSString stringWithFormat:@"UPDATE THAUser SET btcaddress = '%@',btcprivate = '%@' WHERE userId='%@'",btc_address,btc_private,[TLUser user].userId];
//            NSString *sql1 = [NSString stringWithFormat:@"UPDATE THALocal SET address = '%@' WHERE walletId = (SELECT walletId from THAUser where userId='%@') and symbol = '%@' ",btc_address,[TLUser user].userId,@"BTC"];
//            BOOL sucess = [data.dataBase executeUpdate:sql];
//            BOOL sucess1 = [data.dataBase executeUpdate:sql1];
//
//            NSLog(@"更新自选状态%d",sucess);
//            NSLog(@"更新自选状态%d",sucess1);
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KIS170];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        [data.dataBase close];
//
//        if (pwd==nil ) {
//            TLDataBase *data = [TLDataBase sharedManager];
//            if ([data.dataBase open]) {
//
//                NSString *sql = [NSString stringWithFormat:@"UPDATE THAUser SET PwdKey = '%@' WHERE userId='%@'",@"888888",[TLUser user].userId];
//
//                BOOL sucess = [data.dataBase executeUpdate:sql];
//
//                NSLog(@"更新自选状态%d",sucess);
//
//            }
//            [data.dataBase close];
//
//        }
//
//    }else{
//
//
//        if (self.isBulid == YES) {
//            if (self.tableView.mj_header.isRefreshing) {
//                return;
//            }
//            //从私钥钱包子界面返回
//            [self switchWithTager:0];
//        }
//    }
//}
//
//-(void)addUSDT
//{
//    NSString *btcadd;
//
////    NSString *pwd;
//    //   获取一键划转币种列表
//    TLDataBase *dataBase = [TLDataBase sharedManager];
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics,btcaddress,PwdKey  from THAUser where userId = '%@'",[TLUser user].userId];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            btcadd = [set stringForColumn:@"btcaddress"];
//        }
//        [set close];
//    }
//    [dataBase.dataBase close];
//
//    NSString *usdtadd;
//    if ([dataBase.dataBase open]) {
//        NSString *sql = [NSString stringWithFormat:@"SELECT address  from THALocal where userId = '%@ and symbol = '%@''",[TLUser user].userId,@"USDT"];
//        //        [sql appendString:[TLUser user].userId];
//        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
//        while ([set next])
//        {
//            usdtadd = [set stringForColumn:@"address"];
//        }
//        [set close];
//    }
//    if ([TLUser isBlankString:usdtadd] == YES){
//        TLDataBase *data = [TLDataBase sharedManager];
//        if ([data.dataBase open]) {
//
//            NSString *sql2 = [NSString stringWithFormat:@"UPDATE THALocal SET address = '%@' WHERE walletId = (SELECT walletId from THAUser where userId='%@') and symbol = '%@' ",btcadd,[TLUser user].userId,@"USDT"];
//            BOOL sucess2 = [data.dataBase executeUpdate:sql2];
//            NSLog(@"%d",sucess2);
//        }
//        [data.dataBase close];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)initTableView {
    [self.titleView removeFromSuperview];

    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight ) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
//    cell点击方法
    CoinWeakSelf;
    self.tableView.selectBlock = ^(NSInteger inter) {
        if ([weakSelf.isWallet isEqualToString:@"个人钱包"]) {
            WallAccountVC *accountVC= [[WallAccountVC alloc] init];
            accountVC.currency = weakSelf.AssetsListModel[inter];
            accountVC.title = accountVC.currency.currency;
            accountVC.billType = CurrentTypeAll;
            [weakSelf.navigationController pushViewController:accountVC animated:YES];
        }
        else
        {
            WalletLocalVc *accountVC= [[WalletLocalVc alloc] init];
            accountVC.currency = weakSelf.allCurrencys[inter];
            accountVC.billType = LocalTypeAll;
            [weakSelf.navigationController pushViewController:accountVC animated:YES];
        }
    };
}

-(void)refreshTableView:(TLTableView *)refreshTableview setCurrencyModel:(CurrencyModel *)model setTitle:(NSString *)title
{
    if ([title isEqualToString:@"转账"]) {
        if ([self.isWallet isEqualToString:@"个人钱包"]) {
            [self clickWithdrawWithCurrency:model];
        }else
        {
            WalletForwordVC *coinVC = [WalletForwordVC new];
            coinVC.currency = model;
            [self.navigationController pushViewController:coinVC animated:YES];
        }
    }else
    {
        RechargeCoinVC *coinVC = [RechargeCoinVC new];
        coinVC.currency = model;
        [self.navigationController pushViewController:coinVC animated:YES];
    }
}

- (void)clickWithdrawWithCurrency:(CurrencyModel *)currencyModel {
    CoinWeakSelf;
    //    实名认证成功后，判断是否设置资金密码
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{
            [weakSelf clickWithdrawWithCurrency:currencyModel];
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        return;
    }
    WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
    coinVC.currency = currencyModel;
    [self.navigationController pushViewController:coinVC animated:YES];
}


- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
}

-(void)loadData
{
    CoinWeakSelf;
    
    [self.tableView addRefreshAction:^{
        
        [CoinUtil refreshOpenCoinList:^{
            //    个人钱包
            [weakSelf getMyCurrencyList];
            //    获取公告列表
            [weakSelf requestRateList];
            //    私钥钱包
            [weakSelf saveLocalWalletData];

        } failure:^{
            [weakSelf.tableView endRefreshHeader];
        }];
        
    }];
    
    [self.tableView beginRefreshing];
}

#pragma mark -- 个人钱包列表网络请求
- (void)getMyCurrencyList {
    
    if (([TLUser user].isLogin == NO)){
        return;
    }
    CoinWeakSelf;
    TLNetworking *http = [TLNetworking new];
    http.code = @"802504";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        NSMutableArray <CurrencyModel *>*modes;
//        NSArray <CurrencyModel *>*models;
        weakSelf.AssetsListModel = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        self.headView.dataDic = responseObject[@"data"];
        [weakSelf.tableView reloadData];
        if ([self.isWallet isEqualToString:@"个人钱包"]) {
            
            weakSelf.tableView.platforms = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
            
            [weakSelf.tableView reloadData];
            if (modes.count != weakSelf.AssetsListModel.count) {
                [TableViewAnimationKit showWithAnimationType:2 tableView:self.tableView];
            }
            [self GuideTheFigure];
            [weakSelf.tableView endRefreshHeader];
        }
        modes = weakSelf.AssetsListModel;
        
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView endRefreshHeader];
        
    }];
}


- (void)saveLocalWalletData{
//    兼容2.0以下私钥数据库
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    NSString *pwd;
    //   获取一键划转币种列表
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics,btcaddress,PwdKey  from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            pwd = [set stringForColumn:@"PwdKey"];
        }
        [set close];
    }
    [dataBase.dataBase close];
    
    if ([TLUser isBlankString:word] == NO && [TLUser isBlankString:pwd] == NO) {
        if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC]] == YES) {
            [[NSUserDefaults standardUserDefaults]setObject:word forKey:MNEMONIC];
            [[NSUserDefaults standardUserDefaults]setObject:pwd forKey:MNEMONICPASSWORD];
        }
    }
    if ([TLUser isBlankString:[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC]] == YES) {
        return;
    }
    NSMutableArray *arr = [[CoinModel coin] getOpenCoinList];
    NSMutableArray *muArray = [NSMutableArray array];
    NSString *isAccording;
    NSArray *CoinArray = [[NSUserDefaults standardUserDefaults]objectForKey:COINARRAY];
//        本地未存私钥列表
    for (int i = 0; i < arr.count; i++) {
        CoinModel *model = arr[i];
        //        symbol = model.symbol;
        NSArray *array = [[[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC] componentsSeparatedByString:@" "];
        BTCMnemonic *mnemonic1 =  [MnemonicUtil importMnemonic:array];
        if ([AppConfig config].runEnv == 0) {
            mnemonic1.keychain.network = [BTCNetwork mainnet];
            
        }else{
            mnemonic1.keychain.network = [BTCNetwork testnet];
        }
        NSString *address;
        if ([model.type isEqualToString:@"0"]) {
            if ([model.symbol isEqualToString:@"BTC"] || [model.symbol isEqualToString:@"USDT"]) {
                if (CoinArray.count > 0) {
                    isAccording = [self judgeIsAccording:model.symbol setCoinArray:CoinArray];
                }else
                {
                    isAccording = @"是";
                }
                address = [MnemonicUtil getBtcAddress:mnemonic1];
            }
            if ([model.symbol isEqualToString:@"ETH"]) {
                address = [MnemonicUtil getEthAddress:mnemonic1];
                if (CoinArray.count > 0) {
                    isAccording = [self judgeIsAccording:model.symbol setCoinArray:CoinArray];
                }else
                {
                    isAccording = @"是";
                }
            }
            if ([model.symbol isEqualToString:@"WAN"]) {
                address = [MnemonicUtil getEthAddress:mnemonic1];
                if (CoinArray.count > 0) {
                    isAccording = [self judgeIsAccording:model.symbol setCoinArray:CoinArray];
                }else
                {
                    isAccording = @"是";
                }
            }
        }else if ([model.type isEqualToString:@"1"])
        {
            address = [MnemonicUtil getEthAddress:mnemonic1];
            if (CoinArray.count > 0) {
                isAccording = [self judgeIsAccording:model.symbol setCoinArray:CoinArray];
            }else
            {
                isAccording = @"否";
            }
        }
        else
        {
            address = [MnemonicUtil getEthAddress:mnemonic1];
            if (CoinArray.count > 0) {
                isAccording = [self judgeIsAccording:model.symbol setCoinArray:CoinArray];
            }else
            {
                isAccording = @"否";
            }
        }
        
        [arr[i] setValue:address forKey:@"address"];
        
        NSDictionary *coinDic = @{@"symbol":model.symbol,
                                  @"type":model.type,
                                  @"address":address,
                                  @"Select":isAccording
                                  };
        [muArray addObject:coinDic];
        
    }
        self.coins = arr;

    [[NSUserDefaults standardUserDefaults] setObject:muArray forKey:COINARRAY];
    //   私钥钱包
    [self queryTotalAllAmount];
}


-(NSString *)judgeIsAccording:(NSString *)symbol setCoinArray:(NSArray *)array
{

    for (int i = 0; i < array.count; i ++) {
        if ([array[i][@"symbol"] isEqualToString:symbol]) {
            return array[i][@"Select"];
        }
    }
    return @"否";
}

#pragma mark - Events

- (void)userlogin
{
    [self getMyCurrencyList];
}

- (void)queryTotalAllAmount {
    TLNetworking *http = [TLNetworking new];
    http.code = @"802270";
    http.isLocal = YES;
    http.isUploadToken = NO;
    NSString *symbol;
    NSString *address;
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *muArray = [[NSUserDefaults standardUserDefaults]objectForKey:COINARRAY];
    for (int i = 0; i < muArray.count; i ++) {
        if ([muArray[i][@"Select"] isEqualToString:@"是"]) {
            symbol = muArray[i][@"symbol"];
            address = muArray[i][@"address"];
            if (!address) {
                address = @"";
                
            }
            NSDictionary *dic = @{@"symbol":symbol,
                                  @"address":address
                                  };
            [arr addObject:dic];
        }
    }
    NSString *btc_address;
    for (int i = 0; i < arr.count; i ++) {
        if ([arr[i][@"symbol"] isEqualToString:@"BTC"]) {
            
            NSString *word = [[NSUserDefaults standardUserDefaults]objectForKey:MNEMONIC];
            NSArray *words = [word componentsSeparatedByString:@" "];
            //这里第一次进行BTC的私钥和地址创建 存到用户表里面 和币种表
            BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
            if ([AppConfig config].runEnv == 0)
            {
                mnemonic.keychain.network = [BTCNetwork mainnet];
            }
            else
            {
                mnemonic.keychain.network = [BTCNetwork testnet];
            }
            btc_address = [MnemonicUtil getBtcTheOldAddress:mnemonic];

            [[NSUserDefaults standardUserDefaults]setObject:btc_address forKey:BTCADDRESS];
            NSDictionary *dic = @{@"address":btc_address,
                                  @"symbol":@"BTC"
                                  };
            [arr insertObject:dic atIndex:i+1];
//            [arr addObject:dic];
            break;
        }
    }
    http.parameters[@"accountList"] = arr;
    CoinWeakSelf;
    
    [http postWithSuccess:^(id responseObject) {
        NSMutableArray <CurrencyModel *>*modes;
        self.headView.privateDataDic = responseObject[@"data"];
        [self.tableView reloadData];
       weakSelf.allCurrencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        if ([self.isWallet isEqualToString:@"私钥钱包"]) {
            self.tableView.platforms = self.allCurrencys;
            self.tableView.isWallet = self.isWallet;
            [self.tableView reloadData];
            if (modes.count != weakSelf.allCurrencys.count) {
                [TableViewAnimationKit showWithAnimationType:2 tableView:self.tableView];
            }
            [self GuideTheFigure];
            [weakSelf.tableView endRefreshHeader];
        }
        modes = weakSelf.allCurrencys;
        
    } failure:^(NSError *error) {
        [weakSelf.tableView endRefreshHeader];
    }];
}

-(void)GuideTheFigure
{
    if (self.tableView.platforms.count > 0
        && [TLUser isBlankString:[[NSUserDefaults standardUserDefaults]objectForKey:@"GUIDETHEDFIGURE"]] == YES
        ) {
        GuideTheFigureView *figureView = [[GuideTheFigureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.figureView = figureView;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:figureView];
        [[UserModel user] showPopAnimationWithAnimationStyle1:1 showView:figureView];
    }
}

//获取公告列表
- (void)requestRateList {
    CoinWeakSelf;
    TLPageDataHelper *help = [[TLPageDataHelper alloc] init];
    help.parameters[@"channelType"] = @4;
    help.parameters[@"toSystemCode"] = [AppConfig config].systemCode;
    help.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
        help.parameters[@"start"] = @"1";
    help.parameters[@"status"] = @"1";
    help.parameters[@"limit"] = @"10";
    help.code = @"804040";
    help.isUploadToken = NO;
    [help modelClass:[RateModel class]];
    [help refresh:^(NSMutableArray *objs, BOOL stillHave) {
        weakSelf.rates = objs;
        if (objs.count > 0) {
            weakSelf.headView.usdRate = weakSelf.rates[0].smsTitle;
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
