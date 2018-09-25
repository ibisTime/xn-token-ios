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
#import "TLTextField.h"
#import "CoinUtil.h"
#import "NSString+Check.h"
#import "TLPwdRelatedVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
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
#import "AppConfig.h"
#import "NSString+Extension.h"
typedef enum : NSUInteger {
    BTCAPIChain,
    BTCAPIBlockchain,
} BTCAPI;
@interface TLTransfromVC ()<THTranstionCollectionViewDelegate>
@property (nonatomic ,strong) TLPlaceholderView *placeholderView;
@property (nonatomic ,strong) THTranstionCollectionView *nineView;
@property (nonatomic ,strong) UIView *whiteView;

@property (nonatomic ,strong)  UIView *blue;
@property (nonatomic ,strong)  UIView *org;

@property (nonatomic ,strong)  UILabel *myprivate;
@property (nonatomic ,strong)  UILabel *privateKey;
@property (nonatomic ,strong)  UIButton *changebut;

@property (nonatomic ,strong)  TLTextField *inputFiled;
@property (nonatomic ,strong)  TLTextField *googleAuthTF;
@property (nonatomic ,strong)  UIButton *importButton;
@property (nonatomic ,strong) UILabel *Free;

@property (nonatomic ,strong) UIView *wallletView;

@property (nonatomic ,strong) UISlider *slider;

@property (nonatomic ,strong)  UILabel *symbolLab;

@property (nonatomic ,strong)  UILabel *amountlLab;

@property (nonatomic ,copy)  NSString * word;

@property (nonatomic ,strong)  CurrencyModel *currentModel;
@property (nonatomic, strong) UILabel *symbolBlance;
@property (nonatomic, assign) CGFloat gamPrice;
@property (nonatomic, copy) NSString *tempPrice;

@property (nonatomic, copy) NSString *pricr;
@property (nonatomic, copy) NSString *btcAddress;

@property (nonatomic, copy) NSString *btcPrivate;
@property (nonatomic, strong) NSMutableArray <utxoModel *>*utxis;

@property (nonatomic, copy) NSString *signTx;

@property (nonatomic, copy) NSString *priceSlow ;
@property (nonatomic, copy) NSString *priceFast;
@property (nonatomic, assign) NSInteger btcPrice;
@property (nonatomic, strong) UILabel *totalFree;
@property (nonatomic, strong) BTCKey *key;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TLTransfromVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kBackgroundColor;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0  blue:242/255.0  alpha:1.0];

//    [LangSwitcher currentLang];
    self.title = [LangSwitcher switchLang:@"一键划转" key:nil];
    [self initTopCollectionView];
    self.currentModel = self.currencys[0];

    [self initWhiteView];
    [self initInPutView];
    
    [self transformNow];
    self.nineView.isLocal = self.isLocal == YES ? YES : NO ;


    if (self.isLocal == YES) {
        self.nineView.models = self.localcurrencys;
//        [self loadtype];
//        [self loadGas];
        [self changes];
    }else
    {
        self.nineView.models = self.currencys;
    }
    [self.nineView reloadData];
  
  
//    UIImageView *image =   [UIImageView new];
//    image.contentMode = UIViewContentModeScaleToFill;
//    if ([LangSwitcher currentLangType] == LangTypeKorean) {
//        image.image = kImage(@"洞悉-一键划转--韩文");
//
//
//    }else{
//        image.image = kImage(@"洞悉一键划转");
//
//    }
//    [self.view addSubview:image];
//
//    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
//    self.placeholderView = [TLPlaceholderView placeholderViewWithImage:nil text:[LangSwitcher switchLang:@"敬请期待!" key:nil] textColor:kTextColor];
//
//        [self.view addSubview:self.placeholderView];
    // Do any additional setup after loading the view.
}



- (void)initTopCollectionView{
    
    CustomLayoutWallet *layout = [[CustomLayoutWallet alloc] init];
    layout.minimumLineSpacing = 10;
//
//    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((kScreenWidth-60)/3, 42);
    UIImage *image1 = [UIImage imageNamed:@"bch"];
    UIImage *image2 = [UIImage imageNamed:@"eth"];
    UIImage *image3 = [UIImage imageNamed:@"ltc"];
    NSArray *array = @[image2, image2, image3, image2, image3, image1, image3, image1, image1];
    
    THTranstionCollectionView *nineView = [[THTranstionCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout withImage:array];
    self.nineView = nineView;
    [self.view addSubview:nineView];
    int n ;
    CGFloat i  = self.currencys.count / 3;
    if (i <= 1) {
        n = 1;
    }else if (  i <= 2 )
    {
        
        n = 2;
    }else  if (  i <= 3 ){
        n =3;
    }else{
        n = 4;
        }
    
    [nineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(kHeight(i *90+30)));
        
    }];
    nineView.backgroundColor = kHexColor(@"#F1F2F5");
    
    self.nineView.type = SearchTypeTop;
    nineView.refreshDelegate = self;
    nineView.layer.cornerRadius = 6;
    nineView.clipsToBounds = YES;
    //        [self.view addSubview:nineView];
    
}

