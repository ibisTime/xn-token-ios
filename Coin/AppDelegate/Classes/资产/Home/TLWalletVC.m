//
//  TLWalletVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWalletVC.h"
#import "WalletHeaderView.h"
#import "CurrencyModel.h"
#import "FMDBMigrationManager.h"
#import "RechargeCoinVC.h"
#import "WithdrawalsCoinVC.h"
#import "BillVC.h"
#import "TLPwdRelatedVC.h"
#import "RateDescVC.h"
#import "ZMAuthVC.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "PlatformTableView.h"
#import "WallAccountVC.h"
#import "AddAccoutMoneyVc.h"
#import "WalletLocalVc.h"
#import "RateModel.h"
#import "WallAccountVC.h"
#import "QRCodeVC.h"
#import "BuildWalletMineVC.h"
#import "CountryModel.h"
#import "TLFastvc.h"
#import "TLTransfromVC.h"
#import "BuildLocalHomeView.h"
#import "WalletImportVC.h"
#import "HTMLStrVC.h"
#import "BuildSucessVC.h"
#import "BuildWalletMineVC.h"
#import "BTCMnemonic.h"
#import "BTCNetwork.h"
#import "BTCData.h"
#import "MnemonicUtil.h"
#import "BTCKeychain.h"
#import "BillModel.h"

@interface TLWalletVC ()<RefreshDelegate>

@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) WalletHeaderView *headerView;

@property (nonatomic, strong) PlatformTableView *tableView;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*AssetsListModel;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*localCurrencys;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*allCurrencys;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*tempcurrencys;

@property (nonatomic, strong) NSMutableArray <RateModel *>*rates;

@property (nonatomic, strong) TLNetworking *helper;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic,strong) NSMutableArray <CoinModel *>*coins;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@property (nonatomic, strong) TLNetworking *http;

#pragma mark -- switchTager   0 私钥    1 个人钱包
@property (nonatomic, assign) NSInteger switchTager;

//清除公告 更新UI
@property (nonatomic, assign) BOOL isClear;

@property (nonatomic, copy) NSString *IsLocalExsit;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) BuildLocalHomeView *homeView;

@property (nonatomic, assign) BOOL isBulid;

@property (nonatomic, assign) BOOL isAddBack;

@end

@implementation TLWalletVC

-(void)viewDidAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
  
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self PageDisplayLoading];
    [self addUSDT];
    
}


-(void)PageDisplayLoading
{

    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *word;
    NSString *btcadd;
    
    NSString *pwd;
    //   获取一键划转币种列表
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics,btcaddress,PwdKey  from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            word = [set stringForColumn:@"Mnemonics"];
            btcadd = [set stringForColumn:@"btcaddress"];
            pwd = [set stringForColumn:@"PwdKey"];

        }
        [set close];
    }
    [dataBase.dataBase close];
    //    [self queryTotalAmount];
    if (word != nil && word.length > 0) {
        BOOL isBuild = [[NSUserDefaults standardUserDefaults] boolForKey:KISBuild];
        //判断是否是创建或者导入钱包之后返回的
        if (isBuild == YES) {
            //            获取本地数据库私钥币种列表
            [self saveLocalWalletData];
            //            判断是否更新
            [self saveLocalWallet];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KISBuild];
        }
        //        [self getMyCeurrencyList];
        //1.7.0版本升级适配
        if (btcadd != nil && btcadd.length > 0 && pwd !=nil) {
            return;
        }

        NSArray *words = [word componentsSeparatedByString:@" "];
        //这里第一次进行BTC的私钥和地址创建 存到用户表里面 和币种表
        BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
        if ([AppConfig config].runEnv == 0) {
            mnemonic.keychain.network = [BTCNetwork mainnet];

        }else{
            mnemonic.keychain.network = [BTCNetwork testnet];

        }

        NSLog(@"Seed=%@", BTCHexFromData(mnemonic.seed));
        NSLog(@"Mnemonic=%@", mnemonic.words);
        NSLog(@"btc_privateKey=%@", [MnemonicUtil getBtcPrivateKey:mnemonic]);
        NSString *btc_private = [MnemonicUtil getBtcPrivateKey:mnemonic];

        NSString *btc_address = [MnemonicUtil getBtcAddress:mnemonic];
        //助记词存在 新增btc地址
        TLDataBase *data = [TLDataBase sharedManager];
        if ([data.dataBase open]) {

            NSString *sql = [NSString stringWithFormat:@"UPDATE THAUser SET btcaddress = '%@',btcprivate = '%@' WHERE userId='%@'",btc_address,btc_private,[TLUser user].userId];
            NSString *sql1 = [NSString stringWithFormat:@"UPDATE THALocal SET address = '%@' WHERE walletId = (SELECT walletId from THAUser where userId='%@') and symbol = '%@' ",btc_address,[TLUser user].userId,@"BTC"];
            BOOL sucess = [data.dataBase executeUpdate:sql];
            BOOL sucess1 = [data.dataBase executeUpdate:sql1];

            NSLog(@"更新自选状态%d",sucess);
            NSLog(@"更新自选状态%d",sucess1);
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KIS170];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [data.dataBase close];

        if (pwd==nil ) {
            TLDataBase *data = [TLDataBase sharedManager];
            if ([data.dataBase open]) {

                NSString *sql = [NSString stringWithFormat:@"UPDATE THAUser SET PwdKey = '%@' WHERE userId='%@'",@"888888",[TLUser user].userId];

                BOOL sucess = [data.dataBase executeUpdate:sql];

                NSLog(@"更新自选状态%d",sucess);

            }
            [data.dataBase close];

        }

    }else{


        if (self.isBulid == YES) {
            if (self.tableView.mj_header.isRefreshing) {
                return;
            }
            //从私钥钱包子界面返回
            [self switchWithTager:0];
        }
    }
}


