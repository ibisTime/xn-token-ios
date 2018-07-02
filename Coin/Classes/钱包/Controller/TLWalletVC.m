//
//  TLWalletVC.m
//  Coin
//
//  Created by  tianlei on 2017/11/06.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWalletVC.h"

#import "CoinHeader.h"

#import "WalletHeaderView.h"
#import "WalletTableView.h"

#import "CurrencyModel.h"

#import "NSString+Extension.h"
#import "NSString+Check.h"

#import "RechargeCoinVC.h"
#import "WithdrawalsCoinVC.h"
#import "BillVC.h"
#import "TLPwdRelatedVC.h"
#import "RateDescVC.h"
#import "ZMAuthVC.h"
#import <CDCommon/UIScrollView+TLAdd.h>
#import "CoinUtil.h"
#import "PlatformTableView.h"
#import "WallAccountVC.h"
#import "AddAccoutMoneyVc.h"
#import "TLAccountTableView.h"
#import <MJExtension/MJExtension.h>
#import "WalletLocalVc.h"
#import "WalletLocalModel.h"
#import "AppConfig.h"
#import "RateModel.h"
#import "BillTableView.h"
#import "WallAccountVC.h"
#import "QRCodeVC.h"
#import "BuildWalletMineVC.h"
#import "CountryModel.h"
#import "countrGroup.h"
//#import <CoreBitcoin.h>
//#import <CoreBitcoin/CoreBitcoin.h>
//#import "BTCMnemonic+Tests.h"
@interface TLWalletVC ()<RefreshDelegate>

@property (nonatomic, strong) WalletHeaderView *headerView;

@property (nonatomic, strong) PlatformTableView *tableView;

@property (nonatomic, strong) TLAccountTableView *currentTableView;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*tempcurrencys;

@property (nonatomic, strong) NSMutableArray <RateModel *>*rates;

@property (nonatomic, strong) TLPageDataHelper *helper;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic,strong) NSMutableArray <CoinModel *>*coins;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;


@property (nonatomic, assign) NSInteger switchTager;
//清除公告 更新UI
@property (nonatomic, assign) BOOL isClear;


@end

@implementation TLWalletVC

- (void)viewWillAppear:(BOOL)animated {
//    [self queryTotalAmount];
    if (self.switchTager == 0 ) {
        [self switchWithTager:1];

//      NSString *file =  [[NSBundle mainBundle] pathForResource:@"country.plist" ofType:nil];
//        NSDictionary *arr = [NSDictionary dictionaryWithContentsOfFile: file];
//        NSLog(@"%@",arr);
       
    }else if (self.switchTager == 1){
        [self switchWithTager:0];

    }
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
//    [BTCMnemonic runAllTests];
//
//    BTCMnemonic *m = [[BTCMnemonic alloc] init];
//    NSLog(@"%@",m.words);
    
    //tableView
    [self.view addSubview:self.headerView];

    [self initTableView];
    //通知
    [self addNotification];
    //列表查询我的币种
    [self getMyCurrencyList];
    [self refreshOpenCoinList];
    [self requestRateList];
   
    
//    self.tableView.backgroundColor = [UIColor themeColor];
    
}


- (void)getLocalWalletMessage
{
    //获取本地去中心化币种
    
    
    
    
    //获取我的资产
    [self queryMyAmount];
   

    [self queryTotalAmount];
    //本地读取数据

    
    
}

- (void)refreshOpenCoinList {
    [CoinUtil refreshOpenCoinList:^{
        
    } failure:^{
        
    }];
}

#pragma mark - Init

- (WalletHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;
        
        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(250 + kStatusBarHeight+20) )];
//        _headerView.usdRate = @"test";

