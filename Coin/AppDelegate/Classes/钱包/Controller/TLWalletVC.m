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
#import "TLFastvc.h"
#import "TLTransfromVC.h"
#import "BuildLocalHomeView.h"
#import "RevisePassWordVC.h"
#import "WalletImportVC.h"
#import "HTMLStrVC.h"
#import "BuildSucessVC.h"
#import "BuildWalletMineVC.h"
#import "BTCMnemonic.h"
#import "BTCNetwork.h"
#import "BTCData.h"
#import "MnemonicUtil.h"
#import "BTCKeychain.h"
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

@property (nonatomic, strong) TLNetworking *helper;

@property (nonatomic,strong) NSMutableArray <BillModel *>*bills;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic,strong) NSMutableArray <CoinModel *>*coins;

@property (nonatomic,strong) NSMutableArray <CountryModel *>*countrys;

@property (nonatomic, strong) TLNetworking *http;
@property (nonatomic, assign) NSInteger switchTager;
//清除公告 更新UI
@property (nonatomic, assign) BOOL isClear;

@property (nonatomic, copy) NSString *IsLocalExsit;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) BuildLocalHomeView *homeView;

@property (nonatomic, assign) BOOL isBulid;

@end

@implementation TLWalletVC

- (void)viewWillAppear:(BOOL)animated {
  
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    if (word != nil && word.length > 0) {
        BOOL HasChecked =  [[NSUserDefaults standardUserDefaults] boolForKey:KIS170];

        if (HasChecked == YES) {
            return;
        }
        NSArray *words = [word componentsSeparatedByString:@" "];
        
        BTCMnemonic *mnemonic =  [MnemonicUtil importMnemonic:words];
        mnemonic.keychain.network = [BTCNetwork testnet];
        
        NSLog(@"Seed=%@", BTCHexFromData(mnemonic.seed));
        NSLog(@"Mnemonic=%@", mnemonic.words);
        NSLog(@"btc_privateKey=%@", [MnemonicUtil getBtcPrivateKey:mnemonic]);
        //btc_privateKey=L5ggwMgJQh2DfXVME1AMA5hoPACKFQF24i36uDsVMHJUpNPDuodw
        //btc_privateKey=L5ggwMgJQh2DfXVME1AMA5hoPACKFQF24i36uDsVMHJUpNPDuodw
        //btc_privateKey=cW3gQGg9qkiUpxxccQyUXQCs1PViurLi8kBa1eKzrPxV57U7npk1
        NSString *btc_private = [MnemonicUtil getBtcPrivateKey:mnemonic];
        
        NSString *btc_address = [MnemonicUtil getBtcAddress:mnemonic];
        //        NSLog(@"btc_address=%@", [MnemonicUtil getBtcAddress:mnemonic]);
        
        //助记词存在 新增btc地址
        TLDataBase *data = [TLDataBase sharedManager];
        if ([data.dataBase open]) {
            //            [db executeUpdate:@"create table if not exists LocalWallet(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"];
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
        
//        [self switchWithTager:0 ];
        
//        [super viewWillAppear:animated];
//        [self.navigationController setNavigationBarHidden:YES animated:animated];
//        return;
    }else{
        
       
        if (self.isBulid == YES) {
            [self switchWithTager:0 ];

        }else{
//            [self.headerView swipeBottomClick:nil];
//            [self switchWithTager:1 ];

        }
//   [self inreoduceView:@"个人账户" content:@"个人账户就是指中心化钱包,是由THA替您保管私钥,在中心化钱包中,不存在钱包丢失了无法找回的情况,可以通过身份证找回您的钱包,并且可以让您体验到更多的服务。"];
    }
    
  


}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包";
//    [BTCMnemonic runAllTests];
//
//    BTCMnemonic *m = [[BTCMnemonic alloc] init];
//    NSLog(@"%@",m.words);
    self.view.backgroundColor = kWhiteColor;
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
    
    
    
    [self queryCenterTotalAmount];
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
        CGFloat f1 = kDevice_Is_iPhoneX ==YES ? 20 : 20;
//        CGFloat f = self.isClear == YES ?308 : 348;

        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(250 + f1) )];