- (void)initWhiteView
{
   
    UIView *white = [UIView new];
    self.whiteView = white;
    white.backgroundColor = kWhiteColor;
    [self.view addSubview:white];
    [white mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nineView.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView *blue = [[UIView alloc] init];
    blue.backgroundColor =kAppCustomMainColor;
    self.blue = blue;
    blue.layer.cornerRadius = 4;
    blue.clipsToBounds = YES;
    UIView *org = [[UIView alloc] init];
    org.backgroundColor =kOrangeRedColor;
    org.layer.cornerRadius = 4;
    org.clipsToBounds = YES;
    [self.whiteView addSubview:blue];
    [self.whiteView addSubview:org];
    self.org= org;
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_top).offset(20);
        make.left.equalTo(self.whiteView.mas_left).offset(15);
        make.width.height.equalTo(@8);

    }];
    [org mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(blue.mas_bottom).offset(30);
        make.left.equalTo(self.whiteView.mas_left).offset(15);
        make.width.height.equalTo(@8);

    }];

    UILabel *from = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:13];
    
    from.text = [LangSwitcher switchLang:@"从" key:nil];
    UILabel *to = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor3 font:13];
    to.text = [LangSwitcher switchLang:@"到" key:nil];

    [self.whiteView addSubview:from];
    [self.whiteView addSubview:to];
    [from mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(blue.mas_centerY);
        make.left.equalTo(blue.mas_right).offset(5);
        
    }];
    [to mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(org.mas_centerY);
        make.left.equalTo(org.mas_right).offset(5);
    }];

    UILabel *myprviate =  [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    myprviate.text = [LangSwitcher switchLang:@"个人账户" key:nil];
    UILabel *prviatekey =  [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    self.myprivate = myprviate;
    self.privateKey = prviatekey;
    [self.whiteView addSubview:myprviate];
    [self.whiteView addSubview:prviatekey];
    prviatekey.text = [LangSwitcher switchLang:@"私钥账户" key:nil];

    [myprviate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(from.mas_centerY);
        make.left.equalTo(to.mas_right).offset(15);
        
    }];
    [prviatekey mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(org.mas_centerY);
        make.left.equalTo(to.mas_right).offset(15);
    }];

    UIButton *but = [UIButton buttonWithTitle:@"" titleColor:kTextBlack backgroundColor:kClearColor titleFont:15];
    [but setImage:kImage(@"转换ICON") forState:UIControlStateNormal];
    
    [self.whiteView addSubview:but];
    self.changebut = but;
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(myprviate.mas_bottom);
        make.right.equalTo(self.whiteView.mas_right).offset(-15);
        make.width.height.equalTo(@60);
        make.height.equalTo(@30);

    }];
    [but addTarget:self action:@selector(changes) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)changesDetail
{
    
    
}

- (void)changes
{
    //
    if (self.changebut.isSelected == YES) {
        self.currencys = self.centercurrencys;
        for (int i = 0; i < self.currencys.count; i++) {
            if (self.currentModel.symbol == self.centercurrencys[i].currency) {
                self.currentModel = self.centercurrencys[i];
            }
        }
        if (self.currentModel.currency.length > 0) {
            
        }else{
            self.currentModel = self.centercurrencys[0];

        }
        self.isLocal = NO;
        self.totalFree.text = [LangSwitcher switchLang:@"本次划转手续费为" key:nil];

        self.privateKey.text = [LangSwitcher switchLang:@"私钥账户" key:nil];
        self.blue.backgroundColor =kAppCustomMainColor;
        self.org.backgroundColor =kOrangeRedColor;
        self.inputFiled.text = nil;
        self.myprivate.text = [LangSwitcher switchLang:@"个人账户" key:nil];

        self.slider.hidden = YES;
        [self.view setNeedsLayout];
        
       
        NSString *leftAmount = [self.currentModel.amountString subNumber:self.currentModel.frozenAmountString];
        
        //
        NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:self.self.currentModel.currency];
            
            self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.currentModel.currency];
       

        
        if (self.isLocal == NO) {
            CoinModel *currentCoin = [CoinUtil getCoinModel:self.currentModel.currency];
            //
            self.Free.text = currentCoin.withdrawFeeString;
//            self.totalFree.text = [LangSwitcher switchLang:@"本次划转矿工费为" key:nil];

            self.Free.text = [NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.currentModel.currency], self.currentModel.currency];

            self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.currentModel.currency], self.currentModel.currency]];
        }
        if ([TLUser user].isGoogleAuthOpen == YES) {
            [self.wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.privateKey.mas_bottom).offset(10);
                make.left.equalTo(@15);
                make.right.equalTo(@-15);
                make.height.equalTo(@(kHeight(240)));
            }];
        }else
        {
            [self.wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.privateKey.mas_bottom).offset(10);
                make.left.equalTo(@15);
                make.right.equalTo(@-15);
                make.height.equalTo(@(kHeight(170)));
            }];
        }
    }else{
        self.totalFree.text = [LangSwitcher switchLang:@"本次划转手续费为" key:nil];

        self.isLocal = YES;
        self.currencys = self.localcurrencys;
        for (int i = 0; i < self.currencys.count; i++) {
            if (self.currentModel.currency == self.localcurrencys[i].symbol) {
                self.currentModel = self.localcurrencys[i];
            }
            
        }
//        self.currentModel = self.localcurrencys[self.currentIndex];
        if (self.currentModel.symbol.length > 0) {
            
        }else{
            self.currentModel = self.localcurrencys[0];

        }

        self.blue.backgroundColor =kOrangeRedColor;
        self.org.backgroundColor =kAppCustomMainColor;
        self.privateKey.text = [LangSwitcher switchLang:@"个人账户" key:nil];
        
        self.myprivate.text = [LangSwitcher switchLang:@"私钥账户" key:nil];

        if ([TLUser user].isGoogleAuthOpen == YES) {
            [self.wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.privateKey.mas_bottom).offset(10);
                make.left.equalTo(@15);
                make.right.equalTo(@-15);
                make.height.equalTo(@(kHeight(280)));
            }];
        }else
        {
            [self.wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.privateKey.mas_bottom).offset(10);
                make.left.equalTo(@15);
                make.right.equalTo(@-15);
                make.height.equalTo(@(kHeight(210)));
            }];
        }
        [self loadtype];
        if (self.isLocal == YES) {
            NSString *money = [CoinUtil convertToRealCoin:self.currentModel.balance coin:self.currentModel.symbol];
            
            self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.currentModel.symbol];
        }
        
        
        
        [self.view setNeedsLayout];
        [self loadGas];
        self.slider.hidden = NO;
       
    }
  
    self.changebut.selected = ! self.changebut.selected;
    
    
}

