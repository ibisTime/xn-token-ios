//
//  TLMoneyDeailVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/16.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLMoneyDeailVC.h"
#import "TLTopMoneyView.h"
#import "TLUIHeader.h"
#import "CoinUtil.h"
#import "CurrencyModel.h"
#import "RechargeCoinVC.h"
#import "TLTextField.h"
#import "AssetPwdView.h"
#import "TLPwdRelatedVC.h"
@interface TLMoneyDeailVC () <UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic ,strong) UIScrollView *contentView;
//@property (nonatomic ,strong) UIView *titleView;
@property (nonatomic ,strong) TLTopMoneyView *tit;
@property (nonatomic ,strong) UILabel *proInfo;
@property (nonatomic ,strong) UILabel *proname;
@property (nonatomic ,strong) UILabel *pronameDetail;
@property (nonatomic ,strong) UILabel *symble;
@property (nonatomic ,strong) UILabel *symblename;
@property (nonatomic ,strong) UILabel *backLable;
@property (nonatomic ,strong) UILabel *backdetailLab;
@property (nonatomic ,strong) UILabel *bottomLab;
@property (nonatomic,strong)  UIWebView *web;
@property (nonatomic ,strong) UIButton *importButton;
@property (nonatomic ,strong) UIView * view1;
@property (nonatomic ,strong) UIView * view2;
@property (nonatomic ,strong) NSString * payCount;
@property (nonatomic ,strong) UIView * view3;
@property (nonatomic ,strong) AssetPwdView *pwdView;
@property (nonatomic ,strong) NSTimer * timeOut;
@property (nonatomic ,assign) NSInteger  time;
@property (nonatomic ,assign) UILabel *timeLab;
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
@property (nonatomic ,strong) CurrencyModel * currencyModel;

@end

@implementation TLMoneyDeailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self initCustomView];
    [self LoadData];
    
    AssetPwdView *pwdView =[[AssetPwdView alloc] init];
    pwdView.isPay = YES;
    self.pwdView = pwdView;
    pwdView.HiddenBlock = ^{
        self.pwdView.hidden = YES;
        //        [self.pwdView removeFromSuperview];
    };
    CoinWeakSelf;
    self.pwdView.forgetBlock = ^{
        
        
        TLPwdRelatedVC *vc  = [[TLPwdRelatedVC alloc] initWithType:TLPwdTypeTradeReset];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        
    };
    pwdView.hidden = YES;
    pwdView.frame = self.view.bounds;
    [self.navigationController.view addSubview:pwdView];
    UIWebView *web = [[UIWebView alloc] init];
    [self.contentView addSubview:web];
    web.delegate =self;
    
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLab.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(300));
    }];
    [web loadHTMLString:@"币加加是蓝潮基金提供给THA用户的一项低风险高收益的数字资产定期理财产品，蓝潮基金主要通过跨市场套利、期限套利、做市套利、统计套利等多种套利模型实现数字资产的稳健增值。币加加是蓝潮基金提供给THA用户的一项低风险高收益的数字资产定期理财产品，蓝潮基金主要通过跨市场套利、期限套利、做市套利、统计套利等多种套利模型实现数字资产的稳健增值。币加加是蓝潮基金提供给THA用户的一项低风险高收益的数字资产定期理财产品，蓝潮基金主要通过跨市场套利、期限套利、做市套利、统计套利等多种套利模型实现数字资产的稳健增值。" baseURL:nil];
//    self.contentView.contentSize = CGSizeMake(0, kScreenHeight+150);
    
     [self.web.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tit.model = self.moneyModel;

    
}

