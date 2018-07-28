//
//  HomeVC.m
//  OGC
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "HomeVC.h"

//M
#import "StoreModel.h"
#import "CountInfoModel.h"
//V
#import "StoreTableView.h"
#import "HomeHeaderView.h"
#import "TLProgressHUD.h"
//C
#import "TradeFlowListVC.h"
#import "StoreListVC.h"
#import "GoodMallVC.h"
#import "PosMiningVC.h"
#import "RateDescVC.h"
#import "CoinUtil.h"
#import "RedEnvelopeVC.h"

#import "HomeTableView.h"

#import "WebVC.h"

#import "MnemonicUtil.h"
#import "UIBarButtonItem+convience.h"
#import "TLPwdRelatedVC.h"
#import "HTMLStrVC.h"

@interface HomeVC ()

@property (nonatomic, strong) HomeTableView *tableView;

//头部
@property (nonatomic, strong) HomeHeaderView *headerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *nameLable;

@end

@implementation HomeVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    
//    [MnemonicUtil test];

//    BTCMnemonic *mnemonic =  [MnemonicUtil generateNewMnemonic];
//    NSLog(@"Seed=%@", BTCHexFromData(mnemonic.seed));
//    NSLog(@"Mnemonic=%@", mnemonic.words);
//    NSLog(@"btc_privateKey=%@", [MnemonicUtil getBtcPrivateKey:mnemonic]);
//    NSLog(@"btc_publicKey=%@", [MnemonicUtil getBtcAddress:mnemonic]);
//    NSLog(@"eth_privateKey=%@", [MnemonicUtil getEthPrivateKey:mnemonic]);
//    NSLog(@"eth_publicKey=%@", [MnemonicUtil getEthAddress:mnemonic]);
//
//    mnemonic =  [MnemonicUtil importMnemonic:mnemonic.words];
//    NSLog(@"Seed=%@", BTCHexFromData(mnemonic.seed));
//    NSLog(@"Mnemonic=%@", mnemonic.words);
//    NSLog(@"privateKey=%@", [MnemonicUtil getBtcPrivateKey:mnemonic]);
//    NSLog(@"getEthTokenGasPrice=%@", [MnemonicUtil getEthTokenGasPrice]);
//    return;
    
    [super viewDidLoad];
    //
    self.title = [LangSwitcher switchLang:@"发现" key:nil];
    self.view.backgroundColor = kWhiteColor;
    [self initTableView];
    
    [CoinUtil refreshOpenCoinList:^{
        
        //获取banner列表
        [self requestBannerList];
        
    } failure:^{
        
        [self.tableView endRefreshHeader];
        
    }];
   
}

- (void)initTableView {
    
    CoinWeakSelf;
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:kImage(@"消息1") style:UIBarButtonItemStyleDone target:self action:@selector(OpenMessage)];
//
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//    [UIBarButtonItem addRightItemWithImageName:@"消息" frame:CGRectMake(0, 0, 30, 30) vc:self action:@selector(OpenMessage)];
    
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
//    self.bgImage.image = kImage(@"我的 背景");
    [self.view  addSubview:self.bgImage];
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backButton.frame = CGRectMake(kScreenWidth-70, kStatusBarHeight+5, 40, 40);
    [self.backButton setImage:kImage(@"消息") forState:(UIControlStateNormal)];
    [self.backButton addTarget:self action:@selector(OpenMessage) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgImage addSubview:self.backButton];
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(54, kStatusBarHeight+5, kScreenWidth - 108, 44)];
    self.nameLable.text = [LangSwitcher switchLang:@"发现" key:nil];
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.font = Font(16);
    self.nameLable.textColor = kTextBlack;
    [self.bgImage addSubview:self.nameLable];
    
    self.tableView = [[HomeTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.headerView];

//        self.tableView.tableHeaderView = self.headerView;
//    self.tableView.refreshDelegate = self;
//        [self.tableView adjustsContentInsets];
    [self.view addSubview:self.tableView];
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsZero);
//        }];
    
    [self.tableView addRefreshAction:^{
        
        [CoinUtil refreshOpenCoinList:^{
            //获取banner列表
            [weakSelf requestBannerList];
        } failure:^{
            [weakSelf.tableView endRefreshHeader];
        }];
    }];
    
}

#pragma mark - Init


- (void)changeWord
{
    NSString * str = @"";
    
    
}