-(void)addUSDT
{
    NSString *btcadd;

//    NSString *pwd;
    //   获取一键划转币种列表
    TLDataBase *dataBase = [TLDataBase sharedManager];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics,btcaddress,PwdKey  from THAUser where userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            btcadd = [set stringForColumn:@"btcaddress"];
        }
        [set close];
    }
    [dataBase.dataBase close];

    NSString *usdtadd;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT address  from THALocal where userId = '%@ and symbol = '%@''",[TLUser user].userId,@"USDT"];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            usdtadd = [set stringForColumn:@"address"];
        }
        [set close];
    }

    if ([TLUser isBlankString:usdtadd] == YES){

        TLDataBase *data = [TLDataBase sharedManager];
        if ([data.dataBase open]) {

            NSString *sql2 = [NSString stringWithFormat:@"UPDATE THALocal SET address = '%@' WHERE walletId = (SELECT walletId from THAUser where userId='%@') and symbol = '%@' ",btcadd,[TLUser user].userId,@"USDT"];
            BOOL sucess2 = [data.dataBase executeUpdate:sql2];
            NSLog(@"%d",sucess2);
        }
        [data.dataBase close];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self initTableView];
    self.switchTager = 1;
    //登录退出通知
    [self addNotification];
    //列表查询个人账户币种列表
    [self getMyCurrencyList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"LOADDATAPAGE2" object:nil];
}

#pragma mark -- 接收到通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self getMyCurrencyList];
}

#pragma mark -- 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOADDATAPAGE2" object:nil];
}

#pragma mark - Init

- (WalletHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;

        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+ 11 + 40 + kHeight(40) + 40)];

        _headerView.centerBlock = ^{
             [weakSelf inreoduceView:@"个人账户" content:@"个人账户就是指中心化钱包,是由Theia替您保管私钥,在中心化钱包中,不存在钱包丢失了无法找回的情况,可以通过身份证找回您的钱包,并且可以让您体验到更多的服务。"];
        };
        
        _headerView.localBlock = ^{
             [weakSelf inreoduceView:@"私钥钱包" content:@"私钥钱包就是去中心化钱包,在去中心化钱包中,所有的用户身份验证内容,如交易密码,私钥，助记词等都保存在用户手机本地,并不是保存在中心化服务器里面,如果用户误删钱包,忘记备份私钥或者助记词，将无法找到钱包"];
        };
        //点击公告隐藏按钮
        _headerView.clearBlock = ^{

            weakSelf.isClear = YES;
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+ 11 + kHeight(40) + 40);
            weakSelf.leftButton.frame = CGRectMake(15, 65 + kHeight(150)+ 11, SCREEN_WIDTH/2 - 20, kHeight(40));
            weakSelf.rightButton.frame = CGRectMake(5 + SCREEN_WIDTH/2, 65 + kHeight(150)+ 11 , SCREEN_WIDTH/2 - 20, kHeight(40));
            weakSelf.titleView.frame = CGRectMake(0, 65 + kHeight(150)+ 21 + kHeight(40), SCREEN_WIDTH, 30);

            if (self.switchTager == 0) {
                [weakSelf switchWithTager:weakSelf.switchTager];
            }
            [weakSelf.tableView reloadData];

            
        };
        //切换钱包事件
        _headerView.switchBlock = ^(NSInteger teger) {
            [weakSelf switchWithTager:teger];

        };

        _headerView.selectBlock = ^{
            [weakSelf.tableView reloadData];
        };
        
        //点击公告事件
        _headerView.headerBlock = ^{
            
            RateDescVC *descVC = [RateDescVC new];
            [weakSelf.navigationController pushViewController:descVC animated:YES];
        };

        
    }
    return _headerView;
}