- (void)initInPutView
{
    UIView *wallletView  = [UIView new];
    wallletView.backgroundColor = kWhiteColor;
    self.wallletView = wallletView;
    wallletView.layer.cornerRadius = 4;
    wallletView.layer.borderWidth = 1;
    wallletView.layer.borderColor = kHexColor(@"#2B5495").CGColor;
    wallletView.clipsToBounds = YES;
    [self.whiteView addSubview:wallletView];



    
    UILabel *introduce = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    introduce.text = [LangSwitcher switchLang:@"划入数量" key:nil];
    [wallletView addSubview:introduce];
    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wallletView.mas_top).offset(15);
        
        make.left.equalTo(wallletView.mas_left).offset(15);
        
    }];
    
    self.inputFiled = [[TLTextField alloc] initWithFrame:CGRectMake(30, kHeight(115), kScreenWidth-60, 60) leftTitle:@"" titleWidth:5 placeholder:[LangSwitcher switchLang:@"转账数量" key:nil]];
    self.inputFiled.clearButtonMode = UITextFieldViewModeNever;
    [self.whiteView addSubview:self.inputFiled];
    self.inputFiled.layer.cornerRadius = 3;
    self.inputFiled.layer.borderWidth = 1;
    self.inputFiled.layer.borderColor = kLineColor.CGColor;
    self.inputFiled.keyboardType = UIKeyboardTypeDecimalPad;


    UILabel *symbolLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextBlack font:15];
    symbolLab.text = self.currencys[0].currency;
    self.symbolLab = symbolLab;
    [self.inputFiled addSubview:symbolLab];
    [symbolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputFiled.mas_centerY);
        make.right.equalTo(self.inputFiled.mas_right).offset(-100);
        
    }];
    
    UIButton *allLab = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"全部" key:nil] titleColor:kTextBlack backgroundColor:kClearColor titleFont:14];
    
    [self.whiteView addSubview:allLab];
//    self.changebut = allLab;
    [allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.inputFiled.mas_centerY);
        make.right.equalTo(self.inputFiled.mas_right).offset(-10);
        make.width.height.equalTo(@80);
        make.height.equalTo(@35);
        
    }];
    
    allLab.layer.cornerRadius = 2;
    allLab.layer.borderWidth = 1;
    allLab.layer.borderColor = kAppCustomMainColor.CGColor;
    allLab.clipsToBounds = YES;
    [allLab addTarget:self action:@selector(allTransform) forControlEvents:UIControlEventTouchUpInside];


    

//     谷歌验证码输入框
    self.googleAuthTF = [[TLTextField alloc] initWithFrame:CGRectMake(30, self.inputFiled.yy + 5, kScreenWidth-60, 60)
                                                 leftTitle:[LangSwitcher switchLang:@"" key:nil]
                                                titleWidth:5
                                               placeholder:[LangSwitcher switchLang:@"请输入谷歌验证码" key:nil]];
    kViewBorderRadius(self.googleAuthTF, 2, 1, kLineColor);

    self.googleAuthTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.whiteView addSubview:self.googleAuthTF];


    

    UILabel *leftAmount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    leftAmount.text = [LangSwitcher switchLang:@"可用余额" key:nil];
    [wallletView addSubview:leftAmount];


    if ([TLUser user].isGoogleAuthOpen == YES) {
        [wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.privateKey.mas_bottom).offset(10);
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
            make.height.equalTo(@(kHeight(240)));
        }];
        [leftAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.googleAuthTF.mas_bottom).offset(10);

            make.left.equalTo(wallletView.mas_left).offset(15);

        }];
    }else
    {
        [wallletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.privateKey.mas_bottom).offset(10);
            make.left.equalTo(@15);
            make.right.equalTo(@-15);
            make.height.equalTo(@(kHeight(170)));
        }];
        [leftAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputFiled.mas_bottom).offset(10);
            make.left.equalTo(wallletView.mas_left).offset(15);

        }];
    }

    UILabel *avildAmount = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    self.amountlLab = avildAmount;
    if (self.isLocal == YES) {
        NSString *money = [CoinUtil convertToRealCoin:self.currencys[0].balance coin:self.currencys[0].symbol];
        
        avildAmount.text = [NSString stringWithFormat:@"%@ %@",money,self.currencys[0].symbol];
    }else{
        NSString *leftAmount = [self.currencys[0].amountString subNumber:self.currencys[0].frozenAmountString];
        
        //
        NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:self.currencys[0].currency];
       
        avildAmount.text = [NSString stringWithFormat:@"%@ %@",money,self.currencys[0].currency];
    }
   
    [wallletView addSubview:avildAmount];


    [avildAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftAmount.mas_centerY);

        make.left.equalTo(leftAmount.mas_right).offset(15);

    }];

    self.googleAuthTF.hidden = ![TLUser user].isGoogleAuthOpen;
    
    UISlider *slider = [UISlider new];
    self.slider = slider;
    [self.view addSubview:slider];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0;
    slider.hidden = YES;
    slider.thumbTintColor = kHexColor(@"#1B61F0");
    slider.minimumTrackTintColor = kHexColor(@"#1B61F0");
    slider.maximumTrackTintColor = kHexColor(@"#DDE6F9");
    slider.value = 0.5;
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.bottom.equalTo(wallletView.mas_bottom).offset(-20);
        make.width.equalTo(@(kScreenWidth-60));
        make.height.equalTo(@(20));
    }];


    UIView *line = [UIView new];
    line.backgroundColor = kLineColor;
    [wallletView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avildAmount.mas_bottom).offset(10);
        make.left.equalTo(wallletView.mas_left).offset(15);
        make.right.equalTo(wallletView.mas_right).offset(-15);
        make.height.equalTo(@1);
        
    }];
    
    
    self.importButton = [UIButton buttonWithImageName:nil cornerRadius:6];
    NSString *text2 = [LangSwitcher switchLang:@"划转" key:nil];
    [self.importButton setTitle:text2 forState:UIControlStateNormal];
    self.importButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.importButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.importButton addTarget:self action:@selector(transform) forControlEvents:UIControlEventTouchUpInside];
    [self.importButton setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    self.importButton.layer.borderColor = (kAppCustomMainColor.CGColor);
    self.importButton.layer.borderWidth = 1;
    self.importButton.clipsToBounds = YES;
    [self.whiteView addSubview:self.importButton];
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wallletView.mas_bottom).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.left.equalTo(self.view.mas_left).offset(35);
        make.height.equalTo(@48);
        
    }];
    
    UILabel *totalFree = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
   
    [self.whiteView addSubview:totalFree];
    totalFree.textAlignment = NSTextAlignmentCenter;
    self.totalFree = totalFree;
    [totalFree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.importButton.mas_top).offset(-10);
        make.left.equalTo(self.importButton.mas_left).offset(0);
        make.right.equalTo(self.importButton.mas_right).offset(0);
        
    }];

