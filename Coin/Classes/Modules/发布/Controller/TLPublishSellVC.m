//
//  TLPublishSellVC.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
//

#import "TLPublishSellVC.h"
#import <CDCommon/DeviceUtil.h>
#import "TLPublishInputView.h"
#import <CDCommon/UIView+Frame.h>
#import "CurrencyModel.h"
#import "CoinUtil.h"
#import "TLAdpaterView.h"
#import "TLTextView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "TLHighLevelSettingsView.h"
#import "QuotationModel.h"
#import "PublishDraftModel.h"
#import "NSString+Check.h"
#import "PublishService.h"
#import "AdvertiseModel.h"
#import "FilterView.h"
#import "PayTypeModel.h"
#import <NBHTTP/NBNetwork.h>
#import "TLProgressHUD.h"
#import "AppConfig.h"
#import "OverTimeModel.h"
#import "CoinUtil.h"

@interface TLPublishSellVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIView *contentView;
//价格
@property (nonatomic, strong) TLPublishInputView *priceView;
//溢价
@property (nonatomic, strong) TLPublishInputView *premiumView;
//保护价
@property (nonatomic, strong) TLPublishInputView *protectPriceView;
//最小量
@property (nonatomic, strong) TLPublishInputView *minTradeAmountView;
//最大量
@property (nonatomic, strong) TLPublishInputView *maxTradeAmountView;
//出售总量
@property (nonatomic, strong) TLPublishInputView *totalTradeCountView;

//卖出时用于显示余额
@property (nonatomic, strong) TLAdpaterView *balanceView;

//收款方式
@property (nonatomic, strong) TLPublishInputView *payTypeView;
//收款期限
@property (nonatomic, strong) TLPublishInputView *payTimeLimitView;
//留言
@property (nonatomic, strong) TLTextView *leaveMsgTextView;
@property (nonatomic, strong) TLHighLevelSettingsView *highLevelSettingsView;

//
@property (nonatomic, strong) FilterView *payTypePickerView;
@property (nonatomic, strong) FilterView *payTimeLimitPickerView;

//
@property (nonatomic, strong) QuotationModel *quotationModel;
@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, copy) NSString *payType;

@end

@implementation TLPublishSellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
//     [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[BMEnableIQKeyboardView class]];
    
    self.title = [LangSwitcher switchLang:@"发布卖出" key:nil];
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
    
}

-(void)tl_placeholderOperation {
    
    // 行情
    NBCDRequest *hangQingReq = [NBCDRequest alloc] ;
    hangQingReq.code = @"625292";
    hangQingReq.parameters[@"coin"] = kETH;
    
    //时间选择
    NBCDRequest *timeChooseReq = [NBCDRequest alloc] ;
    timeChooseReq.code = @"625907";
    timeChooseReq.parameters[@"parentKey"] = @"trade_time_out";
    timeChooseReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
    timeChooseReq.parameters[@"companyCode"] = [AppConfig config].companyCode;
    
//    //获取广告详情
//    NBCDRequest *adsDetailReq = [NBCDRequest alloc] ;
//    adsDetailReq.code = @"625907";
//    adsDetailReq.parameters[@"parentKey"] = @"trade_time_out";
//    adsDetailReq.parameters[@"userId"] = [AppConfig config].systemCode;
//    adsDetailReq.parameters[@"token"] = [AppConfig config].systemCode;

    

    [TLProgressHUD showWithStatus:nil];
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[hangQingReq,timeChooseReq]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        
        //
        [self removePlaceholderView];
        
        //处理数据
        PublishService *publishService = [PublishService shareInstance];
        
        // 行情
        NBCDRequest *hangQingReqCopy = (NBCDRequest *)batchRequest.reqArray[0];
        
        //时间选择
        NBCDRequest *timeChooseReqCopy = (NBCDRequest *)batchRequest.reqArray[1];
        [publishService handleOutLimitTime:timeChooseReqCopy.responseObject[@"data"]];
        
        [self setUpUI];
        
        //
        [self addLayout];
      
        //
        [self addEvent];
        
        //
        [self data];
        

        // 控件在 setUpUI中初始化
        self.payTypePickerView.tagNames = [PayTypeModel payTypeNames];
        self.payTimeLimitPickerView.tagNames = [publishService obtainLimitTimes];
        
        [self handleHangQingWithRes:hangQingReqCopy.responseObject];
        
        
    } failure:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];

    }];
    
}

