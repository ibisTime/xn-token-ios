//
//  SearchAdvertiseVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "SearchAdvertiseVC.h"

#import "TLTextField.h"
#import "TLPickerTextField.h"

#import "NSString+Check.h"

#import "AdvertiseModel.h"

#import "SearchResultVC.h"
#import "TLSearchParamChooseView.h"
#import "CoinUtil.h"
#import "CoinService.h"

//0:买币  1:卖币
#define kTradeBuy @"0"
#define kTradeSell @"1"

@interface SearchAdvertiseVC ()<UITextFieldDelegate>

//最低价
@property (nonatomic, strong) TLTextField *minPriceTF;
//最高价
@property (nonatomic, strong) TLTextField *maxPriceTF;
//广告类型
//@property (nonatomic, strong) TLPickerTextField *advertiseTypePicker;
//广告类型选择
@property (nonatomic, assign) NSString *adsType;

@property (nonatomic, assign) BOOL isChoosePayType; //default is no

@property (nonatomic, assign) NSInteger payTypeIndex;
//@property (nonatomic, assign) NSInteger coinTypeIndex;
@property (nonatomic, copy) NSString *searchCoin;



//付款方式
//@property (nonatomic, strong) TLPickerTextField *payTypePicker;
//付款方式选择
//广告列表
@property (nonatomic, strong) NSMutableArray <AdvertiseModel *>*advertises;

@property (nonatomic, strong) TLSearchParamChooseView *adsTypeView;
@property (nonatomic, strong) TLSearchParamChooseView *coinTypeView;
@property (nonatomic, strong) TLSearchParamChooseView *payTypeView;

@end

@implementation SearchAdvertiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initSubviews];
    [self setUpUI];
    
    [self initDataAfterInitUI];
    
    [self initEventAfterInitData];
    
}

- (void)initEventAfterInitData {
    
    __weak typeof(self) weakSelf = self;
    self.adsTypeView.pickerTextField.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.adsType = index == 1 ? kTradeBuy: kTradeSell;
        
    };
    
    //
    self.payTypeView.pickerTextField.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.payTypeIndex = index;
        weakSelf.isChoosePayType = YES;
        
    };
    
    //
    self.coinTypeView.pickerTextField.didSelectBlock = ^(NSInteger index) {
        
        weakSelf.searchCoin = [[CoinUtil shouldDisplayCoinArray] objectAtIndex:index];
        
    };
    
    
}

- (void)initDataAfterInitUI {
    
    if (!self.adsTypeView) {
        @throw [NSException exceptionWithName:@"请先进行UI初始化" reason:nil userInfo:nil];
        return;
    }
    
    //
    self.adsTypeView.pickerTextField.tagNames =  @[[LangSwitcher switchLang:@"买币" key:nil],
                                                   [LangSwitcher switchLang: @"卖币" key:nil]
                                                   ];
    //
    self.coinTypeView.pickerTextField.tagNames = [CoinUtil shouldDisplayCoinArray];
    
    //
    self.payTypeView.pickerTextField.tagNames  = @[
                                                   [LangSwitcher switchLang:@"支付宝" key:nil],
                                                   [LangSwitcher switchLang:@"微信" key:nil],
                                                   [LangSwitcher switchLang:@"银行转账" key:nil]
                                                   ];
    
    self.coinTypeView.pickerTextField.text = [CoinService shareService].currentCoin;
    self.searchCoin = self.coinTypeView.pickerTextField.text;
    
    
    
}