#pragma mark -- 点击问号的方法
- (void)inreoduceView:(NSString *)name content:(NSString *)contents
{
    UIView *contentText = [UIView new];
    kViewRadius(contentText, 10);
    contentText.frame = CGRectMake(50,  -SCREEN_HEIGHT, SCREEN_WIDTH - 100, 100);
    self.contentView = contentText;
    [self.view addSubview:contentText];
    contentText.backgroundColor = kWhiteColor;


    UILabel *title = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:17.0];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(10, 30, SCREEN_WIDTH - 120, 20);
    title.text = [LangSwitcher switchLang:name key:nil];
    [contentText addSubview:title];
    
    
    UILabel *content = [UILabel labelWithBackgroundColor:kClearColor textColor:[UIColor grayColor] font:14];
    content.numberOfLines = 0;
    content.frame = CGRectMake(20, 70, SCREEN_WIDTH - 100 - 40, 0);
    content.attributedText = [UserModel ReturnsTheDistanceBetween:[LangSwitcher switchLang:contents key:nil]];
    [content sizeToFit];
    [contentText addSubview:content];
    
    UIButton *sureButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确定" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16];
    
    [contentText addSubview:sureButton];
    sureButton.layer.cornerRadius = 4.0;
    sureButton.clipsToBounds = YES;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.frame = CGRectMake(30, content.yy + 30, SCREEN_WIDTH - 100 - 60, 50);
    contentText.frame = CGRectMake(50, SCREEN_HEIGHT/2 - (sureButton.yy + 30)/2, SCREEN_WIDTH - 100, (sureButton.yy + 30));
    [[UserModel user] showPopAnimationWithAnimationStyle:2 showView:contentText];
}

- (void)sureClick
{
    [[UserModel user].cusPopView dismiss];
}

- (void)initTableView {
    [self.titleView removeFromSuperview];

    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight-kStatusBarHeight ) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];

    self.leftButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"闪兑" key:nil] titleColor:kHexColor(@"#333333") backgroundColor:kWhiteColor titleFont:14.0];
    [self.leftButton setImage:kImage(@"闪兑") forState:UIControlStateNormal];
    self.leftButton.layer.borderWidth = 0.3;
    self.leftButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
    [self.headerView addSubview:self.leftButton];

    self.rightButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"一键划转" key:nil] titleColor:kHexColor(@"#333333") backgroundColor:kWhiteColor titleFont:14.0];
    [self.rightButton setImage:kImage(@"一键划转") forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(fast) forControlEvents:UIControlEventTouchUpInside];
      [self.rightButton addTarget:self action:@selector(transNext) forControlEvents:UIControlEventTouchUpInside];

    [self.headerView addSubview:self.rightButton];
    self.titleView = [[UIView alloc] init];
    [self.headerView addSubview:self.titleView];

    self.titleView.backgroundColor = kClearColor;

    UILabel *text = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    text.text = [LangSwitcher switchLang:@"币种列表" key:nil];
    text.frame = CGRectMake( 20, 0, SCREEN_WIDTH - 40, 30);
    [self.titleView addSubview:text];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;

    
    [addButton setImage:kImage(@"增加") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addCurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_top).offset(4);
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.height.equalTo(@20);
    }];
//    self.addButton.hidden= YES;

    self.rightButton.layer.borderWidth = 0.3;
    self.rightButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

    self.leftButton.frame = CGRectMake(15, 65 + kHeight(150)+ 11 + 40, SCREEN_WIDTH/2 - 20, kHeight(40));
    self.rightButton.frame = CGRectMake(5 + SCREEN_WIDTH/2, 65 + kHeight(150)+ 11 + 40, SCREEN_WIDTH/2 - 20, kHeight(40));
    self.titleView.frame = CGRectMake(0, 65 + kHeight(150)+ 21 + 40 + kHeight(40), SCREEN_WIDTH, 30);


    self.homeView = [[BuildLocalHomeView alloc] initWithFrame:CGRectMake(0, 65 + kHeight(150)+ 11 + 40 , SCREEN_WIDTH, 340)];
    self.homeView.hidden = YES;
    [self.headerView addSubview:self.homeView];

    
    CoinWeakSelf;
    self.tableView.selectBlock = ^(NSInteger inter) {
        NSLog(@"%ld",inter);
        weakSelf.isBulid = NO;
        if (weakSelf.switchTager == 1) {
//            个人
            WallAccountVC *accountVC= [[WallAccountVC alloc] init];
            accountVC.currency = weakSelf.AssetsListModel[inter];
            accountVC.title = accountVC.currency.currency;
            accountVC.billType = CurrentTypeAll;
            [weakSelf.navigationController pushViewController:accountVC animated:YES];
        }
        else
        {
//            私钥1
            WalletLocalVc *accountVC= [[WalletLocalVc alloc] init];
            
            [weakSelf WhetherOrNotShown];
            for (int j = 0; j<weakSelf.localCurrencys.count; j++) {
                if ([weakSelf.arr[inter][@"symbol"] isEqualToString:weakSelf.localCurrencys[j].symbol]) {
                    accountVC.currency = weakSelf.localCurrencys[j];
                }
            }
//            accountVC.currency = weakSelf.localCurrencys[inter];
            accountVC.billType = LocalTypeAll;
            [weakSelf.navigationController pushViewController:accountVC animated:YES];
        }
    };
}