- (void)initCustomView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    contentView.userInteractionEnabled = YES;
//    contentView.contentSize = CGSizeMake(0, kScreenHeight);
    contentView.scrollEnabled = YES;
    contentView.delegate = self;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomInsetHeight);
    }];
    UIView *topView = [[UIView alloc] init];
    [contentView addSubview:topView];
    topView.backgroundColor = kHexColor(@"#0848DF");
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kHeight(66)));
    }];
    
    TLTopMoneyView *titleView = [[TLTopMoneyView alloc] init];
    titleView.backgroundColor = kWhiteColor;
    self.tit = titleView;
    [contentView addSubview:titleView];
    titleView.layer.borderWidth = 0.5;
    titleView.layer.borderColor = [UIColor colorWithRed:62/255.0 green:58/255.0 blue:57/255.0 alpha:0.16].CGColor;
    titleView.layer.cornerRadius = 4;
    titleView.clipsToBounds = YES;
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@183);

    }];
    
    self.proInfo = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    [self.contentView addSubview:self.proInfo];
    self.proInfo.text = [LangSwitcher switchLang:@"产品详情" key:nil];
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = kHexColor(@"#256DF8");
    [self.contentView addSubview:v1];
    
    UIView *v2 = [UIView new];
    v2.backgroundColor = kHexColor(@"#256DF8");
    [self.contentView addSubview:v2];
    
    self.proname = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    self.proname.text = [LangSwitcher switchLang:@"产品名称" key:nil];

    [self.contentView addSubview:self.proname];
    
    self.pronameDetail = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    

    [self.contentView addSubview:self.pronameDetail];
    
    self.symble = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    [self.contentView addSubview:self.symble];
    self.symble.text = [LangSwitcher switchLang:@"认购币种" key:nil];

    self.symblename = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.symblename];
    
    self.backLable = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    [self.contentView addSubview:self.backLable];
    self.backLable.text = [LangSwitcher switchLang:@"回款方式" key:nil];

    self.backdetailLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [self.contentView addSubview:self.backdetailLab];
    
    self.bottomLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    [self.contentView addSubview:self.bottomLab];
    self.bottomLab.text = [LangSwitcher switchLang:@"产品介绍" key:nil];
    
    [self layoutCustomUi];
    
    [self.proInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tit.mas_bottom).offset(20);
        make.left.equalTo(self.tit.mas_left);
    }];
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.proInfo.mas_centerY);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@10);
        make.height.equalTo(@6);
    }];
    
    [self.proname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.proInfo.mas_bottom).offset(30);
        make.left.equalTo(self.tit.mas_left);
    }];
    
    [self.pronameDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.proname.mas_centerY);
        make.left.equalTo(self.tit.mas_right).offset(20);
    }];
    
    [self.symble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.proname.mas_bottom).offset(40);
        make.left.equalTo(self.tit.mas_left);
    }];
    
    [self.symblename mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.symble.mas_centerY);
        make.left.equalTo(self.symble.mas_right).offset(20);
    }];
    
    [self.backLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.symble.mas_bottom).offset(40);
        make.left.equalTo(self.symble.mas_left);
    }];
    
    [self.backdetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.symble.mas_bottom).offset(25);
        make.left.equalTo(self.symble.mas_right).offset(20);
    }];
    
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kHexColor(@"#E3E3E3");
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.proname.mas_bottom).offset(18);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.3);

                          
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = kHexColor(@"#E3E3E3");
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.symble.mas_bottom).offset(18);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.3);
        
        
    }];
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = kHexColor(@"#E3E3E3");
    [self.contentView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backLable.mas_bottom).offset(18);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@0.3);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backLable.mas_bottom).offset(40);
        make.left.equalTo(self.tit.mas_left);
    }];
    
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomLab.mas_centerY);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@10);
        make.height.equalTo(@6);
    }];
    
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"购 买" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(buyNow) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.layer.cornerRadius = 4;
    self.importButton.clipsToBounds = YES;
    [self.view addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-26);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.height.equalTo(@48);
        
    }];
}
#pragma mark - 钱包网络请求
-(void)LoadData
{
    if (![TLUser user].isLogin) {
        return;
    }
    TLNetworking *http = [TLNetworking new];
    http.code = @"802503";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    
    [http postWithSuccess:^(id responseObject) {
        /*
         CoinModel *coin = [CoinUtil getCoinModel:platform.currency];
         
         NSString *leftAmount = [CoinUtil convertToRealCoin:platform.amountString coin:coin.symbol];
         */
        NSLog(@"%@",responseObject);
        self.currencys = [CurrencyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accountList"]];
        for (int i = 0; i < self.currencys.count; i++) {
            CurrencyModel *model = self.currencys[i];
            if ([model.currency isEqualToString:self.moneyModel.symbol]) {
                self.currencyModel = model;
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)buyNow
{
    //购买
    [self payAmount];
    
}

- (void)payAmount
{
//    [self endEditing:YES];
    UIView * view1 = [UIView new];
    self.view1 = view1;
    self.view1.hidden = NO;
    
    view1.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view1.backgroundColor =
    view1.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    
    //    view.alpha = 0.5;
    [self.navigationController.view addSubview:view1];
    UIView *whiteView = [UIView new];
    
    [view1 addSubview:whiteView];
    
    whiteView.frame = CGRectMake(24, kHeight(194), kScreenWidth - 48, kHeight(300));
    
    whiteView.backgroundColor = kWhiteColor;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:kImage(@"红包 删除") forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(10);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@22.5);
    }];
    
    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    sureLab.text = [LangSwitcher switchLang:@"代币名称" key:nil];
    [whiteView addSubview:sureLab];
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(20);
        make.left.equalTo(whiteView.mas_left).offset(23);
    }];
    
    UILabel *symLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    symLab.text = self.currencyModel.symbol;
    [whiteView addSubview:symLab];
    [symLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sureLab.mas_centerY);
        make.left.equalTo(whiteView.mas_right).offset(20);
    }];
    
    UILabel *blanceLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    blanceLab.text = [LangSwitcher switchLang:@"可用余额" key:nil];
    [whiteView addSubview:blanceLab];
    [blanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(15);
        make.left.equalTo(sureLab.mas_left);
    }];
    UILabel *moneyLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