- (void)setUpUI {
    
    CGFloat paramChooseHeight = 55;
    
    //
    self.coinTypeView = [[TLSearchParamChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, paramChooseHeight)
                                                             paramName:@"交易币种"
                                                           placeholder:@"请选择交易币种"];
    [self.view addSubview:self.coinTypeView];
    
    self.adsTypeView = [[TLSearchParamChooseView alloc] initWithFrame:CGRectMake(0, self.coinTypeView.yy, SCREEN_WIDTH, paramChooseHeight)
                                                            paramName:@"广告类型"
                                                          placeholder:@"请选择广告类型"];
    [self.view addSubview:self.adsTypeView];
    

    
    //价格区间
    UIView *priceZoneView = [self priceZoneView:CGRectMake(0, self.adsTypeView.yy, SCREEN_WIDTH, 80)];
    [self.view addSubview:priceZoneView];
    
    
    //付款方式
    self.payTypeView = [[TLSearchParamChooseView alloc] initWithFrame:CGRectMake(0, priceZoneView.yy, SCREEN_WIDTH, paramChooseHeight)
                                                            paramName:@"付款方式"
                                                          placeholder:@"请选择付款方式"];
    [self.view addSubview:self.payTypeView];
    
    //搜广告
        UIButton *searchBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"搜广告" key:nil]
                                             titleColor:kWhiteColor
                                        backgroundColor:kThemeColor
                                              titleFont:16.0
                                           cornerRadius:5];
    
        [searchBtn addTarget:self action:@selector(searchAdvertise) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:searchBtn];
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
            make.height.equalTo(@45);
            make.top.equalTo(self.payTypeView.mas_bottom).offset(70);
    
        }];
    
}

- (UIView *)priceZoneView:(CGRect)frame {
    
    CGFloat leftMargin = 15;

    //
    UIView *priceZoneView = [[UIView alloc] initWithFrame:frame];
    priceZoneView.backgroundColor = [UIColor whiteColor];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    textLbl.text = [LangSwitcher switchLang:@"价格区间" key:nil];
    [priceZoneView addSubview:textLbl];
    [textLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.centerY.equalTo(priceZoneView);
        
    }];
    
    //最低价
    self.minPriceTF = [[TLTextField alloc] initWithFrame:CGRectZero
                                               leftTitle:@""
                                              titleWidth:0
                                             placeholder:[LangSwitcher switchLang:@"最低价" key:nil]];
    
    self.minPriceTF.textAlignment = NSTextAlignmentCenter;
    self.minPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.minPriceTF.layer.cornerRadius = 2.5;
    self.minPriceTF.clipsToBounds = YES;
    self.minPriceTF.backgroundColor = kBackgroundColor;
    [priceZoneView addSubview:self.minPriceTF];
    [self.minPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_right).offset(leftMargin);
        make.centerY.equalTo(textLbl.mas_centerY);
        make.width.equalTo(@(kWidth(120)));
        make.height.equalTo(@40);
        
    }];
    
    //间隔
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kPlaceholderColor;
    [priceZoneView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.minPriceTF.mas_right).offset(5);
        make.width.equalTo(@12);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.minPriceTF.mas_centerY);
        
    }];
    
    //最高价
    self.maxPriceTF = [[TLTextField alloc] initWithFrame:CGRectZero leftTitle:@""
                                              titleWidth:0
                                             placeholder:[LangSwitcher switchLang:@"最高价" key:nil]];
    
    self.maxPriceTF.textAlignment = NSTextAlignmentCenter;
    self.maxPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.maxPriceTF.backgroundColor = kBackgroundColor;
    self.maxPriceTF.layer.cornerRadius = 2.5;
    self.maxPriceTF.clipsToBounds = YES;
    self.maxPriceTF.delegate = self;
    [priceZoneView addSubview:self.maxPriceTF];
    [self.maxPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(self.minPriceTF.mas_centerY);
        make.width.equalTo(@(kWidth(120)));
        make.height.equalTo(@40);
        
    }];
    
    //分割线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = kLineColor;
    [priceZoneView addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(priceZoneView.mas_bottom);
        
    }];
    
    //
    return priceZoneView;
    
    
}

