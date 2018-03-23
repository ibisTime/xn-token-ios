//
//  TLPublishSellVC.m
//  Coin
//
//  Created by  tianlei on 2018/1/03.
//  Copyright © 2018年  tianlei. All rights reserved.
#import "TLPushPublishVC.h"
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
#import "PushPublishService.h"
#import "AdvertiseModel.h"
#import "FilterView.h"
#import "PayTypeModel.h"
#import <NBHTTP/NBNetwork.h>
#import "TLProgressHUD.h"
#import "AppConfig.h"
#import "OverTimeModel.h"
#import "CoinUtil.h"
#import "UIBarButtonItem+convience.h"
#import "ZMAuthVC.h"
#import "TLNotficationService.h"

@interface TLPushPublishVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIView *contentView;
//交易币种
@property (nonatomic, strong) TLPublishInputView *tradeCoinView;
//@property (nonatomic, strong) UILabel *marketPriceLbl;
@property (nonatomic, strong) TLAdpaterView *marketPriceView;
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
@property (nonatomic, strong) FilterView *coinPickerView;
//
@property (nonatomic, strong) QuotationModel *quotationModel;
@property (nonatomic, strong) AdvertiseModel *advertise;

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *currentCurrency;

@end

@implementation TLPushPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *coins = [CoinUtil shouldDisplayTokenCoinArray];
    
    //预设一个
//    self.firstCoin =  self.firstCoin ? : kETH;
    self.currentCurrency = coins[0];
    //     [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[BMEnableIQKeyboardView class]];
    NSString *tradeType = self.VCType == TLPushPublishVCTypeSell ? kPushPublishTradeTypeSell : kPushPublishTradeTypeBuy;
    //必须先进行配置
    [[PushPublishService shareInstance] configWith:tradeType];
    self.title = [PushPublishService shareInstance].publishTitle;
    
    //买币需要进行实名认证
    //判断是否已经实名
    if (tradeType == kPushPublishTradeTypeBuy) {
        
        if (![[TLUser user].realName valid]) {
            // 进行实名认证
            [self setPlaceholderViewTitle:@"您还未进行实名认证" operationTitle:@"前往认证"];
            [self addPlaceholderView];
            [self goReanNameAuth];
            
        } else {
            
            [self realNameAuthAfter];
            [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
        }
        
    } else {
        
        [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
        [self tl_placeholderOperation];
        
    }
   
}

- (void)goReanNameAuth {
    
    ZMAuthVC *vc = [[ZMAuthVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setSuccess:^{
        
        [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
        [self removePlaceholderView];
        [self realNameAuthAfter];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
}


- (void)realNameAuthAfter {
    
    [self tl_placeholderOperation];

}

-(void)tl_placeholderOperation {
    
    if ([PushPublishService shareInstance].tradeType == kPushPublishTradeTypeBuy) {
        
        if (![[TLUser user].realName valid]) {
            // 进行实名认证
            [self setPlaceholderViewTitle:@"您还未进行实名认证" operationTitle:@"前往认证"];
            [self goReanNameAuth];
            return;
        }
        
    }
    
    //行情
//    NBCDRequest *hangQingReq = [self hangQingReq];
    
    //时间选择
    NBCDRequest *timeChooseReq = [[NBCDRequest alloc] init];
//    timeChooseReq.code = @"625907";
    timeChooseReq.code = @"660906";
    timeChooseReq.parameters[@"parentKey"] = @"trade_time_out";
    timeChooseReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
    timeChooseReq.parameters[@"companyCode"] = [AppConfig config].companyCode;

    //右边的交易提醒
    NBCDRequest *hintReq = [[NBCDRequest alloc] init];
    hintReq.code = @"660915";
    hintReq.parameters[@"start"] = @"1";
    hintReq.parameters[@"limit"] = @"30";
    hintReq.parameters[@"parent"] = [PushPublishService shareInstance].ads_hint_key;
    hintReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
    hintReq.parameters[@"companyCode"] = [AppConfig config].companyCode;
    
    //获取广告详情
    NBCDRequest *adsDetailReq = [[NBCDRequest alloc] init];
    adsDetailReq.code = @"625226";
    adsDetailReq.parameters[@"adsCode"] = self.adsCode;
    adsDetailReq.parameters[@"userId"] = [AppConfig config].systemCode;
    adsDetailReq.parameters[@"token"] = [TLUser user].token;
    
    [TLProgressHUD showWithStatus:nil];
    NSArray *reqArr = nil;
    if(self.adsCode) {
        
        reqArr = @[timeChooseReq,hintReq,adsDetailReq];
//        reqArr = @[hangQingReq,timeChooseReq,adsDetailReq];

    } else {
        
        reqArr = @[timeChooseReq,hintReq];
//        reqArr = @[hangQingReq,timeChooseReq];
    }
    //
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:reqArr];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        
        //
        [self removePlaceholderView];
        
        //处理数据
        PushPublishService *pushPublishService = [PushPublishService shareInstance];
        
        // 行情
//        NBCDRequest *hangQingReqCopy = (NBCDRequest *)batchRequest.reqArray[0];
        
        //时间选择
        NBCDRequest *timeChooseReqCopy = (NBCDRequest *)batchRequest.reqArray[0];
        [pushPublishService handleOutLimitTime:timeChooseReqCopy.responseObject[@"data"]];
        
        //交易提醒
        if (batchRequest.reqArray.count > 1) {
            
            NBCDRequest *hintReqCopy = (NBCDRequest *)batchRequest.reqArray[1];
            [pushPublishService handleHint:hintReqCopy.responseObject];
        }
        
        if(batchRequest.reqArray.count > 2) {
            //广告详情可能没有
            NBCDRequest *adsDetailReqCopy = (NBCDRequest *)batchRequest.reqArray[2];
            self.advertise = [AdvertiseModel tl_objectWithDictionary:adsDetailReqCopy.responseObject[@"data"]];
            
        }
        
        [self setUpUI];
        [self addRightItem];
        
        //
        [self addLayout];
        
        //
        [self addEvent];
        
        // 控件在 setUpUI中初始化
        self.payTypePickerView.tagNames = [PayTypeModel payTypeNames];
        self.payTimeLimitPickerView.tagNames = [pushPublishService obtainLimitTimes];
        self.payTimeLimitView.textField.text = [[pushPublishService obtainLimitTimes] objectAtIndex:0];
        
//        [self handleHangQingWithRes:hangQingReqCopy.responseObject];
        
        
        //注意顺序
        [self dataAndRule];
        
        //获取余额
        [self getLeftAmount];
        
    } failure:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];
        
    }];
    
}