//    moneyLab.text = [LangSwitcher switchLang:@"可用余额" key:nil];
    [whiteView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(15);
        make.left.equalTo(blanceLab.mas_right).offset(20);
    }];
    CoinModel *coin = [CoinUtil getCoinModel:self.currencyModel.currency];

    NSString *m = [CoinUtil convertToRealCoin:coin.unit coin:self.moneyModel.symbol];
    moneyLab.text = [NSString stringWithFormat:@"%@",m];
    
    UILabel *symLab1 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    symLab1.text = self.currencyModel.currency;
    [whiteView addSubview:symLab1];
    [symLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyLab.mas_centerY);
        make.left.equalTo(moneyLab.mas_right).offset(5);
    }];
    
    UILabel * transFormLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#3E3A39") font:13];
    transFormLab.userInteractionEnabled = YES;
    [whiteView addSubview:transFormLab];
    transFormLab.layer.cornerRadius = 1;
    transFormLab.layer.borderColor = kTextBlack.CGColor;
    transFormLab.layer.borderWidth = 0.3;
    transFormLab.clipsToBounds = YES;
    transFormLab.text = [LangSwitcher switchLang:@"转入资金" key:nil];
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transformMoney)];
    [transFormLab addGestureRecognizer:ta];
    [transFormLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(symLab1.mas_centerY);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@20);
//        make.width.equalTo(@50);
        
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kLineColor;
    [whiteView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blanceLab.mas_bottom).offset(24);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);

    }];
    
    UILabel *buyCount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    buyCount.text = [LangSwitcher switchLang:@"购买额度" key:nil];
    
    [whiteView addSubview:buyCount];
    [buyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView.mas_centerX);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    
    TLTextField *inputFiled = [[TLTextField alloc] initWithFrame:CGRectZero leftTitle:nil titleWidth:15 placeholder:[LangSwitcher switchLang:@"请输入购买额度" key:nil]];
    [whiteView addSubview:inputFiled];
    
    [inputFiled mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(buyCount.mas_bottom).offset(5);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@58);

    }];
    
    UILabel *symbolIn = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    symbolIn.text = self.currencyModel.currency;
    
    [inputFiled addSubview:symbolIn];
    [symbolIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputFiled.mas_centerY);
        make.right.equalTo(whiteView.mas_right).offset(-15);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kLineColor;
    [whiteView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputFiled.mas_bottom).offset(5);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    UILabel *getCoinLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:15];
    getCoinLab.text = [LangSwitcher switchLang:@"预计收入" key:nil];
    
    [whiteView addSubview:getCoinLab];
    [getCoinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(15);
        make.left.equalTo(whiteView.mas_left).offset(kScreenWidth/3-30);
    }];
    
    UILabel *coinLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:15];
    coinLab.text = [LangSwitcher switchLang:@"1000" key:nil];
    self.payCount = coinLab.text;
    [whiteView addSubview:coinLab];
    [coinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(15);
        make.left.equalTo(getCoinLab.mas_right).offset(3);
    }];
    
    UILabel *symbol2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:15];
    symbol2.text = self.currencyModel.currency;
    
    [whiteView addSubview:symbol2];
    [symbol2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(15);
        make.left.equalTo(coinLab.mas_right).offset(3);
    }];