//        _headerView.usdRate = @"test";

//        _headerView.whiteView.hidden = YES;
        
        
        _headerView.centerBlock = ^{
             [weakSelf inreoduceView:@"个人账户" content:@"个人账户就是指中心化钱包,是由THA替您保管私钥,在中心化钱包中,不存在钱包丢失了无法找回的情况,可以通过身份证找回您的钱包,并且可以让您体验到更多的服务。"];
        };
        
        _headerView.localBlock = ^{
             [weakSelf inreoduceView:@"私钥钱包" content:@"私钥钱包就是去中心化钱包,在去中心化钱包中,所有的用户身份验证内容,如交易密码,私钥，助记词等都保存在用户手机本地,并不是保存在中心化服务器里面,如果用户误删钱包,忘记备份私钥或者助记词，将无法找到钱包"];
        };
        _headerView.clearBlock = ^{
            CGFloat f2 = kDevice_Is_iPhoneX ==YES ? 282 : 260;
            weakSelf.isClear = YES;
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenWidth, kHeight(250-10 ) );
            [weakSelf.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.view.mas_left).offset(15);
                make.top.equalTo(weakSelf.headerView.mas_bottom).offset(15);
                make.width.equalTo(@(kWidth(167.5)));
                make.height.equalTo(@(kHeight(50)));
            }];
            
            
            [weakSelf.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.leftButton.mas_right).offset(10);
                make.top.equalTo(weakSelf.headerView.mas_bottom).offset(15);
                make.width.equalTo(@(kWidth(167.5)));
                make.height.equalTo(@(kHeight(50)));
                
            }];
            
            [weakSelf.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(kHeight(320-30)));
                make.right.equalTo(@-15);
                make.left.equalTo(@15);
                make.height.equalTo(@30);
            }];
            CGFloat f = self.isClear == YES ?348-30 : 358-30;

            CGFloat f1 = kDevice_Is_iPhoneX == YES ?15 :0;

              weakSelf.currentTableView.frame = CGRectMake(0, kHeight(f), kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(308));
              weakSelf.tableView.frame = CGRectMake(0, kHeight(f), kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(308));
            [weakSelf.view setNeedsLayout];
        };
        //切换钱包事件
        
        _headerView.switchBlock = ^(NSInteger teger) {
            [weakSelf switchWithTager:teger];

        };
//        _headerView.switchBlock = ^(NSInteger teger) {
//        };
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

                [weakSelf switchWithTager:0];
                NSLog(@"%@",model);
            };
            
            NSLog(@"点击添加");
        };
        
    }
    return _headerView;
}

- (void)inreoduceView: (NSString *)name content: (NSString *)contents
{
    
    UIView *contentView = [[UIView alloc] init];
    
    UIView *contentText = [UIView new];
    
    [contentView addSubview:contentText];
    contentText.backgroundColor = kWhiteColor;
    [contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.equalTo(@(kWidth(325)));
        make.height.equalTo(@(kWidth(314)));


    }];
    
    UILabel *title = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:20.0];
    
    [contentText addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentText.mas_top).offset(40);
        make.centerX.equalTo(contentText.mas_centerX);
//        make.width.equalTo(@(kWidth(325)));
//        make.height.equalTo(@(kWidth(336)));
        
        
    }];
    title.text = [LangSwitcher switchLang:name key:nil];
    
    UILabel *content = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    content.numberOfLines = 0;
    [contentText addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(title.mas_bottom).offset(23);
//        make.centerX.equalTo(contentText.mas_centerX);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);

        //        make.width.equalTo(@(kWidth(325)));
        //        make.height.equalTo(@(kWidth(336)));
        
        
    }];
    
    content.text = [LangSwitcher switchLang:contents key:nil];
    
    UIButton *sureButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"确定" key:nil] titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16];
    
    [contentText addSubview:sureButton];
    sureButton.layer.cornerRadius = 4.0;
    sureButton.clipsToBounds = YES;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(contentText.mas_bottom).offset(-30);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@50);
        
        
    }];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:contentView];
    contentView.frame = [UIScreen mainScreen].bounds;
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:0.3];

}