- (void)handleHangQingWithRes:(id)res {
    
    self.quotationModel = [QuotationModel tl_objectWithDictionary:res[@"data"]];
    self.marketPriceView.contentLbl.text = [[PushPublishService shareInstance] convertHangQing:[self.quotationModel.mid stringValue]];
    
    //如果有溢价应该 x 溢价率
    NSString *premiumStr = self.premiumView.textField.text;
    if ([premiumStr valid]) {
        
        self.priceView.textField.text = [AdvertiseModel calculateTruePriceByPreYiJia:[premiumStr floatValue]
                                                                         marketPrice:[self.quotationModel.mid floatValue]];
        
    } else {
        
        self.priceView.textField.text = [NSString stringWithFormat:@"%.2lf", [self.quotationModel.mid doubleValue]];
        
    }

    
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
            
            if ([obj.currency isEqualToString:self.currentCurrency]) {
                
                NSString *str = [obj.amountString subNumber:obj.frozenAmountString];
                str = [CoinUtil convertToRealCoin:str coin:self.currentCurrency];
                weakSelf.balanceView.contentLbl.text = [NSString stringWithFormat:@"账户可用余额：%@",str];
                
            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)changeMarketLblCoin:(NSString *)coin {
    
    self.tradeCoinView.markLbl.text = coin;
    self.totalTradeCountView.markLbl.text = coin;

}

- (void)publish {
    
    [self publishWithType:kPushPublish];
    
}

#pragma mark -提交事件
- (void)publishWithType:(NSString *)publishOrSaveDraft {
    NSString *truePrice = self.priceView.textField.text;
    NSString *min = self.minTradeAmountView.textField.text;
    NSString *max = self.maxTradeAmountView.textField.text;
    NSString *payTimeLimit = self.payTimeLimitView.textField.text;
    NSString *leaveMsg = self.leaveMsgTextView.text;
    NSString *totalCount = self.totalTradeCountView.textField.text;
    NSString *payType = self.payType;
    NSString *tradeCoin = self.tradeCoinView.textField.text;
    NSString *onlyTrust = [self.highLevelSettingsView isOnlyTrust] ? kOnlyTrustYes : kOnlyTrustNO;
    
    NSString *tradeType = [PushPublishService shareInstance].tradeType;
    
    
    if (![truePrice valid]) {
        
        [TLAlert alertWithInfo:@"请输入您想发布的价格"];
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
    
    if (self.publishType == PushPublishTypePublishDraft) {
        //草稿发布
        
        http.parameters[@"publishType"] = kPushPublishDraft;
        http.parameters[@"adsCode"] = self.advertise.code;
        
    } else if (self.publishType == PushPublishTypePublishRedit) {
        
        //重新编辑发布，原广告下架
        http.parameters[@"publishType"] = kPushPublishRedit;
        http.parameters[@"adsCode"] = self.advertise.code;
        
    } else if (self.publishType == PushPublishTypePublishOrSaveDraft) {
        //首次编辑
        //发布或者存草稿
        http.parameters[@"publishType"] = publishOrSaveDraft;
        
    }
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"leaveMessage"] = leaveMsg;
    http.parameters[@"maxTrade"] = max;
    http.parameters[@"minTrade"] = min;
    http.parameters[@"onlyTrust"] = onlyTrust;
    http.parameters[@"payLimit"] = payTimeLimit;
    http.parameters[@"payType"] = payType;
    http.parameters[@"premiumRate"] = @"0";
    http.parameters[@"truePrice"] = truePrice;
    http.parameters[@"protectPrice"] = truePrice;
    http.parameters[@"totalCount"] = [CoinUtil convertToSysCoin:totalCount coin:self.currentCurrency];
    http.parameters[@"tradeCurrency"] = @"CNY";
    http.parameters[@"tradeCoin"] = tradeCoin;
    http.parameters[@"tradeType"] = tradeType;
    
    
    if ([self.highLevelSettingsView isCustomTime]) {
        
        http.parameters[@"displayTime"] = [self.highLevelSettingsView obtainDisplayTimes];
        
    }
    
//    return;
    [http postWithSuccess:^(id responseObject) {
        
        //        NSString *str = draft.isPublish == YES ? @"发布成功": @"保存成功";
        //        [TLAlert alertWithSucces:str];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        });
        
        TLNotificationObj *notificationObj = [[TLNotificationObj alloc] init];
        notificationObj.name = kAdvertiseListRefresh;
        notificationObj.type = TLNotificationTypeRefreshAdsList;
        notificationObj.content = tradeCoin;
        notificationObj.subContent = tradeType;
        notificationObj.contentIntroduce = @"content 为币种，subContent 为交易类型 ";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationObj.name
                          object:notificationObj];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma 选择币种
- (void)chooseCoin {
    
    __weak typeof(self) weakself = self;
    [self.coinPickerView show];
    [self.coinPickerView setSelectBlock2:^(NSInteger index, NSString *tagName) {
        
        if ([tagName isEqualToString:weakself.currentCurrency]) {
            //和上次币种相同，那就不进行信息变更
            return ;
        }
        
        //清楚一些信息
        weakself.premiumView.textField.text = nil;
        weakself.protectPriceView.textField.text = nil;
        weakself.minTradeAmountView.textField.text = nil;
        weakself.maxTradeAmountView.textField.text = nil;
        weakself.totalTradeCountView.textField.text = nil;


 
        //0.改变当前币种
        weakself.currentCurrency = tagName;
        
        //1.
        weakself.tradeCoinView.textField.text = tagName;
        weakself.tradeCoinView.markLbl.text = tagName;
        weakself.totalTradeCountView.markLbl.text = tagName;
        
        //2. 行情价格和价格要改变
        
        //3.更新可用余额
        [weakself getLeftAmount];
        
        
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

- (NBCDRequest *)hangQingReq {

    NBCDRequest *hangQingReq = [[NBCDRequest alloc] init];
    hangQingReq.code = @"625292";
    hangQingReq.parameters[@"coin"] = self.currentCurrency;
    return hangQingReq;
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
    
    //币种
    [self.tradeCoinView.maskBtn addTarget:self action:@selector(chooseCoin) forControlEvents:UIControlEventTouchUpInside];
    
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
        
        weakself.payTimeLimitView.textField.text = [[PushPublishService shareInstance] obtainLimitTimes][index];
        
    }];
    
}

//保存草稿
- (void)saveDraft {
    
    [self publishWithType:kPushSaveDraft];
    
    
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
    
    [self changeWithScrollToBottom:YES];
    
}
- (void)changeWithScrollToBottom:(BOOL)isToBottom {
    
    
    self.highLevelSettingsView.height = [self.highLevelSettingsView nextShouldHeight];
    self.contentView.height = self.highLevelSettingsView.bottom;
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.contentView.height);
    
    if (!isToBottom) {
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = CGRectMake(0, self.bgScrollView.height, self.bgScrollView.width, self.bgScrollView.contentSize.height - self.bgScrollView.height);
        [self.bgScrollView scrollRectToVisible:frame animated:YES];
        
    }];
    
}

#pragma mark- 添加约束
- (void)addLayout {
    
    self.contentView.height = self.highLevelSettingsView.yy;
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.contentView.height);
    
}

- (void)dataAndRule {
    

    self.tradeCoinView.textField.text = self.currentCurrency;
    [self changeMarketLblCoin:self.currentCurrency];
    //
    if (self.publishType == PushPublishTypePublishRedit) {
        
        self.tradeCoinView.maskBtn.userInteractionEnabled = NO;
        
    }
    //
    if (!self.advertise) {
        return;
    }
    
    [self changeMarketLblCoin:self.advertise.tradeCoin];

    //币种
    self.currentCurrency = self.advertise.tradeCoin;
    self.tradeCoinView.textField.text = self.currentCurrency;
    
    //
    self.premiumView.textField.text = [NSString stringWithFormat:@"%.2f",[self.advertise.premiumRate floatValue] *100];
    
    //最大最小
    self.protectPriceView.textField.text = [self.advertise.protectPrice stringValue];
    self.minTradeAmountView.textField.text = [self.advertise.minTrade stringValue];
    self.maxTradeAmountView.textField.text = [self.advertise.maxTrade stringValue];
    self.totalTradeCountView.textField.text = [CoinUtil convertToRealCoin:self.advertise.totalCountString
                                                                     coin:self.advertise.tradeCoin];

    
    //价格
    self.priceView.textField.text = [self.advertise.truePrice stringValue];
    
    //广告留言
    self.leaveMsgTextView.text = self.advertise.leaveMessage;
    
    //数据
    //支付方式
    self.payType = self.advertise.payType;
    self.payTypeView.textField.text = [PayTypeModel payNameByType:self.advertise.payType];
    
    //付款时间
    self.payTimeLimitView.textField.text = [NSString stringWithFormat:@"%ld",self.advertise.payLimit];
    
    
    //
    BOOL shouldDisplayCustomTime = self.advertise.displayTime && self.advertise.displayTime.count > 0;
    BOOL shouldDisplayOnlyTrust = [self.advertise.onlyTrust isEqual:kOnlyTrustYes];
    self.highLevelSettingsView.onlyTrustBtn.selected = shouldDisplayOnlyTrust;
    
    if (shouldDisplayCustomTime) {
        
        //自定义时间
        [self.highLevelSettingsView beginWithCustomTime];
        self.highLevelSettingsView.displayTime = self.advertise.displayTime;
        
    } else {
        
        //全部可见
        [self.highLevelSettingsView beginWithAnyime];
        
    }
    
    if (shouldDisplayOnlyTrust || shouldDisplayCustomTime) {
        
        [self changeWithScrollToBottom:NO];
        
    }
    
}

- (void)addRightItem {
    
    if (!self.adsCode || self.adsCode.length == 0 ) {
        //没有传广告编号，肯定是第一次编辑
//        self.publishType == PublishTypePublishOrSaveDraft
        
        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"保存草稿" key:nil]
                                    titleColor:kTextColor
                                         frame:CGRectMake(0, 0, 70, 44)
                                            vc:self
                                        action:@selector(saveDraft)];
        
        
    } else if (self.publishType == PushPublishTypePublishRedit) {
        //重新编辑，为下架
        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"下架" key:nil]
                                    titleColor:kTextColor
                                         frame:CGRectMake(0, 0, 70, 44)
                                            vc:self
                                        action:@selector(xiaJia)];
        
    }
    
    
}