//    UILabel *Free = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14];
//    self.Free = Free;
    if (self.isLocal == YES) {
        totalFree.text = [LangSwitcher switchLang:@"本次划转矿工费为" key:nil];
        
    }else{

        NSString *money1 = [CoinUtil convertToRealCoin:self.currencys[0].amountString coin:self.currencys[0].currency];
        totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@",money1,self.currencys[0].currency]];
//        Free.text = [NSString stringWithFormat:@"%@ %@",money1,self.currencys[0].currency];
    }
  
//    [self.whiteView addSubview:Free];
//    [Free mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.importButton.mas_top).offset(-10);
//        make.left.equalTo(totalFree.mas_right).offset(2);
//    }];

    
    
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
            if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
                

                self.Free.text = [NSString stringWithFormat:@"%@ %@ ",self.priceSlow,@"sat/b"];
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@ ",self.priceSlow,@"sat/b"]];
                self.btcPrice = [self.priceSlow integerValue];
            }else{
                if ([self.currentModel.type isEqualToString:@"0"]) {
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*0.85,self.currentModel.symbol];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",self.gamPrice*0.85,self.currentModel.symbol]];

                }else if ([self.currentModel.type isEqualToString:@"1"])
                {
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*0.85,@"ETH"];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",self.gamPrice*0.85,@"ETH"]];

                }else{
                    
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*0.85,@"WAN"];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",self.gamPrice*0.85,@"WAN"]];

                }
                
                self.pricr = [NSString stringWithFormat:@"%f",[self.tempPrice longLongValue]*0.85];
            }
            
        }else{
            if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
                
                self.Free.text = [NSString stringWithFormat:@"%.0f %@", ([self.priceFast floatValue] - [self.priceSlow floatValue])*value,@"sat/b"];

                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.0f %@", ([self.priceFast floatValue] - [self.priceSlow floatValue])*value,@"sat/b"]];

                self.btcPrice = ([self.priceFast floatValue] - [self.priceSlow floatValue]) *value;
                if (([self.priceFast floatValue] - [self.priceSlow floatValue])*value < [self.priceSlow floatValue]) {
                    self.Free.text = [NSString stringWithFormat:@"%@ %@",self.priceSlow,@"sat/b"];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@",self.priceSlow,@"sat/b"]];
                    
                }
                
                self.pricr = [NSString stringWithFormat:@"%f",[self.pricr intValue]*value];
            }else{
                if ([self.currentModel.type isEqualToString:@"0"]) {
                      self.Free.text = [NSString stringWithFormat:@"%.8f %@", self.gamPrice *0.85 +self.gamPrice*value*1/3 ,self.currentModel.symbol];

                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", self.gamPrice *0.85 +self.gamPrice*value*1/3 ,self.currentModel.symbol]];
                }else if ([self.currentModel.type isEqualToString:@"1"])
                {
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@", self.gamPrice *0.85 +self.gamPrice*value*1/3 ,@"ETH"];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", self.gamPrice *0.85 +self.gamPrice*value*1/3 ,@"ETH"]];
                }else{
                    
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@", self.gamPrice *0.85 +self.gamPrice*value*1/3,@"WAN" ];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@", self.gamPrice *0.85 +self.gamPrice*value*1/3,@"WAN" ]];
                }
              
                
                self.pricr = [NSString stringWithFormat:@"%f",[self.tempPrice longLongValue] + [self.tempPrice longLongValue] *value *1/3];
            }
            
        }
        if (value == 1)
        {
            
            if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
                self.Free.text = [NSString stringWithFormat:@"%@ %@",self.priceFast,@"sat/b"];
                self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@",self.priceFast,@"sat/b"]];
                self.btcPrice = [self.priceFast integerValue];
                
                self.pricr = [NSString stringWithFormat:@"%@",self.priceFast];
            }else{
                if ([self.currentModel.type isEqualToString:@"0"]) {
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*1.15,self.currentModel.symbol];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*1.15,self.currentModel.symbol]];

                }else if ([self.currentModel.type isEqualToString:@"1"])
                {
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*1.15,@"ETH"];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*1.15,@"ETH"]];
                }else{
                    self.Free.text = [NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*1.15,@"WAN"];
                    self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%.8f %@",self.gamPrice*value*1.15,@"WAN"]];

                    
                }
                
                self.pricr = [NSString stringWithFormat:@"%f",[self.tempPrice longLongValue]*value*1.15];
            }
            
        }
    }
    
}

- (void)transformNow
{
    
    if (self.isLocal == NO) {
        CoinModel *currentCoin = [CoinUtil getCoinModel:self.currencys[0].currency];
        //
        self.Free.text = currentCoin.withdrawFeeString;
        
        self.Free.text = [NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.currencys[0].currency], self.currencys[0].currency];

        self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.currencys[0].currency], self.currencys[0].currency]];

        
    }
  
}

- (void)transform
{
    if ([self.inputFiled.text isBlank]) {
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入数量" key:nil]];
        return;
    }
    //划转 提币 和转账
    
    if (self.isLocal == YES) {
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
//        if ([address isNotBlank]) {
            [self loadtype];
            [self loadPwd];
//        NSString *money = [CoinUtil convertToRealCoin:self.currentModel.balance coin:self.currentModel.symbol];
//
//         NSString *ga = [NSString stringWithFormat:@"%@ %@",money,self.currentModel.symbol];
//        NSString *gaspic =  [CoinUtil convertToSysCoin:ga coin:self.currentModel.symbol];
//
//        NSString *g = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]*21000];
//        NSString *text = [gaspic subNumber:g];
//
//        self.amountlLab.text  = [CoinUtil convertToRealCoin:text coin:self.currentModel.symbol];
//        self.inputFiled.text = [CoinUtil convertToRealCoin:text coin:self.currentModel.symbol];
            [self sendExcange];
//        }
        //去中心化划转
    }else{
        //中心化划转
        if ([[TLUser user].tradepwdFlag isEqualToString:@"0"]) {
            
            TLPwdType pwdType = TLPwdTypeSetTrade;
            TLPwdRelatedVC *pwdRelatedVC = [[TLPwdRelatedVC alloc] initWithType:pwdType];
            pwdRelatedVC.isWallet = YES;
            pwdRelatedVC.success = ^{
                
                
                

            };
            [self.navigationController pushViewController:pwdRelatedVC animated:YES];
            return ;
        }
        [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                            msg:@""
                     confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                      cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                    placeHolder:[LangSwitcher switchLang:@"请输入资金密码" key:nil]
                          maker:self cancle:^(UIAlertAction *action) {
//                              [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                              
                          } confirm:^(UIAlertAction *action, UITextField *textField) {
                              //验证密码正确

                              [self  requestTransform:textField.text];

                          }];
        
    }
    
}