- (void)sureClick
{
    
    self.contentView.hidden = YES;
    
}

- (void)initLocalTableView {
    
    
    CGFloat f = self.isClear == YES ?328-30 : 358-30;
    CGFloat f1 = kDevice_Is_iPhoneX == YES ?15 :0;
    CGFloat f3 = self.isClear == YES ?334-30 : 354-30;
    CGFloat f4 = self.isClear == YES ?320-30 : 350-30;

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(f4)));
        make.right.equalTo(@-15);
        make.left.equalTo(@15);
        make.height.equalTo(@30);
    }];
    f = f - f1;
    self.currentTableView = [[TLAccountTableView alloc] initWithFrame:CGRectMake(0, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - 49 - kHeight(f3)) style:UITableViewStyleGrouped];
    self.currentTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);

    self.currentTableView.backgroundColor = kWhiteColor;
//    self.currentTableView.tableHeaderView = self.titleView;
//    self.currentTableView.tableHeaderView.height = 40;

    self.addButton.hidden = NO;
    
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
    [self.titleView removeFromSuperview];
    self.leftButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"闪兑" key:nil] titleColor:kHexColor(@"#333333") backgroundColor:kWhiteColor titleFont:14.0];
    [self.leftButton setImage:kImage(@"闪兑") forState:UIControlStateNormal];
    self.leftButton.layer.borderWidth = 0.3;
    self.leftButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
    self.rightButton = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"一键划转" key:nil] titleColor:kHexColor(@"#333333") backgroundColor:kWhiteColor titleFont:14.0];
    [self.rightButton setImage:kImage(@"一键划转") forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(fast) forControlEvents:UIControlEventTouchUpInside];
      [self.rightButton addTarget:self action:@selector(transNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    self.titleView = [[UIView alloc] init];
    [self.view addSubview:self.titleView];
    self.titleView.backgroundColor = kWhiteColor;
    CGFloat f4 = self.isClear == YES ?320-30 : 350-30;

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kHeight(f4)));
        make.right.equalTo(@-15);
        make.left.equalTo(@15);
        make.height.equalTo(@30);
    }];
    UILabel *text = [UILabel labelWithBackgroundColor:kWhiteColor textColor:kTextBlack font:16];
    text.text = [LangSwitcher switchLang:@"币种列表" key:nil];
    text.frame = CGRectMake(10, 4, 200, 22);
    [self.titleView addSubview:text];
//    self.titleView.userInteractionEnabled = YES;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    
//    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCurrent)];
//
//    [self.titleView addGestureRecognizer:ta];
    
    [addButton setImage:kImage(@"增加") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addCurrent) forControlEvents:UIControlEventTouchUpInside];
    addButton.backgroundColor = kClearColor;
    [self.titleView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_top).offset(4);
//        make.centerX.equalTo(self.titleView.mas_centerX);
        
        make.right.equalTo(self.titleView.mas_right).offset(-10);
//        make.bottom.equalTo(self.view.mas_bottom).offset(15);
        make.width.height.equalTo(@20);
        
    }];
    self.addButton.hidden= YES;

//    addButton.hidden = YES;
    self.rightButton.layer.borderWidth = 0.3;
    self.rightButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.width.equalTo(@(kWidth(167.5)));
        make.height.equalTo(@(kHeight(40)));
        
    }];
    
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right).offset(10);
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.width.equalTo(@(kWidth(167.5)));
        make.height.equalTo(@(kHeight(40)));
        
    }];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    CGFloat f = self.isClear == YES ?338-30 : 368-30;
    CGFloat f1 = kDevice_Is_iPhoneX == YES ?25 :0;
    f = f - f1;
    CGFloat f3 = self.isClear == YES ?324-30 : 354-30;