//        _headerView.whiteView.hidden = YES;
        
        _headerView.clearBlock = ^{
            weakSelf.isClear = YES;
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenWidth, kHeight(250 + kStatusBarHeight) );
            [weakSelf.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.view.mas_left).offset(15);
                make.top.equalTo(weakSelf.headerView.mas_bottom).offset(8);
                make.width.equalTo(@(kWidth(167.5)));
                make.height.equalTo(@(kHeight(50)));
                
            }];
            
            
            [weakSelf.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.leftButton.mas_right).offset(10);
                make.top.equalTo(weakSelf.headerView.mas_bottom).offset(8);
                make.width.equalTo(@(kWidth(167.5)));
                make.height.equalTo(@(kHeight(50)));
                
            }];
              weakSelf.currentTableView.frame = CGRectMake(0, kHeight(318)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
              weakSelf.tableView.frame = CGRectMake(0, kHeight(318)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
            [weakSelf.view setNeedsLayout];
        };
        //切换钱包事件
        _headerView.switchBlock = ^(NSInteger teger) {
            [weakSelf switchWithTager:teger];
        };
        //点击二维码事件
        
        _headerView.codeBlock = ^{
            QRCodeVC *qrCodeVC = [QRCodeVC new];
            
            qrCodeVC.scanSuccess = ^(NSString *result) {
                
//                weakSelf.receiveAddressLbl.text = result;
//                weakSelf.receiveAddressLbl.textColor = kTextColor;
//                weakSelf.addressType = WalletAddressTypeScan;
                //                [weakSelf setGoogleAuth];
                
            };
            
            [weakSelf.navigationController pushViewController:qrCodeVC animated:YES];
        };
        //点击公告事件
        _headerView.headerBlock = ^{
            
            RateDescVC *descVC = [RateDescVC new];
            [weakSelf.navigationController pushViewController:descVC animated:YES];
        };
        
        _headerView.addBlock = ^{
            AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
            monyVc.currentModels = weakSelf.currencys;
            [weakSelf.navigationController pushViewController:monyVc animated:YES];
            
            weakSelf.tempcurrencys = [NSMutableArray array];
            monyVc.select = ^(NSMutableArray *model) {
//                weakSelf.currencys = model;
//                weakSelf.currencys = [NSMutableArray array];
//                for (CurrencyModel *m in model) {
//                    if (m.IsSelected == YES) {
//                        [weakSelf.currencys addObject:m];
//                    }
//                }
//                weakSelf.currentTableView.platforms = nil;
//                [weakSelf.currentTableView reloadData];
//
//                weakSelf.currentTableView.platforms = weakSelf.currencys;
////                [weakSelf.currentTableView beginRefreshing];
//                [weakSelf.currentTableView reloadData];
//                [weakSelf ]
                weakSelf.switchTager = 1;

//                [weakSelf switchWithTager:0];
                NSLog(@"%@",model);
            };
            
            NSLog(@"点击添加");
        };
        
    }
    return _headerView;
}

- (void)initLocalTableView {
    
    CGFloat f = self.isClear == YES ?318 : 338;

   
    self.currentTableView = [[TLAccountTableView alloc] initWithFrame:CGRectMake(0, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354)) style:UITableViewStyleGrouped];
    
    
//    self.currentTableView.tableHeaderView = [UIView new];
//    self.currentTableView.tableFooterView = [UIView new];
 
    self.currentTableView.refreshDelegate = self;
//    self.currentTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector (loadMore)];
//    self.currentTableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector (loadBottom)];;

//    self.currentTableView.mj_header = [MJRefreshHeader]
//    [self.tableView adjustsContentInsets];
    [self.view addSubview:self.currentTableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerView.mas_bottom);
//    }];
    CoinWeakSelf;
    self.currentTableView.selectBlock = ^(NSInteger inter) {
        NSLog(@"%ld",inter);
        weakSelf.switchTager = 1;

        WalletLocalVc *accountVC= [[WalletLocalVc alloc] init];
        accountVC.currency = weakSelf.currencys[inter];
        accountVC.billType = LocalTypeAll;
        [weakSelf.navigationController pushViewController:accountVC animated:YES];
        
        
    };
}
- (void)initTableView {
    self.leftButton = [UIButton buttonWithTitle:@"闪兑" titleColor:kHexColor(@"#333333") backgroundColor:kWhiteColor titleFont:15.0];
    [self.leftButton setImage:kImage(@"闪兑") forState:UIControlStateNormal];
    self.rightButton = [UIButton buttonWithTitle:@"一键划转" titleColor:kHexColor(@"#333333") backgroundColor:kWhiteColor titleFont:15.0];
    [self.rightButton setImage:kImage(@"一键划转") forState:UIControlStateNormal];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    [self.leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.width.equalTo(@(kWidth(167.5)));
        make.height.equalTo(@(kHeight(50)));
        
    }];
    
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right).offset(10);
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.width.equalTo(@(kWidth(167.5)));
        make.height.equalTo(@(kHeight(50)));
        
    }];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    CGFloat f = self.isClear == YES ?318 : 338;

    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectMake(0, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354)) style:UITableViewStyleGrouped];
    
    
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    CoinWeakSelf;
    self.tableView.selectBlock = ^(NSInteger inter) {
        NSLog(@"%ld",inter);
        WallAccountVC *accountVC= [[WallAccountVC alloc] init];
        accountVC.currency = weakSelf.currencys[inter];
        accountVC.billType = CurrentTypeAll;
        [weakSelf.navigationController pushViewController:accountVC animated:YES];
        
        
    };
}
- (void)switchWithTager: (NSInteger)tager
{

    if (tager == 1) {
        [self.leftButton setImage:kImage(@"闪兑") forState:UIControlStateNormal];
        [self.rightButton setImage:kImage(@"一键划转") forState:UIControlStateNormal];
        [self initTableView];

        [self.currentTableView.platforms removeAllObjects];
        [self.currencys removeAllObjects];
        [self.currentTableView reloadData];
       

        [self getMyCurrencyList];
        self.switchTager = tager;


    }else{
        self.switchTager = tager;

        //切换秘钥钱包 需要查询用户是否已经创建完钱包
        [self checkUserLocalWallet];
        
        
       
       
        
    }
    //切换中心钱包和本地化钱包
    
}