#pragma mark- 重新编辑时，右上角为下架
//下架广告
- (void)xiaJia {
    
    CoinWeakSelf;
    
    [TLAlert alertWithTitle:[LangSwitcher switchLang:@"提示" key:nil]
                        msg:[LangSwitcher switchLang:@"您确定要下架此广告?" key:nil]
                 confirmMsg:[LangSwitcher switchLang:@"确认" key:nil]
                  cancleMsg:[LangSwitcher switchLang:@"取消" key:nil]
                     cancle:^(UIAlertAction *action) {
                         
                         
                     } confirm:^(UIAlertAction *action) {
                         
                         [weakSelf requestAdvertiseOff];
                     }];
    
}

//下架广告
- (void)requestAdvertiseOff {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625224";
    http.showView = self.view;
    http.parameters[@"adsCode"] = self.advertise.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"下架成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseOff object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setUpUI {
    
    
    PushPublishService *pushPublishService = [PushPublishService shareInstance];
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
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgScrollView.width, 0)];
    [self.bgScrollView addSubview:self.contentView];
    
    CGFloat height = 45;
    CGFloat width = SCREEN_WIDTH;
    
    //
    self.tradeCoinView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.contentView addSubview:self.tradeCoinView];
    self.tradeCoinView.leftLbl.text = [LangSwitcher switchLang:@"币        种" key:nil];
    self.tradeCoinView.textField.placeholder = [LangSwitcher switchLang:@"请选择交易币种" key:nil];
    self.tradeCoinView.hintMsg = pushPublishService.tradeCoin;
    self.tradeCoinView.textField.userInteractionEnabled = NO;
    [self.tradeCoinView adddMaskBtn];
    
    //把市场价格显示出来