//    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(kHeight(f4)));
//        make.right.equalTo(@-15);
//        make.left.equalTo(@15);
//        make.height.equalTo(@30);
//    }];
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectMake(0, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - 49 - kHeight(f3)) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    CoinWeakSelf;
    self.tableView.selectBlock = ^(NSInteger inter) {
        NSLog(@"%ld",inter);
        weakSelf.switchTager = 0;
        weakSelf.isBulid = NO;

        WallAccountVC *accountVC= [[WallAccountVC alloc] init];
        accountVC.currency = weakSelf.currencys[inter];
        accountVC.title = accountVC.currency.currency;
        accountVC.billType = CurrentTypeAll;
        [weakSelf.navigationController pushViewController:accountVC animated:YES];
        
        
    };
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];
    
}

- (void)addCurrent
{
    
    AddAccoutMoneyVc *monyVc = [[AddAccoutMoneyVc alloc] init];
    monyVc.currentModels = self.currencys;
    [self.navigationController pushViewController:monyVc animated:YES];
    
    self.tempcurrencys = [NSMutableArray array];
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
        
        [self switchWithTager:0];
        NSLog(@"%@",model);
    };
    
    NSLog(@"点击添加");
    
}
- (void)switchWithTager: (NSInteger)tager
{

    if (tager == 1) {
//        [self.tabBarController.tabBar setHidden:NO];

        [self.leftButton setImage:kImage(@"闪兑") forState:UIControlStateNormal];
        [self.rightButton setImage:kImage(@"一键划转") forState:UIControlStateNormal];
        self.leftButton.layer.borderWidth = 0.3;

        self.leftButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
        self.rightButton.layer.borderWidth = 0.3;
        self.rightButton.layer.borderColor = kHexColor(@"#ABC0D9").CGColor;
        CGFloat f = self.isClear == YES ?318 : 338;
//        self.contentView.hidden = YES;
//        [self inreoduceView:@"个人账户" content:@"个人账户就是指中心化钱包,是由THA替您保管私钥,在中心化钱包中,不存在钱包丢失了无法找回的情况,可以通过身份证找回您的钱包,并且可以让您体验到更多的服务。"];
//        self.contentView.hidden = NO;

//        [UIView animateWithDuration:0.5 animations:^{
//                 self.currentTableView.frame = CGRectMake(-kScreenWidth, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
////            }else{
////                 self.currentTableView.frame = CGRectMake(kScreenWidth, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
////            }
//
////             self.tableView.frame = CGRectMake(-kScreenWidth, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
//
//        } completion:^(BOOL finished) {
//
        for (UIView *vie in self.view.subviews) {
            if ([vie isKindOfClass:[BuildLocalHomeView class]]) {
                [vie removeFromSuperview];
            }
        }
    
                [self.currentTableView.platforms removeAllObjects];
                [self.currencys removeAllObjects];
                [self.currentTableView reloadData];
       
                [self.currentTableView removeFromSuperview];
                self.tableView.hidden = YES;
                [self.tableView.platforms removeAllObjects];
                [self.tableView reloadData];
                self.currentTableView.hidden = YES;
        

                [self initTableView];

                [self getMyCurrencyList];
                [self queryMyAmount];
                self.switchTager = tager;
        
        

//            }];
      

    }else{
        self.switchTager = tager;

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
        
        if (Mnemonics.length > 0) {
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
            [self.leftButton setImage:kImage(@"闪兑-秘钥") forState:UIControlStateNormal];
            [self.rightButton setImage:kImage(@"划转-秘钥") forState:UIControlStateNormal];
//            [self.tabBarController.tabBar setHidden:NO];

            self.leftButton.layer.borderWidth = 0.3;
            self.leftButton.layer.borderColor = kHexColor(@"#D1B3AB").CGColor;
            self.rightButton.layer.borderWidth = 0.3;
            self.rightButton.layer.borderColor = kHexColor(@"#D1B3AB").CGColor;
            
            CGFloat f = self.isClear == YES ?318 : 338;
            
//            [UIView animateWithDuration:0.5 animations:^{
//                      self.tableView.frame = CGRectMake(-kScreenWidth, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
//                }else{
//                       self.tableView.frame = CGRectMake(kScreenWidth, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
//
//                }
           
                //              self.currentTableView.frame = CGRectMake(-kScreenWidth, kHeight(f)+kStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kHeight(354));
//            } completion:^(BOOL finished) {
                [self.tableView.platforms removeAllObjects];
                [self.currencys removeAllObjects];
                [self.tableView reloadData];
                [self.tableView removeFromSuperview];
                self.tableView.hidden = YES;
                self.currentTableView.hidden = YES;
                
                [self initLocalTableView];
                [self saveLocalWalletData];
                [self saveLocalWallet];
                
                [self getLocalWalletMessage];
//                self.contentView.hidden = YES;
//            if (self.contentView.hidden == NO) {
//                return;
//            }
//                [self inreoduceView:@"私钥账户" content:@"私钥钱包就是去中心化钱包,在去中心化钱包中,所有的用户身份验证内容,如交易密码,私钥，助记词等都保存在用户手机本地,并不是保存在中心化服务器里面,如果用户误删钱包,忘记备份私钥或者助记词，将无法找到钱包"];
//                self.contentView.hidden = NO;

//            }];
            
            
            
            
            
            //已存在
            return;
        }
        // 2不存在就创建
        self.switchTager = 0;
//        CoinWeakSelf;
//        BuildWalletMineVC *MineVC = [[BuildWalletMineVC alloc] init];
//        MineVC.walletBlock  = ^{
//            [weakSelf.headerView swipeBottomClick:nil];
//
//        };
//        [self.navigationController pushViewController:MineVC animated:YES];
        [self.tableView.platforms removeAllObjects];
        [self.currencys removeAllObjects];
        [self.tableView reloadData];
        [self.tableView removeFromSuperview];
//        [self.tabBarController.tabBar setHidden:YES];
        self.homeView = [[BuildLocalHomeView alloc] init];
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;

        [self.view addSubview:self.homeView];
//        self.homeView.contentSize = CGSizeMake(0, 300);
        
        
        self.homeView.backgroundColor = kWhiteColor;
        [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(2);
            make.right.equalTo(@-15);
            make.left.equalTo(@15);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        CoinWeakSelf;
        self.homeView.buildBlock = ^{
            
            weakSelf.navigationController.navigationBar.hidden = NO;
            BuildWalletMineVC *sucessVC = [[BuildWalletMineVC alloc] init];
//            RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
//            sucessVC.title =  [LangSwitcher switchLang:@"创建钱包" key:nil];
            
//            vc.walletBlock = ^{
//                [weakSelf switchWithTager:0];
////                weakSelf.isBulid = NO;
//
//            };
            
            //    vc.title =  NSLocalizedString(@"创建钱包", nil);
            [weakSelf.navigationController pushViewController:sucessVC animated:YES];
            weakSelf.homeView = nil;
//
//            [weakSelf.homeView removeFromSuperview];
            //    [self presentViewController:vc animated:YES completion:nil];
            weakSelf.isBulid = YES;
        };
        self.homeView.importBlock = ^{
            weakSelf.navigationController.navigationBar.hidden = NO;
            
            //    RevisePassWordVC *vc = [[RevisePassWordVC alloc] init];
            //    vc.title =  [LangSwitcher switchLang:@"创建钱包" key:nil];
            //    [self.navigationController pushViewController:vc animated:YES];
            WalletImportVC *vc = [[WalletImportVC alloc] init];
            vc.title =  [LangSwitcher switchLang:@"导入钱包" key:nil];
            vc.walletBlock = ^{
//            [weakSelf switchWithTager:0];
//                weakSelf.isBulid = NO;

            };
            //    vc.title = NSLocalizedString(@"导入钱包", nil);
            [weakSelf.navigationController pushViewController:vc animated:YES];
//            weakSelf.homeView.hidden = YES;
//            [weakSelf.homeView removeFromSuperview];
            weakSelf.isBulid = YES;
            weakSelf.homeView = nil;

            
        };
    }
    //切换中心钱包和本地化钱包
    
}
- (void)fast
{
    //闪兑
    TLFastvc *fast = [TLFastvc new];
    [self.navigationController pushViewController:fast animated:YES];
    
    
}
- (void)transNext
{
    //一键旋转
    TLTransfromVC *trans = [TLTransfromVC new];
    [self.navigationController pushViewController:trans animated:YES];
    
    
}

- (void)checkUserLocalWallet
{
   // 1 去本地数据库查询用户记录是否存在
    
   
//    self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@" %.2f", 0.00];
//    self.headerView.privateMoney.text = [NSString stringWithFormat:@" %.2f", 0.00];
//    self.headerView.LocalMoney.text = [NSString stringWithFormat:@" %.2f", 0.00];
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
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userloginOut) name:kUserLoginOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withDrawCoinSuccess) name:kWithDrawCoinSuccess object:nil];
}

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
                            //            [db executeUpdate:@"create table if not exists LocalWallet(id INTEGER PRIMARY KEY AUTOINCREMENT,walletId text, symbol text, type text ,status text,cname text,unit text,pic1 text,withdrawFeeString text,withfrawFee text,orderNo text,ename text,icon text,pic2 text,pic3 text,address text,IsSelect INTEGER,next text)"];
                            BOOL sucess = [dateBase.dataBase executeUpdate:@"INSERT INTO  THALocal(walletId,symbol,type,status,cname,unit,pic1,withdrawFeeString,withfrawFee,orderNo,ename,icon,pic2,pic3,address,IsSelect,next) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.walletId,model.symbol,model.type,model.status,model.cname,model.unit,model.pic1,model.withdrawFeeString,model.withfrawFee,model.orderNo,model.ename,model.icon,model.pic2,model.pic3,model.address,[NSNumber numberWithBool:YES],[NSString stringWithFormat:@"%ld",self.coins.count]];
                            
                            NSLog(@"插入币种表%d",sucess);
                        }
                        [dateBase.dataBase close];
                    }
                    
                    
                }