-(void)WhetherOrNotShown
{
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *symbol;
    NSString *address;
    _arr = [NSMutableArray array];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            symbol = [set stringForColumn:@"symbol"];
            address = [set stringForColumn:@"address"];
            
            [dic setObject:symbol forKey:@"symbol"];
            [_arr addObject:dic];
        }
        [set close];
    }
    [dataBase.dataBase close];
}



#pragma mark -- 点击加号按钮
- (void)addCurrent
{
    if (self.switchTager == 0) {
        AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
        monyVc.currentModels = self.currencys;
//        monyVc.isRedPage = YES;
        [self.navigationController pushViewController:monyVc animated:YES];
        CoinWeakSelf;
        self.tempcurrencys = [NSMutableArray array];
        monyVc.select = ^(NSMutableArray *model) {

            weakSelf.isAddBack = YES;
            [self.tableView reloadData];
//            [weakSelf queryTotalAmount];

        };
    }else
    {
        AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
        monyVc.PersonalWallet = 100;
        [self.navigationController pushViewController:monyVc animated:YES];

    }

}

#pragma mark --  切换私钥钱包和个人钱包滑块
- (void)switchWithTager: (NSInteger)tager
{
    if (tager == 1) {

        [self.leftButton setImage:kImage(@"闪兑") forState:UIControlStateNormal];
        [self.rightButton setImage:kImage(@"一键划转") forState:UIControlStateNormal];
        self.leftButton.layer.borderWidth = 0.3;

        self.leftButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
        self.rightButton.layer.borderWidth = 0.3;
        self.rightButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
//        CGFloat f = self.isClear == YES ?318 : 338;

        for (UIView *vie in self.view.subviews) {
            if ([vie isKindOfClass:[BuildLocalHomeView class]]) {
                [vie removeFromSuperview];
            }
        }

        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;

        self.tableView.hidden = NO;
        self.tableView.isLocal = NO;
        self.addButton.hidden = NO;

        CGFloat h = self.isClear == YES ? 300 : 315;
        if (kDevice_Is_iPhoneX) {
            h += 20;
        }
        if (self.isClear == YES)
        {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+ 11 + kHeight(40) + 40);
            self.leftButton.frame = CGRectMake(15, 65 + kHeight(150)+ 11, SCREEN_WIDTH/2 - 20, kHeight(40));
            self.rightButton.frame = CGRectMake(5 + SCREEN_WIDTH/2, 65 + kHeight(150)+ 11, SCREEN_WIDTH/2 - 20, kHeight(40));
            self.titleView.frame = CGRectMake(0, 65 + kHeight(150)+ 21 + kHeight(40), SCREEN_WIDTH, 30);
        }else
        {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+ 11 + kHeight(40) + 80);
            self.leftButton.frame = CGRectMake(15, 65 + kHeight(150)+ 11+ 40, SCREEN_WIDTH/2 - 20 , kHeight(40));
            self.rightButton.frame = CGRectMake(5 + SCREEN_WIDTH/2, 65 + kHeight(150)+ 11 + 40, SCREEN_WIDTH/2 - 20, kHeight(40));
            self.titleView.frame = CGRectMake(0, 65 + kHeight(150)+ 21 + kHeight(40)+ 40, SCREEN_WIDTH, 30);
        }


        self.tableView.hidden = NO;
        self.titleView.hidden = NO;

        [self.view setNeedsLayout];
        self.tableView.platforms = self.AssetsListModel;
        [self.tableView reloadData];
        self.tableView.scrollEnabled = YES;
        self.switchTager = 1;
        self.homeView.hidden = YES;
      

    }else{
        self.switchTager = 0;
        self.homeView.hidden = YES;
        //切换私钥钱包 需要查询用户是否已经创建完钱包
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
        //如果已创建钱包 显示私钥钱包列表
        if (Mnemonics.length > 0) {
            self.homeView.hidden = YES;
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            [self.leftButton setImage:kImage(@"闪兑-秘钥") forState:UIControlStateNormal];
            [self.rightButton setImage:kImage(@"划转-秘钥") forState:UIControlStateNormal];
//            [self.tabBarController.tabBar setHidden:NO];
            self.tableView.hidden = NO;
            self.leftButton.layer.borderWidth = 0.3;
            self.leftButton.layer.borderColor = kHexColor(@"#D1B3AB").CGColor;
            self.rightButton.layer.borderWidth = 0.3;
            self.rightButton.layer.borderColor = kHexColor(@"#D1B3AB").CGColor;

//            self.addButton.hidden = NO;
            self.titleView.hidden = NO;

            CGFloat f4 = self.isClear == YES ?350-30-15 : 350-30-30+5;
            if (kDevice_Is_iPhoneX) {
                if (self.isClear == YES) {
                    f4 =350-30-15-15;
                }
            }


            if (self.isClear == YES)
            {
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+ 11 + kHeight(40) + 40);
                self.leftButton.frame = CGRectMake(15, 65 + kHeight(150)+ 11, SCREEN_WIDTH/2 - 20, kHeight(40));
                self.rightButton.frame = CGRectMake(5 + SCREEN_WIDTH/2, 65 + kHeight(150)+ 11, SCREEN_WIDTH/2 - 20, kHeight(40));
                self.titleView.frame = CGRectMake(0, 65 + kHeight(150)+ 21 + kHeight(40), SCREEN_WIDTH, 30);
            }else
            {
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+ 11 + kHeight(40) + 80);
                self.leftButton.frame = CGRectMake(15, 65 + kHeight(150)+ 11+ 40, SCREEN_WIDTH/2 - 20 , kHeight(40));
                self.rightButton.frame = CGRectMake(5 + SCREEN_WIDTH/2, 65 + kHeight(150)+ 11 + 40, SCREEN_WIDTH/2 - 20, kHeight(40));
                self.titleView.frame = CGRectMake(0, 65 + kHeight(150)+ 21 + kHeight(40)+ 40, SCREEN_WIDTH, 30);
            }


            self.tableView.isLocal = YES;
            self.tableView.platforms = self.localCurrencys;

            [self.tableView reloadData];
            //检查币种表是否更新 是否需要缓存 更新
            [self saveLocalWalletData];
            [self saveLocalWallet];
            return;
        }
        // 2不存在就创建
        self.addButton.hidden = YES;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        self.homeView.hidden = NO;
        if (self.isClear == YES)
        {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150) + 20 + 340);
            self.homeView.frame = CGRectMake(0, 65 + kHeight(150) , SCREEN_WIDTH, 340);

        }else
        {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 65 + kHeight(150)+40 + 20 + 340 - 40 );
            self.homeView.frame = CGRectMake(0, 65 + kHeight(150) + 40 , SCREEN_WIDTH, 340);
        }
        self.homeView.backgroundColor = kWhiteColor;
        self.tableView.platforms = [NSMutableArray array];
        [self.tableView reloadData];
        self.headerView.backgroundColor = [UIColor whiteColor];


        CoinWeakSelf;
        self.homeView.buildBlock = ^{
//            创建钱包
            weakSelf.navigationController.navigationBar.hidden = NO;
            BuildWalletMineVC *sucessVC = [[BuildWalletMineVC alloc] init];
            [weakSelf.navigationController pushViewController:sucessVC animated:YES];
        };
        
        self.homeView.importBlock = ^{
            weakSelf.navigationController.navigationBar.hidden = NO;
            WalletImportVC *vc = [[WalletImportVC alloc] init];
            vc.title =  [LangSwitcher switchLang:@"导入钱包" key:nil];
            vc.walletBlock = ^{


            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
}

//闪兑
- (void)fast
{
    TLFastvc *fast = [TLFastvc new];
    [self.navigationController pushViewController:fast animated:YES];
}

//一键划转
- (void)transNext
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
    if (word.length > 0) {
//        一键划转
        TLTransfromVC *trans = [TLTransfromVC new];
        trans.isLocal = self.switchTager == 0 ? YES : NO;
        //    个人
        if (self.currencys.count == 0 || self.currencys.count == 0 || self.allCurrencys == 0) {
            return;
        }
        if (self.switchTager == 1) {
            trans.currencys = self.currencys;
            trans.centercurrencys = self.currencys;
            trans.localcurrencys = self.allCurrencys;
            trans.isLocal = NO;
        }else{
            //        私钥
            trans.currencys = self.currencys;
            trans.centercurrencys = self.currencys;
            trans.localcurrencys = self.allCurrencys;
            trans.isLocal = YES;
            
        }
        [self.navigationController pushViewController:trans animated:YES];

    }else{

//        导入钱包
        BuildWalletMineVC *settingVC = [BuildWalletMineVC new];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userloginOut) name:kUserLoginOutNotification object:nil];
}