- (void)handleHangQingWithRes:(id)res {
    
    
    self.quotationModel = [QuotationModel tl_objectWithDictionary:res[@"data"]];
    self.priceView.textField.text = [NSString stringWithFormat:@"%.2lf", [self.quotationModel.mid doubleValue]];
    
}

- (void)getLeftAmount {
    
    CoinWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"802503";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.isList = YES;
    helper.isCurrency = YES;
    [helper modelClass:[CurrencyModel class]];
    
    [helper refresh:^(NSMutableArray <CurrencyModel *>*objs, BOOL stillHave) {
        
        [objs enumerateObjectsUsingBlock:^(CurrencyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.currency isEqualToString:@"ETH"]) {
                
                NSString *str = [obj.amountString subNumber:obj.frozenAmountString];
                str = [str convertToSimpleRealCoin];
                weakSelf.balanceView.contentLbl.text = [NSString stringWithFormat:@"    账户可用余额：%@",str];
                
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

//- (void)hangQing {
//
//    __weak typeof(self) weakself = self;
//    //
//    TLNetworking *http = [TLNetworking new];
//    http.code = @"625292";
//    http.parameters[@"coin"] = kETH;
//    http.showView = self.view;
//    //
//    [http postWithSuccess:^(id responseObject) {
//
//        [self removePlaceholderView];
//
//        [self setUpUI];
//        //
//        [self addLayout];
//        //
//        [self data];
//        //
//        [self addEvent];
//
//        //
////        self.pa
//
//
//        self.payTypePickerView.tagNames = [PayTypeModel payTypeNames];
//        [self.payTypePickerView setSelectBlock:^(NSInteger index) {
//
//            weakself.payTypeView.textField.text = [PayTypeModel payTypeNames][index];
//            weakself.payType = [NSString stringWithFormat:@"%ld",index];
//
//        }];
//
//        //
//        self.payTimeLimitPickerView.tagNames = [PublishService];
//        self.quotationModel = [QuotationModel tl_objectWithDictionary:responseObject[@"data"]];
//        self.priceView.textField.text = [NSString stringWithFormat:@"%.2lf", [self.quotationModel.mid doubleValue]];
//
//
//
//
//
//    } failure:^(NSError *error) {
//
//        [self addPlaceholderView];
//
//    }];
//
//}

#pragma mark -提交事件
- (void)publish {
    
    NSString *premium = self.premiumView.textField.text;
    NSString *protectPrice = self.protectPriceView.textField.text;
    NSString *min = self.minTradeAmountView.textField.text;
    NSString *max = self.maxTradeAmountView.textField.text;
    NSString *payTimeLimit = self.payTimeLimitView.textField.text;
    NSString *leaveMsg = self.leaveMsgTextView.text;
    NSString *totalCount = self.totalTradeCountView.textField.text;
    NSString *payType = self.payType;
    
    NSString *onlyTrust = [self.highLevelSettingsView isOnlyTrust] ? @"1" : @"0";
    NSString *tradeType = kPublishTradeTypeSell;

    
//    CGFloat rate = [draft.premiumRate doubleValue]/100.0;
//    NSString *premiumRate = [NSString stringWithFormat:@"%.2lf", rate];
//    http.parameters[@"totalCount"] = [draft.buyTotal convertToSysCoin];
//    CoinWeakSelf;

    if (![premium valid]) {
        
        [TLAlert alertWithInfo:@"请输入溢价比例"];
        return ;
    }
    
    if (![protectPrice valid]) {
        
        [TLAlert alertWithInfo:@"请输入最低可成交的价格"];
        return ;
    }
    
    if (![min valid]) {
        
        [TLAlert alertWithInfo:@"请输入交易的最小限额"];
        return ;
    }
    
    if (![max valid]) {
        
        [TLAlert alertWithInfo:@"请输入交易的最大限额"];
        return ;
    }
    
    if (![totalCount valid]) {
        
        [TLAlert alertWithInfo:@"请输入出售总量"];
        return ;
    }
    
    if (![payType valid]) {
        
        [TLAlert alertWithInfo:@"请选择收款方式"];
        return ;
    }
    
    if (![payTimeLimit valid]) {
        
        [TLAlert alertWithInfo:@"请选择收款期限"];
        return ;
    }
    
    if (![leaveMsg valid]) {
        
        [TLAlert alertWithInfo:@"请填写广告留言"];
        return ;
    }
    

    //
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"625220";
    
    if (self.publishType == PublishTypePublishDraft) {
        
        http.parameters[@"publishType"] = kPublishDraft;
        http.parameters[@"adsCode"] = self.advertise.code;
        
    } else if (self.publishType == PublishTypePublishRedit) {
        
        //
        http.parameters[@"publishType"] = kPublishRedit;
        http.parameters[@"adsCode"] = self.advertise.code;
        
    } else if (self.publishType == PublishTypePublishOrSaveDraft) {
        
        //发布或者存草稿
        http.parameters[@"publishType"] = kPublish;
        
    }
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"leaveMessage"] = leaveMsg;
    http.parameters[@"maxTrade"] = max;
    http.parameters[@"minTrade"] = min;
    http.parameters[@"onlyTrust"] = onlyTrust;
    http.parameters[@"payLimit"] = payTimeLimit;
    http.parameters[@"payType"] = payType;
    http.parameters[@"premiumRate"] = [NSString stringWithFormat:@"%f",[premium doubleValue]/100.0];
    http.parameters[@"protectPrice"] = protectPrice;
    http.parameters[@"totalCount"] = [CoinUtil convertToSysCoin:totalCount coin:kETH];
    http.parameters[@"tradeCurrency"] = @"CNY";
    http.parameters[@"tradeCoin"] = kETH;
    http.parameters[@"tradeType"] = tradeType;
    
    if ([self.highLevelSettingsView isCustomTime]) {
        
        http.parameters[@"displayTime"] = [self.highLevelSettingsView obtainDisplayTimes];
        
    }

    
    [http postWithSuccess:^(id responseObject) {
        
//        NSString *str = draft.isPublish == YES ? @"发布成功": @"保存成功";
//        [TLAlert alertWithSucces:str];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.tabBarController.selectedIndex = 2;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseListRefresh object:@"0"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark- 选择支付方式
- (void)choosePayType {
    
    [self.payTypePickerView show];
    
}

#pragma mark- 选择付款期限
- (void)choosePayLimit {
    
    [self.payTimeLimitPickerView show];
    
}

#pragma mark- 添加事件
- (void)addEvent {
    __weak typeof(self) weakself = self;
    
    [self.highLevelSettingsView.topBtn addTarget:self
                                          action:@selector(change)
                                forControlEvents:UIControlEventTouchUpInside];
    [self.premiumView.textField addTarget:self
                                   action:@selector(textDidChange:)
                         forControlEvents:UIControlEventEditingChanged];
    
    //
    [self.payTypeView.maskBtn addTarget:self action:@selector(choosePayType) forControlEvents:UIControlEventTouchUpInside];
    [self.payTimeLimitView.maskBtn addTarget:self action:@selector(choosePayLimit) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [self.payTypePickerView setSelectBlock:^(NSInteger index) {
        
        weakself.payTypeView.textField.text = [PayTypeModel payTypeNames][index];
        weakself.payType = [NSString stringWithFormat:@"%ld",index];
        
    }];
    
    //设置时间
    [self.payTimeLimitPickerView setSelectBlock:^(NSInteger index) {
        
        weakself.payTimeLimitView.textField.text = [[PublishService shareInstance] obtainLimitTimes][index];
        
    }];

}

#pragma 溢价率的输入事件处理
- (void)textDidChange:(UITextField *)sender {
    
    CGFloat preRate = [sender.text doubleValue];
    
    if (preRate > -100 && preRate < 100) {
        
        CGFloat prePrice = [self.quotationModel.mid doubleValue]*(preRate/100.0 + 1);
        self.priceView.textField.text = [NSString stringWithFormat:@"%.2lf", prePrice];
        
    } else {
        
        [TLAlert alertWithInfo:@"溢价率应在-99.99~99.99之间"];
    }
    
}


- (void)change {
    

    self.highLevelSettingsView.height = [self.highLevelSettingsView nextShouldHeight];
    self.contentView.height = self.highLevelSettingsView.bottom;
    
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.contentView.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = CGRectMake(0, self.bgScrollView.height, self.bgScrollView.width, self.bgScrollView.contentSize.height - self.bgScrollView.height);
        [self.bgScrollView scrollRectToVisible:frame animated:YES];
        
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        CGRect frame = CGRectMake(0, self.bgScrollView.contentSize.height, self.bgScrollView.width, 0);
//        [self.bgScrollView scrollRectToVisible:frame animated:YES];
//
//    });
 
}

#pragma mark- 添加约束
- (void)addLayout {
    
    self.contentView.height = self.highLevelSettingsView.yy;
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.contentView.height);
    //
//    [self.highLevelSettingsView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.leaveMsgTextView.mas_bottom);
//        make.left.right.equalTo(self.contentView);
//        make.height.mas_equalTo([TLHighLevelSettingsView normalHeight]);
//
//    }];
//    //
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.equalTo(self.bgScrollView.mas_width);
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//        make.top.equalTo(self.priceView.mas_top);
//        make.bottom.equalTo(self.highLevelSettingsView.mas_bottom);
//
//    }];
    
    
    
}

- (void)data {
    
    //    self.balanceView.contentLbl.text = [NSString stringWithFormat:@"账户可用余额：%@",@"10.2"];
    
    if (!self.advertise) {
        return;
    }
    
    //数据
    //支付方式
    self.payType = self.advertise.payType;
    self.payTypeView.textField.text = [PayTypeModel payNameByType:self.advertise.payType];
    
    //付款时间
    self.payTimeLimitView.textField.text = [NSString stringWithFormat:@"%ld",self.advertise.payLimit];
    
    self.highLevelSettingsView.onlyTrustBtn.selected = [self.advertise.isTrust isEqual:kOnlyTrustYes];
    
    //
    if (self.advertise.displayTime && self.advertise.displayTime.count > 0) {
        
        //自定义时间
        [self.highLevelSettingsView beginWithCustomTime];
        
//        self.advertise.displayTime
//        self.highLevelSettingsView.displayTimes
        
    } else {
        
        
        //全部可见
        [self.highLevelSettingsView beginWithAnyime];
        
    }
    
}


//- (void)addRightItem {
//
//    if (self.publishType == PublishTypePublishOrSaveDraft) {
//
//
//        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"保存草稿" key:nil]
//                                    titleColor:kTextColor
//                                         frame:CGRectMake(0, 0, 70, 44)
//                                            vc:self
//                                        action:@selector(keepDraft)];
//
//
//    } else if (self.publishType == PublishTypePublishRedit) {
//        //重新编辑，为下架
//        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"下架" key:nil]
//                                    titleColor:kTextColor
//                                         frame:CGRectMake(0, 0, 70, 44)
//                                            vc:self
//                                        action:@selector(xiaJia)];
//
//    }
//
//
//}

- (void)setUpUI {
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - 65)];
    [self.view addSubview:self.bgScrollView];
    
    //底部提交按钮
    //发布按钮
    UIButton *publishBtn = [UIButton buttonWithTitle:@"直接发布" titleColor:kWhiteColor backgroundColor:kThemeColor titleFont:16.0 cornerRadius:5];
    [publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bgScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.bgScrollView.mas_left).offset(20);
        make.right.equalTo(self.bgScrollView.mas_right).offset(-20);
        make.height.equalTo(@(45));
        
    }];
    
    //
//    self
    
    //
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgScrollView.width, 0)];
    [self.bgScrollView addSubview:self.contentView];
    
    CGFloat height = 45;
    CGFloat width = SCREEN_WIDTH;
    
    //价格
    self.priceView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.contentView addSubview:self.priceView];
    self.priceView.leftLbl.text = [LangSwitcher switchLang:@"价        格" key:nil];
    self.priceView.textField.placeholder = [LangSwitcher switchLang:@"" key:nil];
    self.priceView.markLbl.text = kCNY;
    self.priceView.textField.userInteractionEnabled = NO;
    
    //溢价
    self.premiumView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.priceView.yy, width, height)];
    [self.contentView addSubview:self.premiumView];
    self.premiumView.leftLbl.text = [LangSwitcher switchLang:@"溢        价" key:nil];
    self.premiumView.textField.placeholder = [LangSwitcher switchLang:@"根据市场的溢价比例" key:nil];
    self.premiumView.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.premiumView.markLbl.text = @"%";
    
    //保护价
    self.protectPriceView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.premiumView.yy, width, height)];
    [self.contentView addSubview:self.protectPriceView];
    self.protectPriceView.leftLbl.text = [LangSwitcher switchLang:@"最  低  价" key:nil];
    self.protectPriceView.textField.placeholder = [LangSwitcher switchLang:@"广告最低可成交的价格" key:nil];
    self.protectPriceView.markLbl.text = kCNY;
    
    //最小量
    self.minTradeAmountView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.protectPriceView.yy, width, height)];
    [self.contentView addSubview:self.minTradeAmountView];
    self.minTradeAmountView.leftLbl.text = [LangSwitcher switchLang:@"最  小  量" key:nil];
    self.minTradeAmountView.textField.placeholder = [LangSwitcher switchLang:@"每笔交易的最小限额" key:nil];
    self.minTradeAmountView.markLbl.text = kCNY;
    
    //最大量
    self.maxTradeAmountView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.minTradeAmountView.yy, width, height)];
    [self.contentView addSubview:self.maxTradeAmountView];
    self.maxTradeAmountView.leftLbl.text = [LangSwitcher switchLang:@"最  大  量" key:nil];
    self.maxTradeAmountView.textField.placeholder =  [LangSwitcher switchLang:@"每笔交易的最大限额" key:nil];
    self.maxTradeAmountView.markLbl.text = kCNY;
    
    //出售总量
    self.totalTradeCountView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.maxTradeAmountView.yy, width, height)];
    [self.contentView addSubview:self.totalTradeCountView];
    self.totalTradeCountView.leftLbl.text = [LangSwitcher switchLang:@"出售总量" key:nil];
    self.totalTradeCountView.textField.placeholder = [LangSwitcher switchLang:@"请输入出售总量" key:nil];
    self.totalTradeCountView.markLbl.text = kETH;
    
    //账户可用·余额
    self.balanceView = [[TLAdpaterView alloc] initWithFrame:CGRectMake(0,self.totalTradeCountView.yy , width, 25)];
    [self.contentView addSubview:self.balanceView];
    self.balanceView.contentLbl.text = @"--";
    
    //收款方式
    self.payTypeView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.balanceView.yy, width, height)];
    [self.contentView addSubview:self.payTypeView];
    self.payTypeView.textField.enabled = NO;
    self.payTypeView.leftLbl.userInteractionEnabled = YES;
    self.payTypeView.leftLbl.text = [LangSwitcher switchLang:@"收款方式" key:nil];
    self.payTypeView.textField.placeholder = [LangSwitcher switchLang:@"请选择收款方式" key:nil];
    self.payTypeView.markImageView.image = [UIImage imageNamed:@"更多-灰色"];
    [self.payTypeView adddMaskBtn];
    
    //收款期限
    self.payTimeLimitView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.payTypeView.yy, width, height)];
    [self.contentView addSubview:self.payTimeLimitView];
    self.payTimeLimitView.leftLbl.text = [LangSwitcher switchLang:@"收款期限" key:nil];
    self.payTimeLimitView.textField.placeholder = [LangSwitcher switchLang:@"请选择收款期限" key:nil];
    self.payTimeLimitView.markLbl.text = [LangSwitcher switchLang:@"分钟" key:nil];
    self.payTimeLimitView.textField.enabled = NO;
    [self.payTimeLimitView adddMaskBtn];

    //留言
    self.leaveMsgTextView = [[TLTextView alloc] initWithFrame:CGRectMake(0, self.payTimeLimitView.yy, width, 120)];
    [self.contentView addSubview:self.leaveMsgTextView];
    self.leaveMsgTextView.font = Font(14.0);
    self.leaveMsgTextView.placeholderLbl.font  = self.leaveMsgTextView.font;
    self.leaveMsgTextView.placholder = [LangSwitcher switchLang:@"请写下您的广告留言吧" key:nil];
    self.leaveMsgTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    //高级设置
    self.highLevelSettingsView = [[TLHighLevelSettingsView alloc] initWithFrame:CGRectMake(0, self.leaveMsgTextView.yy, width, [TLHighLevelSettingsView normalHeight])];
    [self.contentView addSubview:self.highLevelSettingsView];
    
    
    //支付方式选择
    self.payTypePickerView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.payTypePickerView.title = [LangSwitcher switchLang:@"请选择支付方式" key:nil];
    
    //超时时间
    self.payTimeLimitPickerView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    
    
}

@end