- (void)requestTransform : (NSString *)pwd
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"802750";
    http.showView = self.view;
    http.parameters[@"accountNumber"] = self.currentModel.accountNumber;
    
    NSString *leftAmount = [self.currentModel.amountString subNumber:self.currentModel.frozenAmountString];
    
    //
    self.inputFiled.text = [CoinUtil convertToRealCoin:leftAmount coin:self.currentModel.currency];
    
    http.parameters[@"amount"] = [CoinUtil convertToSysCoin:self.inputFiled.text
                                                       coin:self.currentModel.currency];
    http.parameters[@"applyNote"] = [NSString stringWithFormat:@"%@提现", self.currentModel.currency];
    //    http.parameters[@"applyNote"] = @"ios-提现";
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
        http.parameters[@"googleCaptcha"] = self.googleAuthTF.text;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:[LangSwitcher switchLang:@"划转成功" key:nil]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kWithDrawCoinSuccess object:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
    
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

- (void)loadGas
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __block  NSString *pricr;
        if ([self.currentModel.type isEqualToString:@"0"]) {
            
            if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
                TLNetworking *net = [TLNetworking new];
                
                //获取BTCUTXO
                [self loadUtxoList];
                net.code = @"802223";
                
                [net postWithSuccess:^(id responseObject) {
                    NSLog(@"%@",responseObject);
                    NSNumber *slow = responseObject[@"data"][@"fastestFeeMin"];
                    NSNumber *fast = responseObject[@"data"][@"fastestFeeMax"];
                    
                    int f = ([fast intValue] -[slow intValue])/2;
                    f = f + [slow intValue];
                    NSString *priceSlow = [NSString stringWithFormat:@"%@",slow];
                    NSString *priceFast = [NSString stringWithFormat:@"%@",fast];
                    self.priceSlow = priceSlow;
                    self.priceFast = priceFast;
                    NSString *price = [NSString stringWithFormat:@"%d",f];
                    self.btcPrice = f;
                    self.tempPrice = pricr;
                    self.pricr = pricr;
                    NSLog(@"%@low@,fast%@",priceSlow,priceFast);
                    self.gamPrice = [price floatValue ] ;
                    self.slider.value = 0.5;
                    [self valueChange:self.slider];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
                
            }else if ([self.currentModel.symbol isEqualToString:@"WAN"]) {
                //                    pricr = [MnemonicUtil getWanGasPrice];
                
                TLNetworking *net =[TLNetworking new];
                net.code = @"802358";
                [net postWithSuccess:^(id responseObject) {
                    pricr   = responseObject[@"data"][@"gasPrice"];
                    self.pricr = pricr;
                    self.tempPrice = pricr;
                    
                    CGFloat p = [pricr doubleValue]/1000000000000000000;
                    p = p *21000;
                    NSLog(@"%.8f",p);
                    self.gamPrice = p;
                    self.slider.value = 0.5;
                    [self valueChange:self.slider];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }else
            {
                //                    pricr = [MnemonicUtil getGasPrice];
                TLNetworking *net =[TLNetworking new];
                net.code = @"802117";
                [net postWithSuccess:^(id responseObject) {
                    pricr  = responseObject[@"data"][@"gasPrice"];
                    
                    self.pricr = pricr;
                    self.tempPrice = pricr;
                    
                    CGFloat p = [pricr doubleValue]/1000000000000000000;
                    p = p *21000;
                    NSLog(@"%.8f",p);
                    self.gamPrice = p;
                    self.slider.value = 0.5;
                    [self valueChange:self.slider];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
            
        }else{
            
            TLNetworking *net =[TLNetworking new];
            net.code = @"802117";
            [net postWithSuccess:^(id responseObject) {
                pricr   = responseObject[@"data"][@"gasPrice"];
                self.tempPrice = pricr;
                
                self.pricr = pricr;
                CGFloat p = [pricr doubleValue]/1000000000000000000;
                p = p *21000;
                NSLog(@"%.8f",p);
                self.gamPrice = p;
                self.slider.value = 0.5;
                [self valueChange:self.slider];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
        
    });
    
    
    
}

- (void)loadGas1: (NSIndexPath *)indexPath
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __block  NSString *pricr;
        if ([self.currentModel.type isEqualToString:@"0"] || [self.currentModel.symbol isEqualToString:@"BTC"] ||[self.currentModel.currency isEqualToString:@"BTC"] ) {
            
            if ([self.currentModel.symbol isEqualToString:@"BTC"]) {
                TLNetworking *net = [TLNetworking new];
                
                //获取BTCUTXO
                [self loadUtxoList];
                net.code = @"802223";
                
                [net postWithSuccess:^(id responseObject) {
                    NSLog(@"%@",responseObject);
                    NSNumber *slow = responseObject[@"data"][@"fastestFeeMin"];
                    NSNumber *fast = responseObject[@"data"][@"fastestFeeMax"];
                    
                    int f = ([fast intValue] -[slow intValue])/2;
                    f = f + [slow intValue];
                    NSString *priceSlow = [NSString stringWithFormat:@"%@",slow];
                    NSString *priceFast = [NSString stringWithFormat:@"%@",fast];
                    self.priceSlow = priceSlow;
                    self.priceFast = priceFast;
                    NSString *price = [NSString stringWithFormat:@"%d",f];
                    self.btcPrice = f;
                    self.tempPrice = pricr;
                    self.pricr = pricr;
                    NSLog(@"%@low@,fast%@",priceSlow,priceFast);
                    self.gamPrice = [price floatValue ] ;
                    self.slider.value = 0.5;
                    [self valueChange:self.slider];
                    NSString *money = [CoinUtil convertToRealCoin:self.localcurrencys[indexPath.row].balance coin:self.currencys[indexPath.row].symbol];
                    
                    self.currentModel = self.localcurrencys[indexPath.row];
                    self.symbolLab.text = self.localcurrencys[indexPath.row].symbol;
                    self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.localcurrencys[indexPath.row].symbol];
                    CoinModel *currentCoin = [CoinUtil getCoinModel:self.localcurrencys[indexPath.row].symbol];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
                
            }else if ([self.currentModel.symbol isEqualToString:@"WAN"] ||[self.currentModel.currency isEqualToString:@"WAN"]) {
                //                    pricr = [MnemonicUtil getWanGasPrice];
                
                TLNetworking *net =[TLNetworking new];
                net.code = @"802358";
                [net postWithSuccess:^(id responseObject) {
                    pricr   = responseObject[@"data"][@"gasPrice"];
                    self.pricr = pricr;
                    self.tempPrice = pricr;
                    
                    CGFloat p = [pricr doubleValue]/1000000000000000000;
                    p = p *21000;
                    NSLog(@"%.8f",p);
                    self.gamPrice = p;
                    self.slider.value = 0.5;
                    [self valueChange:self.slider];
                    NSString *money = [CoinUtil convertToRealCoin:self.localcurrencys[indexPath.row].balance coin:self.currencys[indexPath.row].symbol];
                    
                    self.currentModel = self.localcurrencys[indexPath.row];
                    self.symbolLab.text = self.localcurrencys[indexPath.row].symbol;
                    self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.localcurrencys[indexPath.row].symbol];
                    CoinModel *currentCoin = [CoinUtil getCoinModel:self.localcurrencys[indexPath.row].symbol];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }else
            {
                //                    pricr = [MnemonicUtil getGasPrice];
                TLNetworking *net =[TLNetworking new];
                net.code = @"802117";
                [net postWithSuccess:^(id responseObject) {
                    pricr  = responseObject[@"data"][@"gasPrice"];
                    
                    self.pricr = pricr;
                    self.tempPrice = pricr;
                    
                    CGFloat p = [pricr doubleValue]/1000000000000000000;
                    p = p *21000;
                    NSLog(@"%.8f",p);
                    self.gamPrice = p;
                    self.slider.value = 0.5;
                    [self valueChange:self.slider];
                    NSString *money = [CoinUtil convertToRealCoin:self.localcurrencys[indexPath.row].balance coin:self.localcurrencys[indexPath.row].symbol];
                    
                    self.currentModel = self.localcurrencys[indexPath.row];
                    self.symbolLab.text = self.localcurrencys[indexPath.row].symbol;
                    self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.localcurrencys[indexPath.row].symbol];
                    CoinModel *currentCoin = [CoinUtil getCoinModel:self.localcurrencys[indexPath.row].symbol];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            }
            
        }else{
            
            TLNetworking *net =[TLNetworking new];
            net.code = @"802117";
            [net postWithSuccess:^(id responseObject) {
                pricr   = responseObject[@"data"][@"gasPrice"];
                self.tempPrice = pricr;
                
                self.pricr = pricr;
                CGFloat p = [pricr doubleValue]/1000000000000000000;
                p = p *21000;
                NSLog(@"%.8f",p);
                self.gamPrice = p;
                self.slider.value = 0.5;
                [self valueChange:self.slider];
                NSString *money = [CoinUtil convertToRealCoin:self.localcurrencys[indexPath.row].balance coin:self.localcurrencys[indexPath.row].symbol];
                
                self.currentModel = self.localcurrencys[indexPath.row];
                self.symbolLab.text = self.localcurrencys[indexPath.row].symbol;
                self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.localcurrencys[indexPath.row].symbol];
                CoinModel *currentCoin = [CoinUtil getCoinModel:self.localcurrencys[indexPath.row].symbol];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
        
    });
    
    
    
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
        
        self.symbolBlance.text = [NSString stringWithFormat:@"%.8f %@",[text floatValue],self.currentModel.symbol];
        NSLog(@"%@",responseObject);
        
        self.utxis = [utxoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"utxoList"]];
        //        [self testSpendCoins:BTCAPIChain];
        //
        //        [self loadHash];
        
        NSLog(@"%@",self.utxis);
        //        [self.tableView endRefreshHeader];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        //        [self.tableView endRefreshHeader];
    }];
}


- (void)sendExcange
{
    
    //
    if (![self.currentModel.symbol isEqualToString:@"BTC"]) {
        NSString *intputMoney = [CoinUtil convertToSysCoin:self.inputFiled.text coin:self.currentModel.symbol];
        
//        NSString *money1 = [CoinUtil convertToSysCoin:self.currentModel.balance coin:self.currentModel.symbol];
        NSString *g1 = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]*21000];
        
        NSString *text1 = [intputMoney subNumber:g1];
        
        if (text1.floatValue  > self.currentModel.balance.floatValue) {
            [TLAlert alertWithError:[LangSwitcher switchLang:@"可用余额不足" key:nil]];
            return;
        }
    }else{
//        NSString *money1 = [CoinUtil convertToRealCoin:self.currentModel.balance coin:self.currentModel.symbol];

        if (self.inputFiled.text.floatValue  > self.currentModel.balance.floatValue) {
            
            [TLAlert alertWithError:[LangSwitcher switchLang:@"可用余额不足" key:nil]];
                return;
        }
 
    }
//    NSString *ga1 = [NSString stringWithFormat:@"%@ %@",money1,self.currentModel.symbol];
    
    
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
    NSString *gaspic =  [CoinUtil convertToSysCoin:self.inputFiled.text coin:self.currentModel.symbol];
    ;
    [dataBase.dataBase close];
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                        msg:@""
                 confirmMsg:[LangSwitcher switchLang:@"确定" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                placeHolder:[LangSwitcher switchLang:@"请输入交易密码" key:nil]
                      maker:self cancle:^(UIAlertAction *action) {
                          
                        
                      } confirm:^(UIAlertAction *action, UITextField *textField) {
                          [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                          //                               [SVProgressHUD show];
                          dispatch_after(0.5, dispatch_get_main_queue(), ^{
                              if ([self.word isEqualToString:textField.text]) {
                                  NSString *result;
                                  NSLog(@"线程2--->%d",[NSThread isMainThread]);
                                  //                                  [SVProgressHUD show];
                                  NSString *add;
                                  for (int i = 0; i < self.localcurrencys.count; i++) {
                                      if ([self.currentModel.symbol isEqualToString:self.centercurrencys[i].currency]) {
                                          add = self.centercurrencys[i].coinAddress;
                                      }
                                  }
                                  
                                  if ([self.currentModel.type isEqualToString:@"0"]) {
                                      //公链 ETH WAN BTC
                                      if ([self.currentModel.symbol isEqualToString:@"ETH"]) {
                                          CoinModel *model = [CoinUtil getCoinModel:self.currentModel.symbol];
                                          NSString *g = [NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]*21000];
                                          
                                          
                                      
                                          result =[MnemonicUtil sendTransactionWithMnemonicWallet:Mnemonics address:add amount:gaspic gaspic:[NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]] gasLimt:@"21000"];
                                          
                                          
                                      }else if ([self.currentModel.symbol isEqualToString:@"WAN"]){
                                    
                                          CoinModel *model = [CoinUtil getCoinModel:self.currentModel.symbol];
                                          NSString *g = [NSString stringWithFormat:@"%lld",[self.pricr longLongValue]*21000];
                                        
                                          result =[MnemonicUtil sendWanTransactionWithMnemonicWallet:Mnemonics address:add amount:gaspic gaspic:[NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]] gasLimt:@"21000"];
                                      }else{
                                          
                                          //btc
                                          
                                          CoinModel *model = [CoinUtil getCoinModel:self.currentModel.symbol];

                                          if ([add isEqualToString:self.btcAddress]) {
                                              [TLAlert alertWithMsg:@"转入和转出地址不能相同"];
                                              return ;
                                          }
                                          
//                                          NSString *money = [CoinUtil convertToRealCoin:self.inputFiled.text coin:self.currentModel.symbol];

                                          
                                          [self testSpendCoins:add :self.inputFiled.text :[NSString stringWithFormat:@"%ld",(long)self.btcPrice]];
                                          return ;
                                      }
                                  }else{
                                      
                                      
                                      CoinModel *coin = [CoinUtil getCoinModel:self.currentModel.symbol];
                                      
                                      
                                      result = [MnemonicUtil sendEthTokenTransactionWithAddress:Mnemonics contractAddress:coin.contractAddress address:add amount:self.inputFiled.text gaspic:[NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]] gasLimt:@"210000"];

                                  }
                                  
                                  //
                                  
                                  
                                  
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
                              }else{
                                  [TLAlert alertWithError:[LangSwitcher switchLang:@"交易密码错误" key:nil]];
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  
                              }
                          });
                          
                          //                          [self confirmWithdrawalsWithPwd:textField.text];
                          
                      }];
    
    
    
    
}