//更新数据库
- (void)saveLocalWallet
{

     NSString *totalcount;
    TLDataBase *data = [TLDataBase sharedManager];

    if ([data.dataBase open]) {
      
        NSString *sql = [NSString stringWithFormat:@"SELECT next from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
        FMResultSet *set = [data.dataBase executeQuery:sql];
        while ([set next]) {
            
            totalcount = [set stringForColumn:@"next"];
     }
        [set close];
    }
    [data.dataBase close];
    if ([totalcount integerValue] == self.coins.count) {
        //判断是否新加并且删除了币种
        NSMutableArray *symbolArr = [NSMutableArray array];
        NSString *totalcount;
        TLDataBase *data = [TLDataBase sharedManager];
        
        if ([data.dataBase open]) {
            
            NSString *sql = [NSString stringWithFormat:@"SELECT symbol from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
            FMResultSet *set = [data.dataBase executeQuery:sql];
            while ([set next]) {
                
                totalcount = [set stringForColumn:@"symbol"];
                [symbolArr addObject:totalcount];
            }
            [set close];
        }
        [data.dataBase close];
        
        for (int i = 0; i < self.coins.count; i++) {
            
//            for (NSString *symbol in symbolArr) {
                if ([symbolArr containsObject:self.coins[i].symbol]) {
                    
                }else{
                    //存在不同的币种 更新本地币种表
                    TLDataBase *db = [TLDataBase sharedManager];
                    
                    if ([db.dataBase open]) {
                        NSString *Sql2 =[NSString stringWithFormat:@"delete from THALocal WHERE walletId = (SELECT walletId from THAUser where userId='%@')",[TLUser user].userId];
                        
                        BOOL sucess2  = [db.dataBase executeUpdate:Sql2];
                        NSLog(@"更新自选表%d",sucess2);
                    }
                    [db.dataBase close];
                    
                    
                    for (int i = 0; i < self.coins.count; i++) {
                        
                        CoinModel *model = self.coins[i];
                        TLDataBase *dateBase = [TLDataBase sharedManager];
                        if ([dateBase.dataBase open]) {

                            BOOL sucess = [dateBase.dataBase executeUpdate:@"INSERT INTO  THALocal(walletId,symbol,type,status,cname,unit,pic1,withdrawFeeString,withfrawFee,orderNo,ename,icon,pic2,pic3,address,IsSelect,next) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.walletId,model.symbol,model.type,model.status,model.cname,model.unit,model.pic1,model.withdrawFeeString,model.withfrawFee,model.orderNo,model.ename,model.icon,model.pic2,model.pic3,model.address,[NSNumber numberWithBool:YES],[NSString stringWithFormat:@"%ld",self.coins.count]];
                            
                            NSLog(@"插入币种表%d",sucess);
                        }
                        [dateBase.dataBase close];
                    }
                    
                    
                }
//            }
          
        }
        [self queryTotalAllAmount];
        return;
    }else {
        
        TLDataBase *db = [TLDataBase sharedManager];
        
        if ([db.dataBase open]) {
            NSString *Sql2 =[NSString stringWithFormat:@"delete from THALocal WHERE walletId = (SELECT walletId from THAUser where userId='%@')",[TLUser user].userId];
            
            BOOL sucess2  = [db.dataBase executeUpdate:Sql2];
            NSLog(@"更新自选表%d",sucess2);
        }
        [db.dataBase close];
   
    for (int i = 0; i < self.coins.count; i++) {
        
        CoinModel *model = self.coins[i];
        TLDataBase *dateBase = [TLDataBase sharedManager];
        if ([dateBase.dataBase open]) {

            BOOL sucess = [dateBase.dataBase executeUpdate:@"INSERT INTO  THALocal(walletId,symbol,type,status,cname,unit,pic1,withdrawFeeString,withfrawFee,orderNo,ename,icon,pic2,pic3,address,IsSelect,next) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.walletId,model.symbol,model.type,model.status,model.cname,model.unit,model.pic1,model.withdrawFeeString,model.withfrawFee,model.orderNo,model.ename,model.icon,model.pic2,model.pic3,model.address,[NSNumber numberWithBool:YES],[NSString stringWithFormat:@"%ld",self.coins.count]];
            
            NSLog(@"插入币种表%d",sucess);
        }
        [dateBase.dataBase close];
    }
    
    //插入币种表
    [self queryTotalAllAmount];
     }
}

#pragma mark -- 个人钱包列表网络请求
- (void)getMyCurrencyList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"802504";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.isList = YES;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[CurrencyModel class]];
    [self.tableView addRefreshAction:^{
        
        [CoinUtil refreshOpenCoinList:^{
            
            //获取公告列表
            [weakSelf requestRateList];
            //                获取本地存储私钥钱包
            [weakSelf saveLocalWalletData];
            //           监测是否需要更新新币种
            [weakSelf saveLocalWallet];
            //                个人钱包余额查询
            [weakSelf queryCenterTotalAmount];
            //                获取私钥钱包
            [weakSelf queryTotalAllAmount];
            
            [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
                
                //去除没有的币种
                NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
                [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CurrencyModel *currencyModel = (CurrencyModel *)obj;
                    [shouldDisplayCoins addObject:currencyModel];
                    //查询总资产
                }];
                if (self.switchTager == 1) {
                    weakSelf.tableView.platforms = shouldDisplayCoins;
                }
                weakSelf.AssetsListModel = shouldDisplayCoins;
                [weakSelf.tableView reloadData_tl];
                
            } failure:^(NSError *error) {
                
                [weakSelf.tableView endRefreshingWithNoMoreData_tl];
                
            }];
        } failure:^{
            [weakSelf.tableView endRefreshHeader];
        }];
    }];
    [self.tableView beginRefreshing];
}


