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
//#import "CustomPickerView.h"
#import "FilterView.h"

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
    
    //行情
    [self hangQing];
    
    
    //交易提示
    
    //支付方式
    
    //时间选择

    
    
    //可选 广告详情

}

- (void)hangQing {
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"625292";
    http.parameters[@"coin"] = kETH;
    http.showView = self.view;
    //
    [http postWithSuccess:^(id responseObject) {
        
        [self removePlaceholderView];
        
        [self setUpUI];
        //
        [self addLayout];
        //
        [self data];
        //
        [self addEvent];
        
        //
//        self.pa
        
        self.quotationModel = [QuotationModel tl_objectWithDictionary:responseObject[@"data"]];
        self.priceView.textField.text = [NSString stringWithFormat:@"%.2lf", [self.quotationModel.mid doubleValue]];
        
   
        
        
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];
        
    }];
    
}

#pragma mark- 组装数据
- (void)submit {
    
    
//    PublishDraftModel *draft = [PublishDraftModel new];
//
//    draft.protectPrice = self.protectPriceView.textField.text;
//    draft.premiumRate = self.premiumView.textField.text;
//
//    draft.minTrade = self.minTradeAmountView.textField.text;
//    draft.maxTrade = self.maxTradeAmountView.textField.text;
//    draft.buyTotal = self.buyTotalTF.text;
//
//    //支付方式
//    draft.payType = [NSString stringWithFormat:@"%ld", _payTypeIndex];
//
//    draft.payLimit = self.payLimitPicker.text;
//    draft.leaveMessage = self.leaveMsgTV.text;
//
//    //发布或者草稿
//    draft.isPublish = YES;
//
//    //仅限受信任的人
//    draft.onlyTrust = [NSString stringWithFormat:@"%d", self.onlyTrustBtn.selected];
    
    
}


#pragma mark -提交事件
- (void)publishAdvertisementWithDraft {
    
    NSString *premium = self.premiumView.textField.text;
    NSString *protectPrice = self.protectPriceView.textField.text;
    NSString *min = self.minTradeAmountView.textField.text;
    NSString *max = self.maxTradeAmountView.textField.text;
    NSString *payTimeLimit = self.payTimeLimitView.textField.text;
    NSString *leaveMsg = self.leaveMsgTextView.text;
    NSString *totalCount = self.totalTradeCountView.textField.text;

    NSString *payType = nil;
    NSString *onlyTrust = nil;
    
    NSString *tradeType = nil;
//    NSString *publishType = nil;

    
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
//        http.parameters[@"publishType"] = draft.isPublish == YES ? kPublish : kSaveDraft;
        
    }
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"token"] = [TLUser user].token;
    http.parameters[@"leaveMessage"] = leaveMsg;
    http.parameters[@"maxTrade"] = max;
    http.parameters[@"minTrade"] = min;
    http.parameters[@"onlyTrust"] = onlyTrust;
    http.parameters[@"payLimit"] = payTimeLimit;
    http.parameters[@"payType"] = payType;
    http.parameters[@"premiumRate"] = premium;
    http.parameters[@"protectPrice"] = protectPrice;
    http.parameters[@"totalCount"] = totalCount;
    http.parameters[@"tradeCurrency"] = @"CNY";
    http.parameters[@"tradeCoin"] = kETH;
    http.parameters[@"tradeType"] = tradeType;
    
    //   提交时间
//    if (!self.publishView.anyTimeBtn.selected) {
//
//        NSMutableArray *timeArr = [NSMutableArray array];
//
//        [self.publishView.startHourArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            NSString *weekDay = [NSString stringWithFormat:@"%ld", idx+1];
//
//            NSDictionary *temp = @{@"startTime": obj,
//                                   @"endTime": weakSelf.publishView.endHourArr[idx],
//                                   @"week": weekDay,
//                                   };
//
//            [timeArr addObject:temp];
//        }];
//
//        http.parameters[@"displayTime"] = timeArr;
//    }
    
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
    
    
}

#pragma mark- 选择付款期限
- (void)choosePayLimit {
    
    
}

#pragma mark- 添加事件
- (void)addEvent {
    
    [self.highLevelSettingsView.topBtn addTarget:self
                                          action:@selector(change)
                                forControlEvents:UIControlEventTouchUpInside];
    [self.premiumView.textField addTarget:self
                                   action:@selector(textDidChange:)
                         forControlEvents:UIControlEventEditingChanged];
    
    //
    [self.payTypeView.maskBtn addTarget:self action:@selector(choosePayType) forControlEvents:UIControlEventTouchUpInside];
    [self.payTimeLimitView.maskBtn addTarget:self action:@selector(choosePayLimit) forControlEvents:UIControlEventTouchUpInside];

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
    
    self.balanceView.contentLbl.text = [NSString stringWithFormat:@"账户可用余额：%@",@"10.2"];
    
}


- (void)setUpUI {
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - 50)];
    [self.view addSubview:self.bgScrollView];
    
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
    
    //收款方式
    self.payTypeView = [[TLPublishInputView alloc] initWithFrame:CGRectMake(0, self.balanceView.yy, width, height)];
    [self.contentView addSubview:self.payTypeView];
//    self.payTypeView.textField.userInteractionEnabled = NO;
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
    
    
    //
    
    
    
}

@end