- (void)checkUserLocalWallet
{
   // 1 去本地数据库查询用户记录是否存在
    
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *Mnemonics;
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT Mnemonics from THAWallet where userId = '%@'",[TLUser user].userId];
//        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
            {
             Mnemonics = [set stringForColumn:@"Mnemonics"];
        
            }
        [set close];
    }
    [dataBase.dataBase close];
    
    if (Mnemonics.length > 0) {
        [self.leftButton setImage:kImage(@"闪兑-秘钥") forState:UIControlStateNormal];
        [self.rightButton setImage:kImage(@"划转-秘钥") forState:UIControlStateNormal];
        
        [self.tableView.platforms removeAllObjects];
        [self.currencys removeAllObjects];
        [self.tableView reloadData];
        [self.tableView removeFromSuperview];
        [self initLocalTableView];
        [self saveLocalWalletData];
        [self saveLocalWallet];

        [self getLocalWalletMessage];

        //已存在
        return;
    }
    // 2不存在就创建
    self.switchTager = 0;
    CoinWeakSelf;
    BuildWalletMineVC *MineVC = [[BuildWalletMineVC alloc] init];
        MineVC.walletBlock  = ^{
            [weakSelf.headerView swipeBottomClick:nil];

        };
    [self.navigationController pushViewController:MineVC animated:YES];
    [self.tableView.platforms removeAllObjects];
    [self.currencys removeAllObjects];
    [self.tableView reloadData];
    [self.tableView removeFromSuperview];
    self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", 0.00];
    self.headerView.privateMoney.text = [NSString stringWithFormat:@"¥ %.2f", 0.00];
    self.headerView.LocalMoney.text = [NSString stringWithFormat:@"¥ %.2f", 0.00];
//    TLNavigationController *na = [[TLNavigationController alloc] initWithRootViewController:MineVC];
//    [UIApplication sharedApplication].keyWindow.rootViewController = na;
//    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"创建私钥钱包" key:nil]
//                        msg:nil
//                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
//                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
//                     cancle:^(UIAlertAction *action) {
//                         [self.leftButton setImage:kImage(@"闪兑-秘钥") forState:UIControlStateNormal];
//                         [self.rightButton setImage:kImage(@"划转-秘钥") forState:UIControlStateNormal];
//
//                         [self.tableView.platforms removeAllObjects];
//                         [self.currencys removeAllObjects];
//                         [self.tableView reloadData];
//                         [self.tableView removeFromSuperview];
//                         self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", 0.00];
//                         self.headerView.privateMoney.text = [NSString stringWithFormat:@"¥ %.2f", 0.00];
//                         self.headerView.LocalMoney.text = [NSString stringWithFormat:@"¥ %.2f", 0.00];
//
//                     } confirm:^(UIAlertAction *action) {
//
//                     }];
//
    
}
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userlogin) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withDrawCoinSuccess) name:kWithDrawCoinSuccess object:nil];
}