//    self.marketPriceView = [[TLAdpaterView alloc] initWithFrame:CGRectMake(0, self.tradeCoinView.yy, width, 30)];
//    [self.contentView addSubview:self.marketPriceView];
//    self.marketPriceView.contentLbl.text = [[PushPublishService shareInstance] convertHangQing:@"--"];

    //价格
    self.priceView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.tradeCoinView.yy, width, height)];
    [self.contentView addSubview:self.priceView];
    self.priceView.leftLbl.text = [LangSwitcher switchLang:@"价        格" key:nil];
    self.priceView.textField.placeholder = [LangSwitcher switchLang:@"" key:nil];
    self.priceView.markLbl.text = kCNY;
    self.priceView.hintMsg = pushPublishService.price;
//    self.priceView.textField.userInteractionEnabled = NO;
    
    //溢价
//    self.premiumView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.priceView.yy, width, height)];
//    [self.contentView addSubview:self.premiumView];
//    self.premiumView.leftLbl.text = [LangSwitcher switchLang:@"溢        价" key:nil];
//    self.premiumView.textField.placeholder = [LangSwitcher switchLang:@"根据市场的溢价比例" key:nil];
//    self.premiumView.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    self.premiumView.markLbl.text = @"%";
//    self.premiumView.hintMsg = pushPublishService.premiumRate;
    
    //保护价