- (void)saveLocalWalletData
{
    if (self.coins.count > 0) {
        return;
    }

    
    NSMutableArray *arr = [[CoinModel coin] getOpenCoinList];
    NSMutableArray *temp = arr.mutableCopy;
    TLDataBase *db = [TLDataBase sharedManager];
    for (int i = 0; i < temp.count; i++) {
        NSString *symbol;

        CoinModel *model = temp[i];
//        symbol = model.symbol;
//
        if ([model.type isEqualToString:@"0"]) {
            if ([model.symbol isEqualToString:@"BTC"] || [model.symbol isEqualToString:@"USDT"]) {
                symbol = @"btc";
            }
            if ([model.symbol isEqualToString:@"ETH"]) {
                symbol = @"eth";
            }
            if ([model.symbol isEqualToString:@"WAN"]) {
                symbol = @"wan";
            }
        }else if ([model.type isEqualToString:@"1"])
        {
            
            symbol = @"eth";
        }
        else
        {
            symbol = @"wan";
        }
   
    if ([db.dataBase open]) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT %@address,walletId from THAUser where userId = '%@'",symbol,[TLUser user].userId];
        FMResultSet *set =  [db.dataBase executeQuery:sql];
        
        while ([set next]) {
        CoinModel *coin  = arr[i];
        coin.address = [set stringForColumn:[NSString stringWithFormat:@"%@address",symbol]];
        coin.walletId = [NSString stringWithFormat:@"%d",[set intForColumn:@"walletId"]];
        }
        [set close];
    }
    [db.dataBase close];
    }
    self.coins = arr;
}