#pragma mark - Init
//- (void)initSubviews {
//
//    CoinWeakSelf;
//    self.view.backgroundColor = kWhiteColor;
//    CGFloat leftMargin = 15;
//
//    //广告类型
//    self.advertiseTypePicker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)
//                                                              leftTitle:[LangSwitcher switchLang:@"广告类型" key:nil]  titleWidth:90
//                                                            placeholder:[LangSwitcher switchLang:@"请选择广告类型" key:nil] ];
//
//    self.advertiseTypePicker.tagNames = @[[LangSwitcher switchLang:@"买币" key:nil],
//                                          [LangSwitcher switchLang: @"卖币" key:nil]
//                                         ];
//
//    self.advertiseTypePicker.didSelectBlock = ^(NSInteger index) {
//
//        weakSelf.advertiseTypeIndex = index;
//    };
//
//    [self.view addSubview:self.advertiseTypePicker];
//
//    [self.advertiseTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(@0);
//        make.left.equalTo(@5);
//        make.right.equalTo(@(-36));
//        make.height.equalTo(@55);
//
//    }];
//
//    //
//    UIImageView *advertiseArrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多拷贝")];
//
//    advertiseArrowIV.backgroundColor = kWhiteColor;
//    advertiseArrowIV.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:advertiseArrowIV];
//    [advertiseArrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@(-20));
//        make.centerY.equalTo(self.advertiseTypePicker.mas_centerY);
//
//    }];
//
//    //广告类型下面的线
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = kLineColor;
//    [self.view addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@20);
//        make.right.equalTo(@(-20));
//        make.height.equalTo(@0.5);
//        make.top.equalTo(self.advertiseTypePicker.mas_bottom).offset(0);
//
//    }];
//
//    // **************************************  价格区间  开始
//    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
//
//    textLbl.text = [LangSwitcher switchLang:@"价格区间" key:nil];
//    [self.view addSubview:textLbl];
//    [textLbl mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@20);
//        make.top.equalTo(line.mas_bottom).offset(36);
//
//    }];
//
//    //最低价
//    self.minPriceTF = [[TLTextField alloc] initWithFrame:CGRectZero
//                                               leftTitle:@""
//                                              titleWidth:0
//                                             placeholder:[LangSwitcher switchLang:@"最低价" key:nil]];
//
//    self.minPriceTF.textAlignment = NSTextAlignmentCenter;
//
//    self.minPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
//
//    self.minPriceTF.layer.cornerRadius = 2.5;
//    self.minPriceTF.clipsToBounds = YES;
//
//    self.minPriceTF.backgroundColor = kBackgroundColor;
//
//    [self.view addSubview:self.minPriceTF];
//    [self.minPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(textLbl.mas_right).offset(leftMargin);
//        make.centerY.equalTo(textLbl.mas_centerY);
//        make.width.equalTo(@(kWidth(120)));
//        make.height.equalTo(@40);
//
//    }];
//
//    //间隔
//    UIView *lineView = [[UIView alloc] init];
//
//    lineView.backgroundColor = kPlaceholderColor;
//
//    [self.view addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.minPriceTF.mas_right).offset(5);
//        make.width.equalTo(@12);
//        make.height.equalTo(@0.5);
//        make.centerY.equalTo(self.minPriceTF.mas_centerY);
//
//    }];
//
//    //最高价
//    self.maxPriceTF = [[TLTextField alloc] initWithFrame:CGRectZero leftTitle:@""
//                                              titleWidth:0
//                                             placeholder:[LangSwitcher switchLang:@"最高价" key:nil]];
//
//    self.maxPriceTF.textAlignment = NSTextAlignmentCenter;
//    self.maxPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
//    self.maxPriceTF.backgroundColor = kBackgroundColor;
//    self.maxPriceTF.layer.cornerRadius = 2.5;
//    self.maxPriceTF.clipsToBounds = YES;
//    self.maxPriceTF.delegate = self;
//
//    [self.view addSubview:self.maxPriceTF];
//    [self.maxPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(lineView.mas_right).offset(5);
//        make.centerY.equalTo(self.minPriceTF.mas_centerY);
//        make.width.equalTo(@(kWidth(120)));
//        make.height.equalTo(@40);
//
//    }];
//
//    //分割线
//    UIView *firstLine = [[UIView alloc] init];
//    firstLine.backgroundColor = kLineColor;
//    [self.view addSubview:firstLine];
//    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@20);
//        make.right.equalTo(@(-20));
//        make.height.equalTo(@0.5);
//        make.top.equalTo(self.maxPriceTF.mas_bottom).offset(20);
//
//    }];
//
//    // **************************************  价格区间结束  ******************************************* //
//    //付款方式
//    self.payTypePicker = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)
//
//                                                        leftTitle:
//                          [LangSwitcher switchLang:@"付款方式" key:nil]
//
//                                                       titleWidth:90
//                                                      placeholder:
//                          [LangSwitcher switchLang:@"请选择付款方式" key:nil]];
//     self.payTypePicker.tagNames = @[
//                                     [LangSwitcher switchLang:@"支付宝" key:nil],
//     [LangSwitcher switchLang:@"微信" key:nil],
//     [LangSwitcher switchLang:@"银行转账" key:nil]
//                                     ];
//    self.payTypePicker.didSelectBlock = ^(NSInteger index) {
//
//        weakSelf.payTypeIndex = index;
//
//    };
//
//    [self.view addSubview:self.payTypePicker];
//
//    [self.payTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(firstLine.mas_bottom).offset(0);
//        make.left.equalTo(@5);
//        make.right.equalTo(@(-36));
//        make.height.equalTo(@50);
//
//    }];
//
//    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多拷贝")];
//    [self.view addSubview:arrowIV];
//    arrowIV.backgroundColor = kWhiteColor;
//    arrowIV.contentMode = UIViewContentModeScaleAspectFit;
//    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@(-20));
//        make.centerY.equalTo(self.payTypePicker.mas_centerY);
//
//    }];
//
//    //
//    UIView *secondLine = [[UIView alloc] init];
//
//    secondLine.backgroundColor = kLineColor;
//
//    [self.view addSubview:secondLine];
//    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@20);
//        make.right.equalTo(@(-20));
//        make.top.equalTo(self.payTypePicker.mas_bottom);
//        make.height.equalTo(@0.5);
//
//    }];
//
//    //搜广告
//    UIButton *searchBtn = [UIButton buttonWithTitle:[LangSwitcher switchLang:@"搜广告" key:nil]
//                                         titleColor:kWhiteColor
//                                    backgroundColor:kThemeColor
//                                          titleFont:16.0
//                                       cornerRadius:5];
//
//    [searchBtn addTarget:self action:@selector(searchAdvertise) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:searchBtn];
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.right.equalTo(@(-15));
//        make.height.equalTo(@45);
//        make.top.equalTo(secondLine.mas_bottom).offset(70);
//
//    }];
//
//}

#pragma mark - Events
- (void)searchAdvertise {
    
    if (![self.minPriceTF.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入最低价" key:nil]];
        return ;
    }
    
    if (![self.maxPriceTF.text valid]) {
        
        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请输入最高价" key:nil]];
        return ;
    }
    
//    if (![self.payTypePicker.text valid]) {
//        
//        [TLAlert alertWithInfo:[LangSwitcher switchLang:@"请选择付款方式" key:nil]];
//        return ;
//    }
    

    SearchResultVC *resultVC = [SearchResultVC new];
    resultVC.searchType = SearchTypeAdvertise;
    resultVC.minPrice = self.minPriceTF.text;
    resultVC.maxPrice = self.maxPriceTF.text;
    
    if (self.isChoosePayType) {
        
        NSString *payType = [NSString stringWithFormat:@"%ld", _payTypeIndex];
        resultVC.payType = payType;
        
    }
  
    resultVC.coin = self.searchCoin;
    resultVC.advertiseType = self.adsType;
    
    [self.navigationController pushViewController:resultVC animated:YES];
    
}



@end