//            }
          
        }
        
        return;
    }
    if ([totalcount integerValue] > 0) {
        TLDataBase *db = [TLDataBase sharedManager];
        
        if ([db.dataBase open]) {
            NSString *Sql2 =[NSString stringWithFormat:@"delete from THALocal WHERE walletId = (SELECT walletId from THAUser where userId='%@')",[TLUser user].userId];
            
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
            BOOL sucess = [dateBase.dataBase executeUpdate:@"INSERT INTO  THALocal(walletId,symbol,type,status,cname,unit,pic1,withdrawFeeString,withfrawFee,orderNo,ename,icon,pic2,pic3,address,IsSelect,next) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.walletId,model.symbol,model.type,model.status,model.cname,model.unit,model.pic1,model.withdrawFeeString,model.withfrawFee,model.orderNo,model.ename,model.icon,model.pic2,model.pic3,model.address,[NSNumber numberWithBool:YES],[NSString stringWithFormat:@"%ld",self.coins.count]];
            
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
                //查询总资产
               
            }];
            [weakSelf queryCenterTotalAmount];
            [weakSelf queryMyAmount];
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.tableView.platforms = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
      
       
        
    }];
    [self.tableView beginRefreshing];

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
                //查询总资产
              
            }];
            [weakSelf refreshOpenCoinList];

            [weakSelf queryCenterTotalAmount];
            [weakSelf queryMyAmount];
            //
            weakSelf.currencys = shouldDisplayCoins;
            weakSelf.tableView.platforms = shouldDisplayCoins;
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    
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
  
    self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"%.2f",[self.headerView.LocalMoney.text doubleValue] + [self.headerView.privateMoney.text doubleValue]] ;
    [self.headerView setNeedsDisplay];
    
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