- (void)OpenMessage
{
    RateDescVC *vc = [RateDescVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (HomeHeaderView *)headerView {
    
    if (!_headerView) {
        
        CoinWeakSelf;
        //头部
        _headerView = [[HomeHeaderView alloc] initWithFrame:CGRectMake(15, kHeight(80), kScreenWidth, kScreenHeight)];
        
        _headerView.headerBlock = ^(HomeEventsType type, NSInteger index) {
            
            [weakSelf headerViewEventsWithType:type index:index];
        };
        _headerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+100);
//        self.tableView.tableHeaderView = _headerView;
    }
    return _headerView;
}

#pragma mark - HeaderEvents
- (void)headerViewEventsWithType:(HomeEventsType)type index:(NSInteger)index {
    
    switch (type) {
            
        case HomeEventsTypeBanner:
        {
            
            NSString *url = [[self.bannerRoom objectAtIndex:index] url];
            if (url && url.length > 0) {
                WebVC *webVC = [[WebVC alloc] init];
                webVC.url = url;
                [self.navigationController pushViewController:webVC animated:YES];
            }
            
        }break;
            
        case HomeEventsTypeStatistics:
        {
            TradeFlowListVC *flowVC = [TradeFlowListVC new];
            
            [self.navigationController pushViewController:flowVC animated:YES];
            
        }break;
            
        case HomeEventsTypeStore:
        {
            RedEnvelopeVC *redEnvelopeVC = [RedEnvelopeVC new];
            
            if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
                TLPwdType pwdType = TLPwdTypeSetTrade;
                TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
                
                pwdRelatedVC.isWallet = YES;
                pwdRelatedVC.success = ^{
                    
                    
                    [self presentViewController:redEnvelopeVC animated:YES completion:nil];
                    
                };
                [self.navigationController pushViewController:pwdRelatedVC animated:YES];
                
                
            }else{
                
                [self presentViewController:redEnvelopeVC animated:YES completion:nil];
                
                
            }

            
        }break;
            
        case HomeEventsTypeGoodMall:
        {
            HTMLStrVC *vc = [HTMLStrVC new];
            vc.type = HTMLTypeGlobal_master;
//            StoreListVC *storeVC = [StoreListVC new];
            
            [self.navigationController pushViewController:vc animated:YES];
           
        }break;
            
        case HomeEventsTypePosMining:
        {
//            PosMiningVC *posMiningVC = [PosMiningVC new];
            HTMLStrVC *vc = [HTMLStrVC new];
            vc.type = HTMLTypeGlobal_master;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case HomeEventsTypeRedEnvelope:
        {
            HTMLStrVC *vc = [HTMLStrVC new];
            vc.type = HTMLTypeGlobal_master;
//            GoodMallVC *mallVC = [GoodMallVC new];
            
            [self.navigationController pushViewController:vc animated:YES];
            

        }break;
            
        default:
            break;
    }

}

#pragma mark - Data


- (void)requestBannerList {
    
//    [TLProgressHUD show];

    TLNetworking *http = [TLNetworking new];
    
    http.isUploadToken = NO;
    http.code = @"805806";
    http.parameters[@"location"] = @"app_home";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.headerView.banners = self.bannerRoom;
        
        //获取官方钱包总量，已空投量
        [self requestCountInfo];
        
    } failure:^(NSError *error) {
        
        [self.tableView endRefreshHeader];
//        [TLProgressHUD dismiss];
        
    }];
    
}

/**
 获取官方钱包总量，已空投量
 */
- (void)requestCountInfo {
    
    NSString *symbol = @"OGC";
    NSArray *tokens = [CoinUtil shouldDisplayTokenCoinArray];
    if (tokens.count > 0) {
        symbol = [[CoinUtil shouldDisplayTokenCoinArray] objectAtIndex:0];
    }
    
    TLNetworking *http = [TLNetworking new];

    http.code = @"802906";
    http.parameters[@"currency"] = symbol;

    [http postWithSuccess:^(id responseObject) {

        CountInfoModel *countInfo = [CountInfoModel mj_objectWithKeyValues:responseObject[@"data"]];

        self.headerView.countInfo = countInfo;
        [self.tableView endRefreshHeader];

    } failure:^(NSError *error) {
        [self.tableView endRefreshHeader];
    }];
    
    /*未完成功能，模拟数据*/
//    CountInfoModel *countInfo = [[CountInfoModel alloc] init];
//    countInfo.initialBalance = @"100000000000000";
//    countInfo.useBalance = @"60000000000000";
//    countInfo.useRate = @"0.6";
    
//    self.headerView.countInfo = countInfo;
    
    [TLProgressHUD dismiss];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