//    UILabel *money = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#A75E02") font:17];
//
//    [whiteView addSubview:money];
//    [money mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(sureLab.mas_bottom).offset(100);
//        make.centerX.equalTo(whiteView.mas_centerX);
//    }];
//
//    UIView *buttonView =[UIView new];
//    buttonView.backgroundColor = kWhiteColor;
//    buttonView.layer.borderWidth = 0.5;
//    buttonView.layer.borderColor = kLineColor.CGColor;
//    //    buttonView.layer.cornerRadius = 5.0;
//    //    buttonView.clipsToBounds = YES;
//    [whiteView addSubview:buttonView];
//
//    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buyCount.mas_bottom).offset(100);
//        make.left.equalTo(whiteView.mas_left).offset(25);
//        make.right.equalTo(whiteView.mas_right).offset(-25);
//        make.height.equalTo(@48);
//    }];
//
//    UILabel *blanceMoney = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:15];
//    blanceMoney.text = [LangSwitcher switchLang:@"账户余额" key:nil];
//    [buttonView addSubview:blanceMoney];
//    [blanceMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buttonView.mas_top).offset(213);
//        make.left.equalTo(buttonView.mas_left).offset(10);
//
//    }];
//
//    UILabel *blance = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
//    blance.text = [LangSwitcher switchLang:[NSString stringWithFormat:@"%.3f%@",@"2",self.moneyModel.symbol] key:nil];
//    [buttonView addSubview:blance];
//    [blance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buttonView.mas_top).offset(13);
//        make.left.equalTo(blanceMoney.mas_right).offset(16);
//
//    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    [sureButton setTitle:[LangSwitcher switchLang:@"确认购买" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(56);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
        make.height.equalTo(@50);
        
    }];
}

- (void)transformMoney
{
    RechargeCoinVC *coinVC = [RechargeCoinVC new];

    TLNavigationController * navigation = [[TLNavigationController alloc]initWithRootViewController:coinVC];
    coinVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    coinVC.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    coinVC.currency = self.currencyModel;
    [self presentViewController:navigation animated:YES completion:nil];
    
}

- (void)hideSelf
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view1.hidden = YES;
    }];
    
}
- (void)hideSelfbuy
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view2.hidden = YES;
    }];
    
}