- (void)allTransform
{
    
    if (self.isLocal == YES) {
        if ([self.currentModel.symbol isEqualToString:@"WAN"] || [self.currentModel.symbol isEqualToString:@"ETH"] ) {
            NSString *money = [CoinUtil convertToRealCoin:self.currentModel.balance coin:self.currentModel.symbol];
            
            NSString *ga = [NSString stringWithFormat:@"%@ %@",money,self.currentModel.symbol];
            NSString *gaspic =  [CoinUtil convertToSysCoin:ga coin:self.currentModel.symbol];
            
            NSString *g = [NSString stringWithFormat:@"%lld",[self.tempPrice longLongValue]*21000];
            NSString *text = [gaspic subNumber:g];
            
//            self.amountlLab.text  = [CoinUtil convertToRealCoin:text coin:self.currentModel.symbol];
            if ([self.currentModel.balance longLongValue] <= 0) {
                self.inputFiled.text = @"0";
            }else{
            self.inputFiled.text = [CoinUtil convertToRealCoin:text coin:self.currentModel.symbol];
                if ([self.inputFiled.text floatValue]  <= 0) {
                    self.inputFiled.text = @"0";
                }
            }
        }else{
            
            if ([self.currentModel.balance longLongValue] <= 0) {
                self.inputFiled.text = @"0";
            }else{
                self.inputFiled.text = [CoinUtil convertToRealCoin:self.currentModel.balance coin:self.currentModel.symbol];
                
                if ([self.inputFiled.text floatValue]  <= 0) {
                    self.inputFiled.text = @"0";
                }
            }
            
           
        }
      
    }else{
        NSString *leftAmount = [self.currentModel.amountString subNumber:self.currentModel.frozenAmountString];
        
        //
    self.inputFiled.text = [CoinUtil convertToRealCoin:leftAmount coin:self.currentModel.currency];
    }
}
-(void)refreshCollectionView:(THTranstionCollectionView *)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.inputFiled.text = nil;
    if (self.isLocal == YES) {
        
        self.currentModel = self.localcurrencys[indexPath.row];
        self.currentIndex = indexPath.row;
        self.currencys = self.localcurrencys;
        [self loadtype];
        [self loadGas1:indexPath];
       
    }else{
//        NSString *money = [CoinUtil convertToRealCoin:self.currencys[indexPath.row].amountString coin:self.currencys[indexPath.row].currency];
       
        self.currentIndex = indexPath.row;

        if (self.isLocal == NO) {
            
        }else{
            
            
        }
        self.currencys = self.centercurrencys;
//        for (int i = 0; i < self.currencys.count; i++) {
//            if (self.currentModel.currency == self.centercurrencys[i].currency) {
//                self.currentModel = self.centercurrencys[i];
//            }
//            
//        }
        self.currentModel = self.currencys[indexPath.row];
        
        
        NSString *leftAmount = [self.currentModel.amountString subNumber:self.currentModel.frozenAmountString];
        
        //
        NSString *money = [CoinUtil convertToRealCoin:leftAmount coin:self.currentModel.currency];
        self.symbolLab.text = self.currentModel.currency;
        self.amountlLab.text = [NSString stringWithFormat:@"%@ %@",money,self.currentModel.currency];
        CoinModel *currentCoin = [CoinUtil getCoinModel:self.currentModel.currency];
        
        self.Free.text = currentCoin.withdrawFeeString;
        
        self.Free.text = [NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.currentModel.currency], self.currentModel.currency];

        self.totalFree.text = [NSString stringWithFormat:@"%@ %@",[LangSwitcher switchLang:@"本次划转手续费为" key:nil],[NSString stringWithFormat:@"%@ %@", [CoinUtil convertToRealCoin:currentCoin.withdrawFeeString coin:self.currentModel.currency], self.currentModel.currency]];
        
    }
  
    NSLog(@"%ld",indexPath.row);

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    // Dispose of any resources that can be recreated.
}