- (void)userloginOut
{
    if ([[TLUser user].localMoney isEqualToString:@"USD"]) {
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"$ %@", @"0.00"];
    }else{
        self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %@", @"0.00"];

        
    }
    
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
        }else{
            NSString *cnyStr = [responseObject[@"data"][@"totalAmountCNY"] convertToSimpleRealMoney];
            if (![self.IsLocalExsit isEqualToString:@"1"]) {
                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
                
            }
//            self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
            self.headerView.privateMoney.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
            self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"总资产" key:nil]];
            self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
            self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"个人账户" key:nil]];
            [self.headerView setNeedsDisplay];

        }
      
        
        
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
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
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
    }else{
        
        return;
    }
    
    
    //    http.parametArray = @[ dic];
    
    CoinWeakSelf;
        [http postWithSuccess:^(id responseObject) {
    
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
                
                //            weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
                
                NSLog(@"%@",self.currencys);
                
                //            weakSelf.currentTableView.platforms = weakSelf.currencys;
                //            [weakSelf.currentTableView reloadData_tl];
                self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
                self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(USD)", [LangSwitcher switchLang:@"总资产" key:nil]];;

                NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
                
                self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@CNY", hkdStr];
                [self.headerView setNeedsDisplay];

            }else
            {
                double f =  [cnyStr doubleValue]+[[self.headerView.privateMoney.text substringFromIndex:1] doubleValue] ;
                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", f];
//                self.headerView.cnyAmountLbl.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
                self.headerView.LocalMoney.text = [NSString stringWithFormat:@"¥ %.2f", [cnyStr doubleValue]];
                self.headerView.equivalentBtn.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"总资产" key:nil]];

                NSArray *usdStr = responseObject[@"data"][@"accountList"];
                self.headerView.localLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"私钥钱包" key:nil]];
                self.headerView.textLbl.text = [NSString stringWithFormat:@"%@(CNY)", [LangSwitcher switchLang:@"个人账户" key:nil]];
                //            weakSelf.currencys   =  [CurrencyModel mj_objectArrayWithKeyValuesArray:usdStr];
                
                NSLog(@"%@",self.currencys);
                
                //            weakSelf.currentTableView.platforms = weakSelf.currencys;
                //            [weakSelf.currentTableView reloadData_tl];
                self.headerView.usdAmountLbl.text = [NSString stringWithFormat:@"%@USD", usdStr];
                
                NSString *hkdStr = [responseObject[@"data"][@"totalAmountHKD"] convertToSimpleRealMoney];
                
                self.headerView.hkdAmountLbl.text = [NSString stringWithFormat:@"%@HKD", hkdStr];
                [self.headerView setNeedsDisplay];

                
            }
        
    
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
        NSString *sql = [NSString stringWithFormat:@"SELECT symbol,address from THALocal lo, THAUser th where lo.walletId = th.walletId  and th.userId = '%@' and lo.IsSelect = 1",[TLUser user].userId];
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
    }else{
        return;
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
        [weakSelf refreshOpenCoinList];

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
    help.parameters[@"status"] = @"1";

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
//            [self clickWithdrawWithCurrency:currencyModel];

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
//- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
//
//    CoinWeakSelf;
//
//    NSInteger tag = (sender.tag - 1200)%100;
//
//    CurrencyModel *currencyModel = self.currencys[index];
//
//    switch (tag) {
//        case 0:
//        {
//            RechargeCoinVC *coinVC = [RechargeCoinVC new];
//            coinVC.currency = currencyModel;
//            [self.navigationController pushViewController:coinVC animated:YES];
//
//        }break;
//
//        case 1:
//        {
//            [self clickWithdrawWithCurrency:currencyModel];
//
//        }break;
//
//        case 2:
//        {
//
//            BillVC *billVC = [BillVC new];
//            billVC.accountNumber = currencyModel.accountNumber;
//            billVC.billType = BillTypeAll;
//            [self.navigationController pushViewController:billVC animated:YES];
//
//        }break;
//
//        case 3:
//        {
//
//            BillVC *billVC = [BillVC new];
//            billVC.accountNumber = currencyModel.accountNumber;
//            billVC.billType = BillTypeFrozen;
//            [self.navigationController pushViewController:billVC animated:YES];
//
//        }break;
//
//        default:
//            break;
//    }
//}

//-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//
//
//
    //}
}

- (void)clickWithdrawWithCurrency:(CurrencyModel *)currencyModel {
    
    CoinWeakSelf;
    
//    //判断是否认证身份
//    if (![[TLUser user].realName valid]) {
//
//        ZMAuthVC *zmAuthVC = [ZMAuthVC new];
//
//        zmAuthVC.title = [LangSwitcher switchLang:@"实名认证" key:nil];
//
//        zmAuthVC.success = ^{
    
          
    
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