- (void)loadSum
{
    if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
  self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"￥ %.2f",[self.headerView.LocalMoney.text doubleValue] + [self.headerView.privateMoney.text doubleValue]] ;
        
    }else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
    {
  self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %.2f",[self.headerView.LocalMoney.text doubleValue] + [self.headerView.privateMoney.text doubleValue]] ;
        
    }
    else{
  self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f",[self.headerView.LocalMoney.text doubleValue] + [self.headerView.privateMoney.text doubleValue]] ;
        
    }
    [self.headerView setNeedsDisplay];
    
}

#pragma mark - Events

- (void)userlogin {
  
    [self getMyCurrencyList];
    
}

- (void)userloginOut
{
    if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"$ %@", @"0.00"];
    }else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
    {
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %@", @"0.00"];
    }
    else{
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %@", @"0.00"];
    }
    
}

//                个人钱包余额查询
- (void)queryCenterTotalAmount {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        self.currencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];

        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountUSD"] convertToSimpleRealMoney];
            if (![self.IsLocalExsit isEqualToString:@"1"]) {
                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"$ %.2f", [cnyStr doubleValue]];

            }
            self.headerView.privateMoney.text = [NSString stringWithFormat:@"$ %.2f", [cnyStr doubleValue]];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"总资产" key:nil]];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"个人账户" key:nil]];
            [self.headerView setNeedsDisplay];
            
        } else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountKRW"] convertToSimpleRealMoney];
            if (![self.IsLocalExsit isEqualToString:@"1"]) {
                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %.2f", [cnyStr doubleValue]];
                
            }
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %.2f", [cnyStr doubleValue]];

            self.headerView.privateMoney.text = [NSString stringWithFormat:@"₩ %.2f", [cnyStr doubleValue]];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(KRW)", [LangSwitcher switchLang:@"总资产" key:nil]];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(KRW)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(KRW)", [LangSwitcher switchLang:@"个人账户" key:nil]];
            [self.headerView setNeedsDisplay];
            
        }
        
        else{
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
            if (![self.IsLocalExsit isEqualToString:@"1"]) {
                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
                
            }
            self.headerView.privateMoney.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"总资产" key:nil]];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"个人账户" key:nil]];
            [self.headerView setNeedsDisplay];

        }
        
    } failure:^(NSError *error) {
        
        
    }];
}


