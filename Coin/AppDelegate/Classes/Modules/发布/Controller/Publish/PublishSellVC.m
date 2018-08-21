//
//  PublishSellVC.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "PublishSellVC.h"
#import "PublishSellView.h"

#import "OverTimeModel.h"
#import "QuotationModel.h"
#import "KeyValueModel.h"

#import "APICodeMacro.h"
#import "PublishService.h"
#import "UIBarButtonItem+convience.h"
#import "NSString+Check.h"
#import "CurrencyModel.h"
#import "NSString+Extension.h"

@interface PublishSellVC ()

@property (nonatomic, strong) PublishSellView *publishView;
//底部按钮
@property (nonatomic, strong) UIView *bottomView;
//data
@property (nonatomic, strong) NSMutableArray *timeArr;
//key/value
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*values;

@property (nonatomic, strong) AdvertiseModel *advertise;

@end

@implementation PublishSellVC

/**
 sb
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    @throw [NSException exceptionWithName:@"请使用 TLPublishSellVC" reason:@"*******" userInfo:nil];
    return;
    
    
    self.title =  [LangSwitcher switchLang:@"发布卖出" key:nil] ;
    
    self.timeArr = [NSMutableArray array];
    
    if (self.publishType == PublishTypePublishOrSaveDraft) {
        
        
        [self addRightItem];
        //发布卖出
        [self initPublishView];
        //获取收款期限
        [self requestOverTime];
        //查询以太币和比特币行情
        [self queryCoinQuotation];
        //获取提示
        [self requestTradeRemind];
        //
        [self getLeftAmount];
        
    } else {
        
        //先查询详情
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"625226";
        http.parameters[@"adsCode"] = self.adsCode;
        http.parameters[@"userId"] = [TLUser user].userId;
        [http postWithSuccess:^(id responseObject) {
            
        
            [self addRightItem];
            //发布卖出
            [self initPublishView];
            //获取收款期限
            [self requestOverTime];
            //查询以太币和比特币行情
            [self queryCoinQuotation];
            //获取提示
            [self requestTradeRemind];
            [self getLeftAmount];
            
            //
            self.advertise = [AdvertiseModel tl_objectWithDictionary:responseObject[@"data"]];
            self.publishView.advertise = self.advertise;
            
        } failure:^(NSError *error) {
            
            
        }];
        
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
            
            if ([obj.currency isEqualToString:@"ETH"]) {
                
               
//                NSString *str = [obj.amountString convertToSimpleRealCoin];
                NSString *str = [obj.amountString subNumber:obj.frozenAmountString];
//                str = [str convertToSimpleRealCoin];
                weakSelf.publishView.balanceLbl.text = [NSString stringWithFormat:@"账户可用余额：%@",str];

            }
            
        }];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - Init
- (void)addRightItem {
    
    if (self.publishType == PublishTypePublishOrSaveDraft) {
    
        
        [UIBarButtonItem addRightItemWithTitle:[LangSwitcher switchLang:@"保存草稿" key:nil]
                                    titleColor:kTextColor
                                         frame:CGRectMake(0, 0, 70, 44)
                                            vc:self
                                        action:@selector(keepDraft)];
        
        
    } else if (self.publishType == PublishTypePublishRedit) {
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

- (void)initPublishView {
    
    CoinWeakSelf;
    
    self.publishView = [[PublishSellView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.publishView.sellBlock = ^(PublishDraftModel *draft) {
        
        [weakSelf publishAdvertisementWithDraft:draft];
    };
    
    self.publishView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.publishView];
    
}

#pragma mark - Events
- (void)keepDraft {
    
    PublishDraftModel *draft = [PublishDraftModel new];
    
    draft.protectPrice = self.publishView.lowNumTF.text;
    
    draft.premiumRate = self.publishView.premiumRateTF.text;
    
    draft.minTrade = self.publishView.minNumTF.text;
    
    draft.maxTrade = self.publishView.maxNumTF.text;
    
    draft.buyTotal = self.publishView.buyTotalTF.text;
    
    draft.payType = [NSString stringWithFormat:@"%ld", self.publishView.payTypeIndex];
    
    draft.payLimit = self.publishView.payLimitPicker.text;
    
    draft.leaveMessage = self.publishView.leaveMsgTV.text;
    
    draft.isPublish = NO;
    
    draft.onlyTrust = [NSString stringWithFormat:@"%d", self.publishView.onlyTrustBtn.selected];

    [self publishAdvertisementWithDraft:draft];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.publishView.scrollView.contentSize = CGSizeMake(kScreenWidth, self.publishView.highSettingView.yy + 10);
}

#pragma mark - Data
- (void)requestOverTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625907";
    
    http.parameters[@"parentKey"] = @"trade_time_out";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray <OverTimeModel *>*data = [OverTimeModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
        
        [[data reversedArray]  enumerateObjectsUsingBlock:^(OverTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.timeArr addObject:obj.dvalue];
            
        }];
        
        self.publishView.timeArr = [self.timeArr copy];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)publishAdvertisementWithDraft:(PublishDraftModel *)draft {
    
    CoinWeakSelf;
    
    if (![draft.premiumRate valid]) {
        
        [TLAlert alertWithInfo:@"请输入溢价比例"];
        return ;
    }
    
    if (![draft.protectPrice valid]) {
        
        [TLAlert alertWithInfo:@"请输入最低可成交的价格"];
        return ;
    }
    
    if (![draft.minTrade valid]) {
        
        [TLAlert alertWithInfo:@"请输入交易的最小限额"];
        return ;
    }
    
    if (![draft.maxTrade valid]) {
        
        [TLAlert alertWithInfo:@"请输入交易的最大限额"];
        return ;
    }
    
    if (![draft.buyTotal valid]) {
        
        [TLAlert alertWithInfo:@"请输入出售总量"];
        return ;
    }
    
    if (![draft.payType valid]) {
        
        [TLAlert alertWithInfo:@"请选择收款方式"];
        return ;
    }
    
    if (![draft.payLimit valid]) {
        
        [TLAlert alertWithInfo:@"请选择收款期限"];
        return ;
    }
    
    if (![draft.leaveMessage valid]) {
        
        [TLAlert alertWithInfo:@"请填写广告留言"];
        return ;
    }
    
    CGFloat rate = [draft.premiumRate doubleValue]/100.0;
    
    NSString *premiumRate = [NSString stringWithFormat:@"%.4lf", rate];
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"625220";
    
    if (self.publishType == PublishTypePublishDraft) {
        
        http.parameters[@"publishType"] = kPublishDraft;
        http.parameters[@"adsCode"] = self.advertise.code;

    } else if (self.publishType == PublishTypePublishRedit) {
        
        http.parameters[@"publishType"] = kPublishRedit;
        http.parameters[@"adsCode"] = self.advertise.code;

    } else if (self.publishType == PublishTypePublishOrSaveDraft) {
        
        //发布或者存草稿
        http.parameters[@"publishType"] = draft.isPublish == YES ? kPublish : kSaveDraft;

    }

    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"leaveMessage"] = draft.leaveMessage;
    http.parameters[@"maxTrade"] = draft.maxTrade;
    http.parameters[@"minTrade"] = draft.minTrade;
    http.parameters[@"onlyTrust"] = draft.onlyTrust;
    http.parameters[@"payLimit"] = draft.payLimit;
    http.parameters[@"payType"] = draft.payType;
    http.parameters[@"premiumRate"] = premiumRate;
    http.parameters[@"protectPrice"] = draft.protectPrice;
//    http.parameters[@"totalCount"] = [draft.buyTotal convertToSysCoin];
//    http.parameters[@"tradeCurrency"] = @"CNY";
    http.parameters[@"tradeCoin"] = @"ETH";
    //0=买币, 1=卖币
    http.parameters[@"tradeType"] = @"1";
    
    //
    if (!self.publishView.anyTimeBtn.selected) {
        
        NSMutableArray *timeArr = [NSMutableArray array];
        
        [self.publishView.startHourArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *weekDay = [NSString stringWithFormat:@"%ld", idx+1];
            
            NSDictionary *temp = @{@"startTime": obj,
                                   @"endTime": weakSelf.publishView.endHourArr[idx],
                                   @"week": weekDay,
                                   };
            
            [timeArr addObject:temp];
        }];
        
        http.parameters[@"displayTime"] = timeArr;
    }
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *str = draft.isPublish == YES ? @"发布成功": @"保存成功";
        
        [TLAlert alertWithSucces:str];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.tabBarController.selectedIndex = 2;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kAdvertiseListRefresh object:@"0"];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)queryCoinQuotation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"625292";
    http.parameters[@"coin"] = @"ETH";
    [http postWithSuccess:^(id responseObject) {
        
        QuotationModel *model = [QuotationModel tl_objectWithDictionary:responseObject[@"data"]];
        
        self.publishView.marketPrice = [NSString stringWithFormat:@"%.2lf", [model.mid doubleValue]];

        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestTradeRemind {
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"625915";
    
    helper.start = 1;
    helper.limit = 30;
    
    helper.parameters[@"type"] = @"sell_ads_hint";
    
    [helper modelClass:[KeyValueModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        self.publishView.values = objs;
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