- (void) testSpendCoins:(NSString *)to : (NSString*)count :(NSString*)free {
    // For safety I'm not putting a private key in the source code, but copy-paste here from Keychain on each run.为了安全起见，我没有在源代码中放入私钥，而是在每次运行时从Keychain复制粘贴过来。
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
        keychain.network = [BTCNetwork mainnet];
        
    }else{
        keychain.network = [BTCNetwork testnet];
        
    }
    BTCKey *key = keychain.key;
    self.key = key;
    NSData* privateKey = BTCDataFromHex(self.btcPrivate);
    NSLog(@"Private key: %@", privateKey);
    
    //    BTCKey* key = [[BTCKey alloc] initWithPrivateKey:privateKey];
    //    key.publicKeyCompressed = NO;
    //    BTCKeychain *keychain = [[BTCKeychain  alloc] initWithSeed:privateKey];
    
    //    NSLog(@"Address: %@", keychain.key.privateKeyAddressTestnet.string);
    
    NSLog(@"Address: %@", key.privateKeyAddressTestnet);
    
    //    if (![@"cQ2QJ8XJ8KQ7cqRER4WF8ezRBfPKs9vGp63eyHFnL9vgXsVEM1UH" isEqualToString:key.privateKeyAddressTestnet.string]) {
    //        NSLog(@"WARNING: incorrect private key is supplied");
    //        return;
    //    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSError* error = nil;
    BTCTransaction* transaction;
    if ([AppConfig config].runEnv == 0) {
        transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                           to:[BTCPublicKeyAddress addressWithString:to]
                                                       change:key.address // send change to the same address
                                                       amount:count
                                                          fee:free
                                                          api:0
                                                        error:&error];
    }else{
        transaction = [self transactionSpendingFromPrivateKey:privateKey
                                                           to:[BTCPublicKeyAddressTestnet addressWithString:to]
                                                       change:key.addressTestnet // send change to the same address
                                                       amount:count
                                                          fee:free
                                                          api:0
                                                        error:&error];
    }
    
    
    if (!transaction) {
        NSLog(@"Can't make a transaction: %@", error);
    }
    self.signTx = BTCHexFromData([transaction data]);
    
    
    //    return;
    TLNetworking *net = [TLNetworking new];
    
    
    net.code = @"802222";
    net.parameters[@"signTx"] = self.signTx;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [net postWithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [TLAlert alertWithSucces:@"广播成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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
    //    BTCKey* key = [[BTCKey alloc] initWithPrivateKey:privateKey];
    //
    //   BTCNetwork *net = [[BTCNetwork alloc] initWithName:@"testnet3"];
    //    NSLog(@"%d",net.isTestnet);
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
    
    NSLog(@"UTXOs for %@: %@ %@", self.key.privateKeyAddressTestnet, utxos, error);
    
    if (!utxos) {
        *errorOut = error;
        return nil;
    }
    
    CoinModel *coin = [CoinUtil getCoinModel:@"BTC"];
    
    long long mount = [[CoinUtil convertToSysCoin:amount coin:coin.symbol] longLongValue];
    
    
    BTCAmount totalAmount = mount ;
    BTCAmount dustThreshold = 100000; // don't want less than 1mBTC in the change.
    
    
    //通过从最低的一个扫描找到最大的txout数。
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.utxis.count; i++) {
        utxoModel *newut = [utxoModel new];
        newut = self.utxis[i];
        newut.count = [CoinUtil convertToRealCoin:self.utxis[i].count coin:@"BTC"];
        [arr addObject:newut];
    }
    //    utxos = [arr sortedArrayUsingComparator:^(utxoModel* obj1, utxoModel* obj2) {
    //        if (([obj1.count floatValue] - [obj2.count floatValue]) < 0) return NSOrderedAscending;
    //        else return NSOrderedDescending;
    //    }];
    
    NSArray* txouts = nil;
    
    int intput = 0;
    long long btcFree = 0;
    for (utxoModel* txout in arr) {
        intput ++;
        BTCAmount a = [[CoinUtil convertToSysCoin:txout.count coin:@"BTC"] longLongValue];
        //                        convertToRealCoin:txout.count coin:@"BTC"] longLongValue];
        
        if ( a > (totalAmount + dustThreshold)) {
            btcFree = (148 * intput + 34 * 1 + 10) * [fee intValue];
            if (a > (totalAmount + dustThreshold) +btcFree) {
                btcFree = (148 * intput + 34 * 2 + 10) * [fee intValue];
                
            }
            txouts = @[ txout ];
            break;
        }
    }
    
    
    //计算手续费
    
    // We support spending just one output for now. 我们目前只支持支出一项产出。
    
    
    
    
    if (!txouts) return nil;
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (utxoModel* txout in txouts) {
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
    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - (mount + btcFree)) address:changeAddress];
    
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
    
    //     Validate the signatures before returning for extra measure. 在返回额外度量之前验证签名。
    
    
    {
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
        NSError* error = nil;
        NSString *scriptPubKey = [[txouts objectAtIndex:0] scriptPubKey];
        BTCScript *script = [[BTCScript alloc] initWithData:BTCDataFromHex(scriptPubKey)];
        //        BTCScript *script = [[BTCScript alloc] initWithString:scriptPubKey];
        BOOL r = [sm verifyWithOutputScript:script error:&error];
        NSLog(@"Error: %@", error);
        NSAssert(r, @"should verify first output");
    }
    
    //     Transaction is signed now, return it. 交易现已签署，返回
    
    
    return tx;
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