- (void)saveLocalWallet
{

     NSString *totalcount;
    TLDataBase *data = [TLDataBase sharedManager];

    if ([data.dataBase open]) {
        //            [db executeUpdate:@"create table if not exists LocalWallet(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"];
        NSString *sql = [NSString stringWithFormat:@"SELECT next from LocalWallet lo, THAWallet th where lo.walletId = th.walletId  and th.userId = '%@'",[TLUser user].userId];
        FMResultSet *set = [data.dataBase executeQuery:sql];
        while ([set next]) {
            
            totalcount = [set stringForColumn:@"next"];
     }
        [set close];
    }
    [data.dataBase close];
    if ([totalcount integerValue] == self.coins.count) {
        return;
    }
    if ([totalcount integerValue] > 0) {
        TLDataBase *db = [TLDataBase sharedManager];
        
        if ([db.dataBase open]) {
            NSString *Sql2 =[NSString stringWithFormat:@"delete from LocalWallet WHERE walletId = (SELECT walletId from THAWallet where userId='%@')",[TLUser user].userId];
            
            BOOL sucess2  = [db.dataBase executeUpdate:Sql2];
            NSLog(@"更新自选表%d",sucess2);
        }
        [db.dataBase close];
    }
    for (int i = 0; i < self.coins.count; i++) {
        
        CoinModel *model = self.coins[i];
        TLDataBase *dateBase = [TLDataBase sharedManager];
        if ([dateBase.dataBase open]) {
//            [db executeUpdate:@"create table if not exists LocalWallet(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"];
            BOOL sucess = [dateBase.dataBase executeUpdate:@"INSERT INTO  LocalWallet(walletId,symbol,type,status,cname,unit,pic1,withdrawFeeString,withfrawFee,orderNo,ename,icon,pic2,pic3,address,IsSelect,next) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.walletId,model.symbol,model.type,model.status,model.cname,model.unit,model.pic1,model.withdrawFeeString,model.withfrawFee,model.orderNo,model.ename,model.icon,model.pic2,model.pic3,model.address,[NSNumber numberWithBool:YES],[NSString stringWithFormat:@"%ld",self.coins.count]];
            
            NSLog(@"插入币种表%d",sucess);
        }
        [dateBase.dataBase close];
    }
    
    //插入币种表
    
    
    
}

- (void)getMyCurrencyList {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
    helper.isList = YES;
    helper.isCurrency = YES;
    helper.tableView = self.tableView;
    [helper modelClass:[CurrencyModel class]];
    [self.tableView addRefreshAction:^{
        
        [weakSelf refreshOpenCoinList];
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            //去除没有的币种
            
            
            NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                CurrencyModel *currencyModel = (CurrencyModel *)obj;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
                
                [shouldDisplayCoins addObject:currencyModel];
                //                }
                
            }];
            
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.tableView.platforms = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
      
        //查询总资产
        [weakSelf queryCenterTotalAmount];
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        helper.parameters[@"userId"] = [TLUser user].userId;
        helper.parameters[@"token"] = [TLUser user].token;
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            //去除没有的币种
            
            
            NSMutableArray <CurrencyModel *> *shouldDisplayCoins = [[NSMutableArray alloc] init];
            [objs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CurrencyModel *currencyModel = (CurrencyModel *)obj;
                //                if ([[CoinUtil shouldDisplayCoinArray] indexOfObject:currencyModel.currency ] != NSNotFound ) {
                
                [shouldDisplayCoins addObject:currencyModel];
                //                }
                
            }];
            
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.tableView.platforms = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.tableView beginRefreshing];
    
}
- (void)saveLocalWalletData
{
    NSMutableArray *arr = [[CoinModel coin] getOpenCoinList];
    NSMutableArray *temp = arr.mutableCopy;
    TLDataBase *db = [TLDataBase sharedManager];
    for (int i = 0; i < temp.count; i++) {
        NSString *symbol;
        NSString *key;

        CoinModel *model = temp[i];
        if ([model.type isEqualToString:@"0"]) {
            symbol = [model.symbol lowercaseString];
        }else if ([model.type isEqualToString:@"1"])
        {
            symbol = @"eth";

        }else{
            
            symbol = @"wan";
        }
   
    if ([db.dataBase open]) {
          NSString *sql = [NSString stringWithFormat:@"SELECT %@address,walletId from THAWallet where userId = '%@'",symbol,[TLUser user].userId];
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

- (void)loadNotiction
{
    TLPageDataHelper *http = [TLPageDataHelper new];
    http.code = @"804040";
    http.parameters[@"channelType"] = @4;
    http.parameters[@"status"] = @1;
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"10";
    http.isList = YES;

  

    
}
- (void)loadBottom
{
    
    
}


#pragma mark - Events

- (void)userlogin {
    
    [self getMyCurrencyList];
    
}

- (void)withDrawCoinSuccess {
    
//    [self getMyCurrencyList];
    
}
- (void)queryCenterTotalAmount {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        
        //        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
        
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", [responseObject[@"data"][@"totalAmountCNY"] doubleValue]];
        self.headerView.privateMoney.text = [NSString stringWithFormat:@"¥ %.2f", [responseObject[@"data"][@"totalAmountCNY"] doubleValue]];
        
        
        //        NSString *usdStr = [responseObject[@"data"][@"totalAmountUSD"] convertToSimpleRealMoney];
        
        //        self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
        //
        //        NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
        
        //        self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)queryMyAmount
{
    TLNetworking *http = [TLNetworking new];
    http.code = @"802270";
    http.isLocal = YES;
    http.isUploadToken = NO;
    //获取私钥钱包余额
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *symbol;
    NSString *address;
    NSMutableArray *arr = [NSMutableArray array];

    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from LocalWallet lo, THAWallet th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
        //        [sql appendString:[TLUser user].userId];
        FMResultSet *set = [dataBase.dataBase executeQuery:sql];
        while ([set next])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            symbol = [set stringForColumn:@"symbol"];
            address = [set stringForColumn:@"address"];
            
            [dic setObject:symbol forKey:@"symbol"];
            if (!address) {
                [dic setObject:@"" forKey:@"address"];

            }else{
                
                [dic setObject:address forKey:@"address"];

            }
            [arr addObject:dic];
        }
        [set close];
    }
    [dataBase.dataBase close];
    
//    NSArray *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"localArray"];
    if (arr.count > 0) {
                http.ISparametArray = YES;
        
        http.parameters[@"accountList"] = arr;
    }
    
    
    //    http.parametArray = @[ dic];
    
    CoinWeakSelf;
        [http postWithSuccess:^(id responseObject) {
    
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
    
            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
             self.headerView.LocalMoney.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
            
            NSArray *usdStr = responseObject[@"data"][@"accountList"];
    
//            weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
    
            NSLog(@"%@",self.currencys);
    
//            weakSelf.currentTableView.platforms = weakSelf.currencys;
//            [weakSelf.currentTableView reloadData_tl];
            self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
    
            NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
    
            self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
    
        } failure:^(NSError *error) {
    
            [self.currentTableView endRefreshingWithNoMoreData_tl];
    
        }];
    
}

#pragma mark - Data
- (void)queryTotalAmount {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"QSount.caf" ofType:nil];

    NSLog(@"%@",audioFile);
//    [self.currentTableView beginRefreshing];
    TLPageDataHelper *http = [TLPageDataHelper new];
    http.code = @"802270";
    http.isLocal = YES;
    http.isUploadToken = NO;
    TLDataBase *dataBase = [TLDataBase sharedManager];
    NSString *symbol;
    NSString *address;
    NSMutableArray *arr = [NSMutableArray array];
    if ([dataBase.dataBase open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from LocalWallet lo, THAWallet th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
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
    
    //    NSArray *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"localArray"];
    if (arr.count > 0) {
        
        http.parameters[@"accountList"] = arr;
    }

//    http.parametArray = @[ dic];

    CoinWeakSelf;
    http.isList = YES;
    http.isCurrency = YES;
    http.tableView = self.currentTableView;
    [http modelClass:[CurrencyModel class]];

    [self.currentTableView addRefreshAction:^{
        [http refresh:^(NSMutableArray *objs, BOOL stillHave) {
            weakSelf.currencys = objs;
            weakSelf.currentTableView.platforms = weakSelf.currencys;
            [weakSelf.currentTableView reloadData_tl];
            NSLog(@"%@",objs);
            [weakSelf.currentTableView endRefreshingWithNoMoreData_tl];
            [weakSelf queryMyAmount];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.currentTableView beginRefreshing];
    [self.currentTableView addLoadMoreAction:^{
        http.isUploadToken = NO;

        [http loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (weakSelf.tl_placeholderView.superview != nil) {
                
                [weakSelf removePlaceholderView];
            }
            [weakSelf queryMyAmount];
            weakSelf.currencys = objs;
            
            weakSelf.currentTableView.platforms = objs;
            [weakSelf.currentTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];
            
        }];
        
    }];
    
//    [http postWithSuccess:^(id responseObject) {
//
//        NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
//
//        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"%.2f", [cnyStr doubleValue]];
//
//        NSArray *usdStr = responseObject[@"data"][@"accountList"];
//
//        weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
//
//        NSLog(@"%@",self.currencys);
//
//        weakSelf.currentTableView.platforms = weakSelf.currencys;
//        [weakSelf.currentTableView reloadData_tl];
//        self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
//
//        NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];

//        self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
//
//    } failure:^(NSError *error) {
//
//        [self.currentTableView endRefreshingWithNoMoreData_tl];
//
//    }];
}



- (void)searchRateWithCurrency:(NSString *)currency {
    
    TLNetworking *http = [TLNetworking new];
    http.isLocal = YES;
    http.code = @"625280";
    
    http.parameters[@"currency"] = currency;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([currency isEqualToString:@"USD"]) {
            
//            self.headerView.usdRate = @"test";
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)requestRateList {
    
    CoinWeakSelf;
    TLPageDataHelper *help = [[TLPageDataHelper alloc] init];
    //    help.isList = YES;
    
    //    help.parameters[@"channelType"] = @4;
    help.parameters[@"channelType"] = @4;
    help.parameters[@"toSystemCode"] = [AppConfig config].systemCode;
    help.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
        help.parameters[@"start"] = @"1";
//    help.isLocal = YES;
    help.parameters[@"limit"] = @"10";
    help.code = @"804040";
    help.isUploadToken = NO;
    //    helper.parameters[@"coin"] = self.coinName;
        [help modelClass:[RateModel class]];
    
        [help refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.rates = objs;
            
            if (objs.count > 0) {
                weakSelf.headerView.usdRate = weakSelf.rates[0].smsTitle;
            }
        } failure:^(NSError *error) {
            
            
        }];
    
    
}
#pragma mark - RefreshDelegate
- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    CoinWeakSelf;
    
    NSInteger tag = (sender.tag - 1200)%100;
    
    CurrencyModel *currencyModel = self.currencys[index];
    
    switch (tag) {
        case 0:
        {
            RechargeCoinVC *coinVC = [RechargeCoinVC new];
            coinVC.currency = currencyModel;
            [self.navigationController pushViewController:coinVC animated:YES];
            
        }break;
            
        case 1:
        {
            [self clickWithdrawWithCurrency:currencyModel];
            
        }break;
            
        case 2:
        {
            
            BillVC *billVC = [BillVC new];
            billVC.accountNumber = currencyModel.accountNumber;
            billVC.billType = BillTypeAll;
            [self.navigationController pushViewController:billVC animated:YES];
            
        }break;
            
        case 3:
        {
            
            BillVC *billVC = [BillVC new];
            billVC.accountNumber = currencyModel.accountNumber;
            billVC.billType = BillTypeFrozen;
            [self.navigationController pushViewController:billVC animated:YES];
            
        }break;
            
        default:
            break;
    }
}

-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)clickWithdrawWithCurrency:(CurrencyModel *)currencyModel {
    
    CoinWeakSelf;
    
    //判断是否认证身份
    if (![[TLUser user].realName valid]) {
        
        ZMAuthVC *zmAuthVC = [ZMAuthVC new];
        
        zmAuthVC.title = [LangSwitcher switchLang:@"实名认证" key:nil];
        
        zmAuthVC.success = ^{
            
            //实名认证成功后，判断是否设置资金密码
            if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
                
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"实名认证成功, 请设置资金密码" key:nil]];
                
            } else {
                
                [TLAlert alertWithInfo:[LangSwitcher switchLang:@"实名认证成功" key:nil]];
            }
            
            [weakSelf clickWithdrawWithCurrency:currencyModel];
            
        };
        
        [self.navigationController pushViewController:zmAuthVC animated:YES];
        
        return ;
    }
    
    //实名认证成功后，判断是否设置资金密码
    if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
        
        TLPwdType pwdType = TLPwdTypeSetTrade;
        TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
        pwdRelatedVC.isWallet = YES;
        pwdRelatedVC.success = ^{
            
            [weakSelf clickWithdrawWithCurrency:currencyModel];
        };
        [self.navigationController pushViewController:pwdRelatedVC animated:YES];
        return ;
        
    }
    
    WithdrawalsCoinVC *coinVC = [WithdrawalsCoinVC new];
    coinVC.currency = currencyModel;
    [self.navigationController pushViewController:coinVC animated:YES];
}

@end