- (void)queryTotalAllAmount {
    
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"QSount.caf" ofType:nil];
    
    NSLog(@"%@",audioFile);
    //    [self.currentTableView beginRefreshing];
    TLNetworking *http = [TLNetworking new];
    http.code = @"802270";
    http.isLocal = YES;
    http.isUploadToken = NO;
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *symbol;
    NSString *address;
    NSMutableArray *arr = [NSMutableArray array];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            symbol = [set stringForColumn:@"symbol"];
            address = [set stringForColumn:@"address"];
            
            if (!address) {
                [dic setObject:@"" forKey:@"address"];
                
            }else{
                [dic setObject:address forKey:@"address"];
            }
            [dic setObject:symbol forKey:@"symbol"];
            [arr addObject:dic];
        }
        [set close];
    }
    [dataBase.dataBase close];
    
    NSSet *set = [NSSet setWithArray:arr];
    NSArray *resultArray = [set allObjects];
    http.parameters[@"accountList"] = resultArray;
    CoinWeakSelf;
    
    [http postWithSuccess:^(id responseObject) {
       weakSelf.allCurrencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
        self.IsLocalExsit = @"1";
        
        if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
            cnyStr = [responseObject[@"data"][@"totalAmountUSD"] convertToSimpleRealMoney];
            double f =  [cnyStr doubleValue] +[[self.headerView.privateMoney.text substringFromIndex:1] doubleValue] ;
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"$ %.2f", f] ;
            self.headerView.LocalMoney.text = [NSString stringWithFormat:@"$ %.2f", [cnyStr doubleValue]];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];;
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"个人账户" key:nil]];;
            
            NSArray *usdStr = responseObject[@"data"][@"accountList"];
            self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"总资产" key:nil]];;
            [self.headerView setNeedsDisplay];
            
        } else if ([[TLUser user].localMoney isEqualToString:@"KRW"])
        {
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountKRW"] convertToSimpleRealMoney];
            if (![self.IsLocalExsit isEqualToString:@"1"]) {
                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %.2f", [cnyStr doubleValue]];
                
                
            }
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %.2f", [cnyStr doubleValue]];
            
            double f =  [cnyStr doubleValue] +[[self.headerView.privateMoney.text substringFromIndex:1] doubleValue] ;
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"₩ %.2f", f] ;
            self.headerView.LocalMoney.text = [NSString stringWithFormat:@"₩ %.2f", [cnyStr doubleValue]];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(KRW)", [LangSwitcher switchLang:@"总资产" key:nil]];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(KRW)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(KRW)", [LangSwitcher switchLang:@"个人账户" key:nil]];
            [self.headerView setNeedsDisplay];
            
        }
        else
        {
            double f =  [cnyStr doubleValue]+[[self.headerView.privateMoney.text substringFromIndex:1] doubleValue] ;
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", f];
            self.headerView.LocalMoney.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"总资产" key:nil]];
            
            NSArray *usdStr = responseObject[@"data"][@"accountList"];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"个人账户" key:nil]];
            self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
            
            NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
            
            self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
            [self.headerView setNeedsDisplay];
            
            
        }
        self.localCurrencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        
        if (self.switchTager == 0) {
            self.tableView.platforms = self.localCurrencys;
            [self.tableView reloadData];
        }



    } failure:^(NSError *error) {
        
    }];
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
        if (objs.count == 0) {
            [weakSelf.headerView tapClick:nil];
        }
        weakSelf.rates = objs;
        if (objs.count > 0) {
            weakSelf.headerView.usdRate = weakSelf.rates[0].smsTitle;
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