- (void)payMoney
{
 
    self.view1.hidden = YES;
    //确认购买
    
    UIView * view2 = [UIView new];
    self.view2 = view2;
    self.view2.hidden = NO;
    
    view2.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view2.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    
    //    view.alpha = 0.5;
    [self.navigationController.view addSubview:view2];
    UIView *whiteView = [UIView new];
    
    [view2 addSubview:whiteView];
    
    whiteView.frame = CGRectMake(24, kHeight(194), kScreenWidth - 48, kHeight(300));
    
    whiteView.backgroundColor = kWhiteColor;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:kImage(@"红包 删除") forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(hideSelfbuy) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(10);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@22.5);
    }];
    
    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    sureLab.text = [LangSwitcher switchLang:@"购买产品" key:nil];
    [whiteView addSubview:sureLab];
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(20);
        make.left.equalTo(whiteView.mas_left).offset(43);
    }];
    UILabel *nameLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    [whiteView addSubview:nameLab];
    nameLab.text = self.currencyModel.currency;
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(20);
        make.left.equalTo(sureLab.mas_right).offset(23);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kLineColor;
    [whiteView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(15);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    
    UILabel *buycount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    buycount.text = [LangSwitcher switchLang:@"购买额度" key:nil];
    [whiteView addSubview:buycount];
    [buycount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(25);
        make.left.equalTo(sureLab.mas_left);
    }];
    UILabel *buy = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:16];
    [whiteView addSubview:buy];
    buy.text = self.payCount;
    [buy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(25);
        make.left.equalTo(buycount.mas_right).offset(20);
    }];
    UILabel *buysymbol = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [whiteView addSubview:buysymbol];
    buysymbol.text = self.currencyModel.currency;
    [buysymbol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buy.mas_centerY);
        make.left.equalTo(buy.mas_right).offset(10);
    }];
    UIView *line2 = [UIView new];
    line2.backgroundColor = kLineColor;
    [whiteView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buycount.mas_bottom).offset(15);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    
    UILabel *freeTime = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    freeTime.text = [LangSwitcher switchLang:@"本息到期时间" key:nil];
    [whiteView addSubview:freeTime];
    [freeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(15);
        make.left.equalTo(whiteView.mas_left).offset(43);
    }];
    UILabel *timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    [whiteView addSubview:timeLab];
    timeLab.text = @"2018-08-17";
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(15);
        make.left.equalTo(freeTime.mas_right).offset(10);
    }];
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = kLineColor;
    [whiteView addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freeTime.mas_bottom).offset(15);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    UILabel *moneyMay = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:14];
    moneyMay.text = [LangSwitcher switchLang:@"预计收益" key:nil];
    [whiteView addSubview:moneyMay];
    [moneyMay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(15);
        make.left.equalTo(sureLab.mas_left);
    }];
    UILabel *money = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FF6400") font:16];
    money.text = self.payCount;
    [whiteView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyMay.mas_top);
        make.left.equalTo(moneyMay.mas_right).offset(20);
    }];
    UILabel *buysymbol1 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:14];
    [whiteView addSubview:buysymbol1];
    buysymbol1.text = self.currencyModel.currency;
    [buysymbol1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyMay.mas_centerY);
        make.left.equalTo(money.mas_right).offset(3);
    }];
    UIView *line4 = [UIView new];
    line4.backgroundColor = kLineColor;
    [whiteView addSubview:line4];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyMay.mas_bottom).offset(15);
        make.left.equalTo(whiteView.mas_left).offset(15);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.height.equalTo(@0.5);
        
    }];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    [sureButton setTitle:[LangSwitcher switchLang:@"确认付款" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoneyNow) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line4.mas_bottom).offset(20);
        make.left.equalTo(whiteView.mas_left).offset(20);
        make.right.equalTo(whiteView.mas_right).offset(-20);
        make.height.equalTo(@50);
        
    }];
}

- (void)layoutCustomUi {
    
}


- (void)payMoneyNow
{
    //确认付款
    self.view2.hidden = YES;
    self.pwdView.hidden = NO;
    self.pwdView.password.textField.enabled = YES;
    CoinWeakSelf;
    self.pwdView.passwordBlock = ^(NSString *password) {
        if ([password isEqualToString:@""]) {
            [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入支付密码" key:nil]];
            return ;
        }
    
        weakSelf.pwdView.hidden = YES;
        
        [weakSelf.pwdView.password clearText];
        
        [weakSelf showBuySucess];
        
    };
    
    
    
}

- (void)showBuySucess
{
    
    UIView * view3 = [UIView new];
    self.view3 = view3;
    self.view3.hidden = NO;
    
    view3.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    view3.backgroundColor =
    view3.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    
    //    view.alpha = 0.5;
    [self.navigationController.view addSubview:view3];
    UIView *whiteView = [UIView new];
    
    [view3 addSubview:whiteView];
    
    whiteView.frame = CGRectMake(24, kHeight(194), kScreenWidth - 48, kHeight(300));
    
    whiteView.backgroundColor = kWhiteColor;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:kImage(@"红包 删除") forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(10);
        make.right.equalTo(whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@22.5);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.image = kImage(@"打勾 大");
    [whiteView addSubview:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(whiteView.mas_top).offset(35);
        make.centerX.equalTo(whiteView.mas_centerX);
        make.width.height.equalTo(@(kHeight(60)));
    }];
    
    UILabel *sureLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:20];
    [whiteView addSubview:sureLab];
    sureLab.text = [LangSwitcher switchLang:@"购买成功" key:nil];
    [sureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_bottom).offset(18);

        make.centerX.equalTo(whiteView.mas_centerX);