//    self.protectPriceView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.priceView.yy, width, height)];
//    [self.contentView addSubview:self.protectPriceView];
//    self.protectPriceView.leftLbl.text = [PushPublishService  shareInstance].protectPriceDisplay;
//    self.protectPriceView.textField.placeholder = [PushPublishService  shareInstance].protectPricePlaceholder;
//    self.protectPriceView.markLbl.text = kCNY;
//    self.protectPriceView.hintMsg = pushPublishService.protectPrice;
    
    //最小量
    self.minTradeAmountView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.priceView.yy, width, height)];
    [self.contentView addSubview:self.minTradeAmountView];
    self.minTradeAmountView.leftLbl.text = [LangSwitcher switchLang:@"最  小  量" key:nil];
    self.minTradeAmountView.textField.placeholder = [LangSwitcher switchLang:@"每笔交易的最小限额" key:nil];
    self.minTradeAmountView.markLbl.text = kCNY;
    self.minTradeAmountView.hintMsg = pushPublishService.minTrade;
    
    //最大量
    self.maxTradeAmountView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.minTradeAmountView.yy, width, height)];
    [self.contentView addSubview:self.maxTradeAmountView];
    self.maxTradeAmountView.leftLbl.text = [LangSwitcher switchLang:@"最  大  量" key:nil];
    self.maxTradeAmountView.textField.placeholder =  [LangSwitcher switchLang:@"每笔交易的最大限额" key:nil];
    self.maxTradeAmountView.markLbl.text = kCNY;
    self.maxTradeAmountView.hintMsg = pushPublishService.maxTrade;
    
    //出售总量
    self.totalTradeCountView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.maxTradeAmountView.yy, width, height)];
    [self.contentView addSubview:self.totalTradeCountView];
    self.totalTradeCountView.leftLbl.text = [PushPublishService shareInstance].totalCountHintText;
    self.totalTradeCountView.textField.placeholder = [PushPublishService shareInstance].totalCountHintPlaceholder;
    self.totalTradeCountView.hintMsg = pushPublishService.totalCount;
    self.totalTradeCountView.minDotAfterLong = 8;
    
    //账户可用·余额
    self.balanceView = [[TLAdpaterView alloc] initWithFrame:CGRectMake(0,self.totalTradeCountView.yy , width, 0)];
    [self.contentView addSubview:self.balanceView];
    self.balanceView.contentLbl.text = @"--";
    self.balanceView.height = [PushPublishService shareInstance].balanceHeight;
    
    //收款方式
    self.payTypeView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.balanceView.yy, width, height)];
    [self.contentView addSubview:self.payTypeView];
    self.payTypeView.textField.enabled = NO;
    self.payTypeView.leftLbl.userInteractionEnabled = YES;
    self.payTypeView.leftLbl.text = [LangSwitcher switchLang:@"收款方式" key:nil];
    self.payTypeView.textField.placeholder = [LangSwitcher switchLang:@"请选择收款方式" key:nil];
    self.payTypeView.markImageView.image = [UIImage imageNamed:@"更多-灰色"];
    [self.payTypeView adddMaskBtn];
    self.payTypeView.hintMsg = pushPublishService.payType;
    
    
    //收款期限
    self.payTimeLimitView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.payTypeView.yy, width, height)];
    [self.contentView addSubview:self.payTimeLimitView];
    self.payTimeLimitView.leftLbl.text = [LangSwitcher switchLang:@"收款期限" key:nil];
    self.payTimeLimitView.textField.placeholder = [LangSwitcher switchLang:@"请选择收款期限" key:nil];
    self.payTimeLimitView.markLbl.text = [LangSwitcher switchLang:@"分钟" key:nil];
    self.payTimeLimitView.textField.enabled = NO;
    [self.payTimeLimitView adddMaskBtn];
    self.payTimeLimitView.hintMsg = pushPublishService.payLimit;
    
    
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
    self.highLevelSettingsView.onlyTrustHint = pushPublishService.trust;
    self.highLevelSettingsView.displyTimeHint = pushPublishService.displayTime;
    
    //支付方式选择
    self.payTypePickerView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.payTypePickerView.autoSelectOne = YES;
    self.payTypePickerView.title = [LangSwitcher switchLang:@"请选择支付方式" key:nil];
    
    //超时时间
    self.payTimeLimitPickerView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.payTimeLimitPickerView.autoSelectOne = YES;
    
    //币种选择
    self.coinPickerView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.coinPickerView.autoSelectOne = YES;
    self.coinPickerView.tagNames = [CoinUtil shouldDisplayTokenCoinArray];
    
}

@end