//        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setBackgroundColor:kClearColor forState:UIControlStateNormal];
    [sureButton setTitleColor:kTextColor forState:UIControlStateNormal];
    [whiteView addSubview:sureButton];
    sureButton.titleLabel.font = FONT(13);
    [sureButton setTitle:[LangSwitcher switchLang:@"查看购买记录" key:nil] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(payMoneyNowRecode) forControlEvents:UIControlEventTouchUpInside];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLab.mas_bottom).offset(18);
        make.centerX.equalTo(whiteView.mas_centerX);

        make.width.equalTo(@150);
        make.height.equalTo(@32);
        
    }];
    
    sureButton.layer.borderWidth = 0.5;
    sureButton.layer.borderColor = kPlaceholderColor.CGColor;
    sureButton.layer.cornerRadius = 4;
    sureButton.clipsToBounds = YES;
    self.time = 5;
    
    UILabel *timeLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kPlaceholderColor font:12];
    self.timeLab = timeLab;
    [whiteView addSubview:timeLab];
    NSString * t  = [NSString stringWithFormat:@"%ld%@",self.time,[LangSwitcher switchLang:@"秒钟" key:nil]];
    timeLab.text = [NSString stringWithFormat:@"%@%@",t,[LangSwitcher switchLang:@"自动跳转" key:nil]];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureButton.mas_bottom).offset(18);
        
        make.centerX.equalTo(whiteView.mas_centerX);
        //        make.centerY.equalTo(whiteView.mas_centerY);
        
    }];
    
//    [self begin];
//    [timeLab setTitle:[NSString stringWithFormat:@"%@(%ld)",[LangSwitcher switchLang:@"重新发送" key:nil],_totalTime] forState:UIControlStateDisabled];
//
//    self.backgroundColor = kTextColor2;
    
    self.timeOut = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timeOut forMode:NSRunLoopCommonModes];
}

- (void)timeAction{
    
//    self..enabled = NO;
    
    self.time --;
    
    NSString * t  = [NSString stringWithFormat:@"%ld%@",self.time,[LangSwitcher switchLang:@"秒钟" key:nil]];
    _timeLab.text = [NSString stringWithFormat:@"%@%@",t,[LangSwitcher switchLang:@"自动跳转" key:nil]];
    
    if (self.time == 0) {
        
        [self.timeOut invalidate];
        self.timeOut = nil;
        self.view3.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
//        se = _totalTime;
//        self.backgroundColor = kAppCustomMainColor;
//        [self setTitle:[LangSwitcher switchLang:@"获取验证码" key:nil] forState:UIControlStateNormal];
//
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        //        self.titleLabel.font = Font(15.0);
//        self.enabled = YES;
    }
    
}
- (void)payMoneyNowRecode
{
    
    
}

- (void)setMoneyModel:(TLtakeMoneyModel *)moneyModel
{
    
    _moneyModel = moneyModel;
    
    self.pronameDetail.text = [LangSwitcher switchLang:@"第一期" key:nil];
    self.symblename.text = [LangSwitcher switchLang:@"BTC" key:nil];
    self.backdetailLab.text = [LangSwitcher switchLang:@"期满自动转入个人账户" key:nil];


}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.web stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f7f7f7'"];
    
    CGFloat sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"]floatValue]  ;
    //
    self.web.height = sizeHeight;
    
//    [self.web mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bottomLab.mas_bottom).offset(15);
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.height.equalTo(@(sizeHeight));
//    }];
    
    //    [self.userImg mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(sizeHeight);
    //
    //    }];
    [self.web setNeedsLayout];
//    [self.web setNeedsDisplay];

//    [self.contentView setContentSize:CGSizeMake(kScreenWidth, sizeHeight +kScreenHeight)];

//    self.selectBlock(sizeHeight);
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize fit = [self.web sizeThatFits:CGSizeZero];
        self.web.height = fit.height;

//        NSLog(@"webView%@",NSStringFromCGSize(fit));
//        [self.web mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.bottomLab.mas_bottom).offset(15);
//            make.left.equalTo(self.view.mas_left).offset(15);
//            make.right.equalTo(self.view.mas_right).offset(-15);
//            make.height.equalTo(@(fit.height));
//        }];
//
//        [self.contentView setNeedsLayout];
//        [self.contentView setNeedsDisplay];

        [self.web setNeedsLayout];
//        [self.web setNeedsDisplay];
//        [self.contentView setContentSize:CGSizeMake(kScreenWidth, fit.height +kScreenHeight)];

        
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
